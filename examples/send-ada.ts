import 'dotenv/config';
import { readFileSync } from "fs";
import { execSync } from "child_process";
import { submitTxOgmios } from "./ogmios";

const OGMIOS_URL = process.env.OGMIOS_URL || "http://localhost:1337";
const NETWORK_MAGIC = process.env.NETWORK_MAGIC || "1097911063";
const WALLET_ADDRESS = process.env.WALLET_ADDRESS || "";
const SIGNING_KEY_PATH = process.env.SIGNING_KEY_PATH || "/tmp/payment.skey";

function run(cmd: string): string {
  return execSync(cmd, { stdio: ["ignore", "pipe", "inherit"] }).toString().trim();
}

async function main() {
  if (!WALLET_ADDRESS) {
    throw new Error("Set WALLET_ADDRESS env var to the funded wallet address created by the package");
  }
  readFileSync(SIGNING_KEY_PATH);

  const recvAddr = run(`cardano-cli address build --payment-verification-key-file /tmp/recv.vkey --testnet-magic ${NETWORK_MAGIC} || true >/dev/null 2>&1 && cat /tmp/recv.addr || (cardano-cli address key-gen --verification-key-file /tmp/recv.vkey --signing-key-file /tmp/recv.skey && cardano-cli address build --payment-verification-key-file /tmp/recv.vkey --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/recv.addr && cat /tmp/recv.addr)`);

  const utxos = run(`cardano-cli query utxo --address ${WALLET_ADDRESS} --testnet-magic ${NETWORK_MAGIC}`);
  const lines = utxos.split("\n").slice(2).filter(Boolean);
  if (lines.length === 0) throw new Error("No UTXO available");
  const [txHash, txIx] = lines[0].split(/\s+/);
  const txIn = `${txHash}#${txIx}`;

  run(`cardano-cli transaction build --testnet-magic ${NETWORK_MAGIC} --tx-in ${txIn} --tx-out "${recvAddr}+1000000" --change-address ${WALLET_ADDRESS} --out-file /tmp/send-ada.raw`);
  run(`cardano-cli transaction sign --tx-body-file /tmp/send-ada.raw --signing-key-file ${SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/send-ada.signed`);
  const cborHex = readFileSync("/tmp/send-ada.signed").toString("hex");

  const txId = await submitTxOgmios(OGMIOS_URL, cborHex);
  console.log("Submitted tx via Ogmios:", txId);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
