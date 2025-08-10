import express from "express";
import 'dotenv/config';
import fs from "fs";
import { execSync } from "child_process";
import * as CSL from "@emurgo/cardano-serialization-lib-nodejs";

const app = express();
app.use(express.json());

const OGMIOS_URL = process.env.OGMIOS_URL || "http://127.0.0.1:1337";
const KUPO_URL = process.env.KUPO_URL || "http://127.0.0.1:1442";
const NETWORK_MAGIC = Number(process.env.NETWORK_MAGIC || "1097911063");
const FAUCET_SIGNING_KEY_PATH = process.env.FAUCET_SIGNING_KEY_PATH || "/app/keys/faucet.skey";
const FAUCET_ADDRESS = process.env.FAUCET_ADDRESS || "";

async function kupoUtxos(address) {
  const r = await fetch(`${KUPO_URL}/matches/${address}?unspent`);
  if (!r.ok) throw new Error("kupo error");
  const j = await r.json();
  return j.map((u) => ({
    txHash: u.transaction_id,
    index: u.output_index,
    value: u.value.coins
  }));
}

async function ogmiosQuery(method, params) {
  const { WebSocket } = await import('ws');
  const ws = new WebSocket(OGMIOS_URL.replace("http", "ws"));
  const req = {
    type: "jsonwsp/request",
    version: "1.0",
    servicename: "ogmios",
    methodname: method,
    args: params || {}
  };
  const res = await new Promise((resolve, reject) => {
    ws.on("open", () => ws.send(JSON.stringify(req)));
    ws.on("message", (data) => {
      try { resolve(JSON.parse(data.toString())); } catch (e) { reject(e); }
      ws.close();
    });
    ws.on("error", reject);
  });
  if (res.type !== "jsonwsp/response") throw new Error("ogmios bad response");
  return res.result;
}

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.post("/fund", async (req, res) => {
  try {
    const { address, amount } = req.body || {};
    if (!address || !amount) return res.status(400).json({ error: "address and amount required" });

    const faucetUtxos = await kupoUtxos(FAUCET_ADDRESS);
    if (faucetUtxos.length === 0) return res.status(500).json({ error: "faucet has no funds" });

    const params = await ogmiosQuery("Query", { query: { "currentProtocolParameters": null } });

    const cfg = CSL.TransactionBuilderConfigBuilder.new()
      .fee_algo(
        CSL.LinearFee.new(
          CSL.BigNum.from_str(String(params.minFeeA || params.minFeeCoefficient || "44")),
          CSL.BigNum.from_str(String(params.minFeeB || params.minFeeConstant || "155381"))
        )
      )
      .coins_per_utxo_byte(CSL.BigNum.from_str(String(params.coinsPerUtxoByte || "4310")))
      .max_tx_size(params.maxTxSize || 16384)
      .key_deposit(CSL.BigNum.from_str(String(params.stakeKeyDeposit || "0")))
      .build();

    const builder = CSL.TransactionBuilder.new(cfg);
    const faucetAddr = CSL.Address.from_bech32(FAUCET_ADDRESS);
    const recv = CSL.Address.from_bech32(address);

    const inU = faucetUtxos[0];
    const txIn = CSL.TransactionInput.new(CSL.TransactionHash.from_bytes(Buffer.from(inU.txHash, 'hex')), inU.index);
    builder.add_input(faucetAddr, txIn, CSL.Value.new(CSL.BigNum.from_str(String(inU.value))));

    builder.add_output(CSL.TransactionOutput.new(recv, CSL.Value.new(CSL.BigNum.from_str(String(amount)))));
    builder.add_change_if_needed(faucetAddr);

    const txBody = builder.build();
    const bodyHex = Buffer.from(txBody.to_bytes()).toString('hex');

    execSync(`printf %s ${bodyHex} | xxd -r -p > /tmp/faucet-tx.body`, { stdio: ["ignore", "pipe", "pipe"] });
    execSync(`cardano-cli transaction sign --tx-body-file /tmp/faucet-tx.body --signing-key-file ${FAUCET_SIGNING_KEY_PATH} --testnet-magic ${NETWORK_MAGIC} --out-file /tmp/faucet-tx.signed`, { stdio: ["ignore", "pipe", "pipe"] });
    const signedHex = execSync(`xxd -p -c 100000 /tmp/faucet-tx.signed | tr -d '\\n'`).toString().trim();

    const { WebSocket } = await import('ws');
    const ws = new WebSocket(OGMIOS_URL.replace("http","ws"));
    const submit = await new Promise((resolve, reject) => {
      ws.on("open", () => {
        ws.send(JSON.stringify({
          type: "jsonwsp/request",
          version: "1.0",
          servicename: "ogmios",
          methodname: "SubmitTx",
          args: { "submit": { "transaction": signedHex } }
        }));
      });
      ws.on("message", (data) => {
        try { resolve(JSON.parse(data.toString())); } catch (e) { reject(e); }
        ws.close();
      });
      ws.on("error", reject);
    });

    return res.json({ result: submit });
  } catch (e) {
    return res.status(500).json({ error: String(e && e.message || e) });
  }
});

const port = Number(process.env.PORT || 8081);
app.listen(port, () => {
  console.log(`faucet listening on ${port}`);
});
