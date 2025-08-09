import WebSocket, { RawData } from "ws";

export type TxCbor = string;

export async function submitTxOgmios(ogmiosUrl: string, txCbor: TxCbor): Promise<string> {
  const url = ogmiosUrl.replace(/^http/, "ws");
  const ws = new WebSocket(url);
  const request = {
    type: "jsonwsp/request",
    version: "1.0",
    servicename: "ogmios",
    methodname: "SubmitTx",
    args: {
      submit: {
        transaction: {
          cbor: txCbor
        }
      }
    }
  };
  return new Promise((resolve, reject) => {
    ws.on("open", () => {
      ws.send(JSON.stringify(request));
    });
    ws.on("message", (data: RawData) => {
      try {
        const msg = JSON.parse(data.toString());
        if (msg.result && msg.result[0] && msg.result[0].Acceptance) {
          const txId = msg.result[0].Acceptance.txId || msg.result[0].Acceptance;
          ws.close();
          resolve(txId);
        } else if (msg.result && msg.result[0] && msg.result[0].Reject) {
          ws.close();
          reject(new Error("Tx rejected: " + JSON.stringify(msg.result[0].Reject)));
        }
      } catch (e) {
      }
    });
    ws.on("error", (err: Error) => {
      reject(err);
    });
    ws.on("close", () => {
    });
  });
}
