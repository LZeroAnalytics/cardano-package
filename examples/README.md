Example scripts (TypeScript) using Ogmios tx-submission.

Prereqs:
- Node.js 18+
- pnpm (or npm/yarn)
- Kurtosis package running; find the Ogmios mapped port via: `kurtosis enclave inspect cardano-local` (service `cardano-node` port 1337 maps to localhost)

Setup:
- cd examples
- pnpm install
- Create .env with:
  OGMIOS_URL=http://127.0.0.1:<mapped_port>
  NETWORK_MAGIC=1097911063
  WALLET_ADDRESS=<prefunded_address_from_run_output>
  SIGNING_KEY_PATH=/tmp/payment.skey

Send ADA:
- pnpm run send-ada

Deploy simple Plutus script:
- pnpm run deploy-plutus

These scripts build transactions with cardano-cli and submit via Ogmios SubmitTx over WebSocket (no Submit API).
