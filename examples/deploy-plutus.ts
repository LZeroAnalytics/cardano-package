import 'dotenv/config';
import axios from "axios";
import { readFileSync, writeFileSync } from "fs";
import { execSync } from "child_process";
const SUBMIT_API_URL = process.env.SUBMIT_API_URL || "http://localhost:8090";
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
    cborHex: "4e4d01000033222220051200120011" // minimal noop validator CBOR (placeholder known good)
  }));

  const utxos = run(`cardano-cli query utxo --address ${WALLET_ADDRESS} --testnet-magic ${NETWORK_MAGIC}`);
  const lines = utxos.split("\n").slice(2).filter(Boolean);
  if (lines.length === 0) throw new Error("No UTXO available");
  const [txHash, txIx, , , amountStr] = lines[0].split(/\s+/);
  const txIn = `${txHash}#${txIx}`;

  run(`cardano-cli address build --payment-verification-key-file /tmp/pkh.vkey --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/change.addr || true`);
  writeFileSync("/tmp/change.addr", WALLET_ADDRESS);

  run(`cardano-cli transaction build --testnet-magic ${NETWORK_MAGIC} --tx-in ${txIn} --tx-out "$(cat /tmp/change.addr)+5000000" --change-address ${WALLET_ADDRESS} --out-file /tmp/plutus.raw`);

  run(`cardano-cli transaction sign --tx-body-file /tmp/plutus.raw --signing-key-file ${SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/plutus.signed`);

  const cbor = readFileSync("/tmp/plutus.signed");
  const res = await axios.post(`${SUBMIT_API_URL}/api/submit/tx`, cbor, {
    headers: { "Content-Type": "application/cbor" },
  });
  console.log("Submitted tx:", res.data);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
