import WebSocket from 'ws';

export async function queryCurrentProtocolParameters(ogmiosHttpUrl: string): Promise<any> {
  const url = ogmiosHttpUrl.replace(/^http/, 'ws');
  const ws = new WebSocket(url);
  const request = {
    type: 'jsonwsp/request',
    version: '1.0',
    servicename: 'ogmios',
    methodname: 'Query',
    args: {
      query: { currentProtocolParameters: null }
    }
  };
  return new Promise((resolve, reject) => {
    ws.on('open', () => ws.send(JSON.stringify(request)));
    ws.on('message', (data: any) => {
      try {
        const msg = JSON.parse(data.toString());
        if (msg.result && msg.result.currentProtocolParameters) {
          const p = msg.result.currentProtocolParameters;
          ws.close();
          resolve(p);
        } else if (msg.fault) {
          ws.close();
          reject(new Error(JSON.stringify(msg.fault)));
        }
      } catch (e) {
      }
    });
    ws.on('error', reject);
  });
}

export async function queryTip(ogmiosHttpUrl: string): Promise<any> {
  const url = ogmiosHttpUrl.replace(/^http/, 'ws');
  const ws = new WebSocket(url);
  const request = {
    type: 'jsonwsp/request',
    version: '1.0',
    servicename: 'ogmios',
    methodname: 'Query',
    args: {
      query: { chainTip: null }
    }
  };
  return new Promise((resolve, reject) => {
    ws.on('open', () => ws.send(JSON.stringify(request)));
    ws.on('message', (data: any) => {
      try {
        const msg = JSON.parse(data.toString());
        if (msg.result && msg.result.chainTip) {
          const tip = msg.result.chainTip;
          ws.close();
          resolve(tip);
        } else if (msg.fault) {
          ws.close();
          reject(new Error(JSON.stringify(msg.fault)));
        }
      } catch (e) {
      }
    });
    ws.on('error', reject);
  });
}
