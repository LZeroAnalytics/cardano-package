import 'dotenv/config';
import { execSync } from "child_process";
import { submitTxOgmios } from "./ogmios";

const OGMIOS_URL = process.env.OGMIOS_URL || "http://localhost:1337";
const NETWORK_MAGIC = process.env.NETWORK_MAGIC || "1097911063";
const WALLET_ADDRESS = process.env.WALLET_ADDRESS || "";
const SIGNING_KEY_PATH = process.env.SIGNING_KEY_PATH || "/tmp/payment.skey";

function runInWallet(cmd: string): string {
  const full = `kurtosis service exec cardano-local wallet-generator -- bash -lc '${cmd}'`;
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

  const utxos = runInWallet(`cardano-cli query utxo --address ${WALLET_ADDRESS} --testnet-magic ${NETWORK_MAGIC}`);
  const lines = utxos.split("\\n").slice(2).filter(Boolean);
  if (lines.length === 0) throw new Error("No UTXO available on the funding address. Fund it via the preprod faucet first.");
  const [txHash, txIx] = lines[0].split(/\\s+/);
  const txIn = `${txHash}#${txIx}`;

  runInWallet(`cardano-cli transaction build --testnet-magic ${NETWORK_MAGIC} --tx-in ${txIn} --tx-out "${recvAddr}+1000000" --change-address ${WALLET_ADDRESS} --out-file /tmp/send-ada.raw`);
  runInWallet(`cardano-cli transaction sign --tx-body-file /tmp/send-ada.raw --signing-key-file ${SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/send-ada.signed`);

  const cborHex = runInWallet("xxd -p -c 100000 /tmp/send-ada.signed | tr -d '\\n'");

  const txId = await submitTxOgmios(OGMIOS_URL, cborHex);
  console.log("Submitted tx via Ogmios:", txId);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
