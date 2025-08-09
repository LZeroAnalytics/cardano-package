Cardano Examples

Environment

- Copy .env.example to .env and set:
  - OGMIOS_URL=http://127.0.0.1:&lt;mapped_ogmios_port&gt;
  - KUPO_URL=http://127.0.0.1:&lt;mapped_kupo_port&gt;
  - NETWORK_MAGIC=1097911063
  - WALLET_ADDRESS=&lt;funded address&gt;
  - SIGNING_KEY_PATH=/tmp/payment.skey

Funding

- Prefer specifying prefunded_accounts in the package args so WALLET_ADDRESS has UTxOs at genesis.

Run

pnpm install
pnpm run send-ada
pnpm run deploy-plutus

Implementation

- UTxOs are queried via Kupo HTTP.
- Protocol parameters are queried via Ogmios JSON-WSP.
- Transactions are built and signed client-side and submitted via Ogmios.
