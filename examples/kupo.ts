import 'dotenv/config';

export type KupoUtxo = {
  transaction_id: string;
  output_index: number;
  address: string;
  value?: unknown;
};

const KUPO_URL = process.env.KUPO_URL || 'http://127.0.0.1:1442';

export async function getAddressUtxos(address: string): Promise<KupoUtxo[]> {
  const url = `${KUPO_URL}/matches/${encodeURIComponent(address)}?unspent`;
  const res = await fetch(url);
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Kupo error ${res.status}: ${text}`);
  }
  const data = await res.json();
  return data as KupoUtxo[];
}
