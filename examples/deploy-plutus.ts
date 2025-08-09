import 'dotenv/config';
import { readFileSync, writeFileSync } from "fs";
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

  writeFileSync("/tmp/alwayssucceeds.plutus", JSON.stringify({
    type: "PlutusScriptV2",
    description: "Always succeeds",
    cborHex: "4e4d01000033222220051200120011"
  }));

  const utxos = run(`cardano-cli query utxo --address ${WALLET_ADDRESS} --testnet-magic ${NETWORK_MAGIC}`);
  const lines = utxos.split("\n").slice(2).filter(Boolean);
  if (lines.length === 0) throw new Error("No UTXO available");
  const [txHash, txIx] = lines[0].split(/\s+/);
  const txIn = `${txHash}#${txIx}`;

  run(`cardano-cli address build --payment-verification-key-file /tmp/pkh.vkey --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/change.addr || true`);
  run(`bash -lc 'echo "${WALLET_ADDRESS}" > /tmp/change.addr'`);

  run(`cardano-cli transaction build --testnet-magic ${NETWORK_MAGIC} --tx-in ${txIn} --tx-out "$(cat /tmp/change.addr)+5000000" --change-address ${WALLET_ADDRESS} --out-file /tmp/plutus.raw`);

  run(`cardano-cli transaction sign --tx-body-file /tmp/plutus.raw --signing-key-file ${SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/plutus.signed`);

  const cborHex = readFileSync("/tmp/plutus.signed").toString("hex");
  const txId = await submitTxOgmios(OGMIOS_URL, cborHex);
  console.log("Submitted tx via Ogmios:", txId);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
