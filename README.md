Cardano local devnet with explorer and examples

- Runs a preprod-like Cardano devnet with:
  - Ogmios (tx-submission and state query)
  - Kupo (UTxO indexer)
  - Yaci Store (indexer API)
  - Yaci Viewer (block explorer)
- Example scripts demonstrate sending ADA and deploying a simple Plutus script using Ogmios submission and Kupo/Ogmios for queries.

Quick start

1. Install prerequisites: Docker and Kurtosis.
2. Clean existing enclaves:
   kurtosis clean -a
3. Run the package (default config):
   kurtosis run --enclave cardano-local . 

Args file

You can pass an args YAML file to customize the run:
- prefunded_accounts: list of addresses to fund at genesis

Example args.yaml:
cardano_params:
  network_magic: 1097911063
additional_services:
  - cardano_explorer
prefunded_accounts:
  - address: addr_test1...
    amount: "10000000000"

Run with:
kurtosis run --enclave cardano-local . --args-file args.yaml

Service ports (mapped to localhost by Kurtosis):
- Ogmios: 1337
- Kupo: 1442
- Yaci Store API: 8080
- Yaci Viewer: 5173

Wallet

A development wallet is generated in the wallet-generator service with keys at:
- /tmp/payment.vkey
- /tmp/payment.skey
- Address at /tmp/wallet-address.txt

Explorer

Visit the Yaci Viewer at the mapped localhost port printed by Kurtosis. It should show live blocks and transactions.

Examples

1) Copy env:
cp examples/.env.example examples/.env
Set OGMIOS_URL and KUPO_URL to your mapped localhost ports, and set WALLET_ADDRESS to a funded address (either from prefunded_accounts or funded later). SIGNING_KEY_PATH should point to /tmp/payment.skey inside the wallet-generator service (the example scripts exec inside that service to read keys).

2) Install deps and run:
pnpm -C examples install
pnpm -C examples run send-ada
pnpm -C examples run deploy-plutus

Notes

- Examples do not use the Cardano Submit API or local node sockets. They query UTxOs via Kupo, protocol parameters via Ogmios, build/sign client-side, and submit via Ogmios.
- If UTxOs are not found, ensure the address is funded via genesis prefunds.
# Cardano Package

This package launches a local Cardano network with Kurtosis and includes a working block explorer so you can see blocks and transactions. It also provides example scripts to create/fund a wallet, send ADA, and deploy a simple Plutus script end-to-end. Transactions are submitted via Ogmios tx-submission (no Submit API required).

## Features

- Cardano node with built-in Ogmios (1337) on a local devnet
- Wallet generator + faucet funding flow (preprod-like)
- Explorer stack (Kupo + Yaci Store + Yaci Viewer) that actually displays blocks/txs
- Example scripts that submit via Ogmios tx-submission:
  - examples/send-ada.ts
  - examples/deploy-plutus.ts

## Prerequisites

1. [Install Docker & start the Docker Daemon][docker-installation]
2. [Install the Kurtosis CLI][kurtosis-cli-installation]
3. Node.js 18+ for running example scripts (pnpm or npm)
4. cardano-cli available in PATH for the example scripts (or run them inside a container with cardano-cli)

## Quick Start

### Run the network

```bash
kurtosis clean -a
kurtosis run --enclave cardano-local .
```

Or with custom configuration:

```bash
kurtosis run --enclave cardano-local . --args-file network_params.yaml
```

At the end of the run, Kurtosis will print:
- Ogmios port (mapped from container port 1337)
- Explorer URL (Yaci Viewer)
- Generated wallet address (inside the wallet-generator service)

### Service Access

```bash
# Inspect services
kurtosis enclave inspect cardano-local

# Logs
kurtosis service logs cardano-local cardano-node
kurtosis service logs cardano-local cardano-node
kurtosis service logs cardano-local kupo
kurtosis service logs cardano-local yaci-store
kurtosis service logs cardano-local cardano-explorer
```

### Explorer

The explorer UI (Yaci Viewer) URL will be printed at the end of `kurtosis run`. Open it and verify that blocks and transactions are displayed and the height increases.

## Example scripts

Install deps and run:

```bash
cd examples
pnpm i
# Configure environment variables or run inside the cardano-node container where cardano-cli is available.
# Required envs:
#   OGMIOS_URL=http://127.0.0.1:&lt;mapped_port&gt;
#   NETWORK_MAGIC=1097911063
#   WALLET_ADDRESS=<prefunded address>
#   SIGNING_KEY_PATH=/tmp/payment.skey

# Send 1 ADA to a new address
pnpm run send-ada

# Deploy and interact with a simple Plutus script (spend/mint)
pnpm run deploy-plutus
```

Both scripts submit real transactions via Ogmios tx-submission and verify inclusion by querying the network. Check the explorer for the tx hash.

## Cleanup

```bash
kurtosis enclave rm -f cardano-local
```

## License

MIT License

[docker-installation]: https://docs.docker.com/get-docker/
[kurtosis-cli-installation]: https://docs.kurtosis.com/install
