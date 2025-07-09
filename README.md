# Cardano LayerZero Package

This package enables LayerZero cross-chain messaging on Cardano by implementing LayerZero V2 protocol components using plu-ts smart contracts and Cardano's eUTXO model.

## Overview

This package provides:

1. **Cardano Node Deployment**: Spins up a Cardano network with LayerZero contracts
2. **LayerZero Contract Implementation**: EndpointV2, MessageLib, DVN, and Executor contracts ported to plu-ts
3. **Cross-Chain Services**: DVN and Executor off-chain services for Cardano integration
4. **OApp Support**: Example OApp implementation for cross-chain messaging testing

## Architecture

### Core Components

- **EndpointV2**: Main entry point for cross-chain messaging on Cardano
- **MessageLib**: Message encoding/decoding and routing logic
- **DVN (Data Verification Network)**: Cross-chain message verification
- **Executor**: Message execution on destination chain
- **OApp**: Application-level contract for cross-chain functionality

### UTXO Model Adaptations

Unlike Ethereum's account-based model, Cardano uses an extended UTXO (eUTXO) model:

- **State Management**: Contract state stored in UTXOs with datum/redeemer patterns
- **Nonce Tracking**: Separate UTXO chains for endpoint pair nonces
- **Message Flow**: Transactions consume input UTXOs and produce output UTXOs
- **Fee Handling**: Native ADA and custom tokens via Cardano's native token system

## Prerequisites

1. [Install Docker & start the Docker Daemon][docker-installation]
2. [Install the Kurtosis CLI][kurtosis-cli-installation]
3. Ensure you have access to Ethereum networks with LayerZero contracts deployed

## Quick Start

### Basic Usage

```bash
kurtosis run --enclave cardano-testnet github.com/LZeroAnalytics/cardano-package
```

### With Custom Configuration

```bash
kurtosis run --enclave cardano-testnet github.com/LZeroAnalytics/cardano-package --args-file network_params.yaml
```

### Configuration Example

```yaml
# Cardano network configuration
cardano_params:
  network: testnet
  slot_length: 1
  epoch_length: 432000
  security_param: 2160

# LayerZero configuration
layerzero_params:
  endpoint_id: "30199"  # Cardano endpoint ID
  dvn_fee: "1000000"    # 1 ADA in lovelace
  executor_fee: "2000000"  # 2 ADA in lovelace

# Cross-chain connections
connections:
  - from: ethereum
    to: cardano
    ethereum_rpc: "https://eth-mainnet.alchemyapi.io/v2/YOUR_KEY"
    ethereum_endpoint: "0x1a44076050125825900e736c501f859c50fE728c"
    private_key: "0x..."

# Additional services
additional_services:
  - cardano_explorer
  - dvn_service
  - executor_service
```

## Management

### Service Access

```bash
# Shell access to Cardano node
kurtosis service shell cardano-testnet cardano-node

# View service logs
kurtosis service logs cardano-testnet dvn-service
kurtosis service logs cardano-testnet executor-service
```

### Cleanup

```bash
kurtosis enclave rm -f cardano-testnet
```

## Development

### Contract Development

Contracts are implemented using [plu-ts](https://pluts.harmoniclabs.tech/), a TypeScript-embedded eDSL for Cardano smart contracts.

### Testing Cross-Chain Messages

1. Deploy Cardano network with LayerZero contracts
2. Deploy Ethereum network with LayerZero contracts  
3. Register OApp on both networks
4. Send test message from Ethereum to Cardano
5. Verify message execution on Cardano

## Technical Details

### UTXO State Management

```typescript
// Example: Endpoint state UTXO structure
const EndpointDatum = pstruct({
    EndpointState: {
        nonce: int,
        config: bytestring,
        peers: list(bytestring)
    }
});
```

### Message Flow

1. **Send**: Ethereum OApp → LayerZero Endpoint
2. **Monitor**: DVN service monitors Ethereum events
3. **Verify**: DVN service submits verification to Cardano DVN validator
4. **Execute**: Executor service processes verified message
5. **Deliver**: Message delivered to Cardano OApp

## Coming Soon

- [ ] Mainnet deployment support
- [ ] Advanced fee estimation
- [ ] Multi-signature DVN support
- [ ] Cardano native token bridging
- [ ] Performance optimizations

## License

MIT License

## Support

For issues and contributions, please open an issue on GitHub.

[docker-installation]: https://docs.docker.com/get-docker/
[kurtosis-cli-installation]: https://docs.kurtosis.com/install
