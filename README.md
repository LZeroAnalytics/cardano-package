# Cardano Package

This package launches a local Cardano network with Kurtosis, exposes the Cardano Submit API for real transaction submission, and includes a working block explorer so you can see blocks and transactions. It also provides example scripts to create/fund a wallet, send ADA, and deploy a simple Plutus script end-to-end.

## Features

- Cardano node with custom devnet config
- Cardano Submit API (no mocks)
- Prefunded wallet creation
- Explorer stack (Ogmios + Kupo + Yaci Store + Yaci Viewer) that actually displays blocks/txs
- Example scripts:
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
- Submit API URL
- Explorer URL (Yaci Viewer)
- Funded wallet address and signing key path (inside the wallet-generator service)

### Service Access

```bash
# Inspect services
kurtosis enclave inspect cardano-local

# Logs
kurtosis service logs cardano-local cardano-node
kurtosis service logs cardano-local cardano-submit-api
kurtosis service logs cardano-local ogmios
kurtosis service logs cardano-local kupo
kurtosis service logs cardano-local yaci-store
kurtosis service logs cardano-local yaci-viewer
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
#   SUBMIT_API_URL=http://<submit-service>:8090
#   NETWORK_MAGIC=1097911063
#   WALLET_ADDRESS=<prefunded address>
#   SIGNING_KEY_PATH=/tmp/payment.skey

# Send 1 ADA to a new address
pnpm tsx send-ada.ts

# Deploy and interact with a simple Plutus script (spend/mint)
pnpm tsx deploy-plutus.ts
```

Both scripts submit real transactions via the Submit API and verify inclusion by querying the network. Check the explorer for the tx hash.

## Cleanup

```bash
kurtosis enclave rm -f cardano-local
```

## License

MIT License

[docker-installation]: https://docs.docker.com/get-docker/
[kurtosis-cli-installation]: https://docs.kurtosis.com/install
