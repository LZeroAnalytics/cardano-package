import 'dotenv/config';
import { execSync } from "child_process";
import { submitTxOgmios } from "./ogmios";
import { getAddressUtxos } from "./kupo";
import { queryCurrentProtocolParameters } from "./ogmios_query";
import * as CSL from "@emurgo/cardano-serialization-lib-nodejs";

const OGMIOS_URL = process.env.OGMIOS_URL || "http://localhost:1337";
const NETWORK_MAGIC = Number(process.env.NETWORK_MAGIC || "1097911063");
const WALLET_ADDRESS = process.env.WALLET_ADDRESS || "";
const SIGNING_KEY_PATH = process.env.SIGNING_KEY_PATH || "/tmp/payment.skey";

function runInWallet(cmd: string): string {
  const full = `kurtosis service exec cardano-local wallet-generator "bash -lc '${cmd}'"`;
  return execSync(full, { stdio: ["ignore", "pipe", "inherit"] }).toString().trim();
}

async function main() {
  if (!WALLET_ADDRESS) {
    throw new Error("Set WALLET_ADDRESS env var to the funded wallet address created by the package");
  }
  runInWallet(`test -f ${SIGNING_KEY_PATH}`);

  const recvAddr = runInWallet(`if [ -f /tmp/recv.addr ]; then cat /tmp/recv.addr; else \
cardano-cli address key-gen --verification-key-file /tmp/recv.vkey --signing-key-file /tmp/recv.skey && \
cardano-cli address build --payment-verification-key-file /tmp/recv.vkey --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/recv.addr && \
cat /tmp/recv.addr; fi`);

  const utxos = await getAddressUtxos(WALLET_ADDRESS);
  if (utxos.length === 0) throw new Error("No UTXO available on the funding address. Fund it first.");
  const first = utxos[0];

  const protocolParams = await queryCurrentProtocolParameters(OGMIOS_URL);

  const txBuilderCfg = CSL.TransactionBuilderConfigBuilder.new()
    .fee_algo(
      CSL.LinearFee.new(
        CSL.BigNum.from_str(String(protocolParams.minFeeA || protocolParams.minFeeCoefficient || "44")),
        CSL.BigNum.from_str(String(protocolParams.minFeeB || protocolParams.minFeeConstant || "155381"))
      )
    )
    .coins_per_utxo_byte(CSL.BigNum.from_str(String(protocolParams.coinsPerUtxoByte || "4310")))
    .max_tx_size(protocolParams.maxTxSize || 16384)
    .key_deposit(CSL.BigNum.from_str(String(protocolParams.stakeKeyDeposit || "0")))
    .build();

  const builder = CSL.TransactionBuilder.new(txBuilderCfg);

  const recv = CSL.Address.from_bech32(recvAddr);
  const sender = CSL.Address.from_bech32(WALLET_ADDRESS);

  const input = CSL.TransactionInput.new(
    CSL.TransactionHash.from_bytes(Buffer.from(first.transaction_id, 'hex')),
    first.output_index
  );
  const inputValue = CSL.Value.new(CSL.BigNum.from_str("2000000"));
  builder.add_input(sender, input, inputValue);

  const out = CSL.TransactionOutput.new(recv, CSL.Value.new(CSL.BigNum.from_str("1000000")));
  builder.add_output(out);

  builder.add_change_if_needed(sender);

  const body = builder.build();

  const bodyHex = Buffer.from(body.to_bytes()).toString('hex');
  runInWallet(`printf %s ${bodyHex} | xxd -r -p > /tmp/send-ada.body`);
  runInWallet(`cardano-cli transaction sign --tx-body-file /tmp/send-ada.body --signing-key-file ${SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/send-ada.signed`);

  const signedCborHex = runInWallet("xxd -p -c 100000 /tmp/send-ada.signed | tr -d '\\n'");
  const txId = await submitTxOgmios(OGMIOS_URL, signedCborHex);
  console.log("Submitted tx via Ogmios:", txId);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
