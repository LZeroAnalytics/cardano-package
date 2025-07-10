# Cardano LayerZero Package Constants

# Default Cardano network parameters
DEFAULT_CARDANO_NETWORK = "testnet"
DEFAULT_SLOT_LENGTH = 1
DEFAULT_EPOCH_LENGTH = 432000
DEFAULT_SECURITY_PARAM = 2160
DEFAULT_NETWORK_MAGIC = 1097911063

# LayerZero protocol constants
CARDANO_ENDPOINT_ID = "30199"
DEFAULT_DVN_FEE = "1000000"      # 1 ADA in lovelace
DEFAULT_EXECUTOR_FEE = "2000000" # 2 ADA in lovelace
DEFAULT_CONFIRMATIONS = 12
DEFAULT_GAS_LIMIT = "10000000"

# Service names
CARDANO_NODE_SERVICE = "cardano-node"
DVN_SERVICE_PREFIX = "dvn-service"
EXECUTOR_SERVICE_PREFIX = "executor-service"
CARDANO_EXPLORER_SERVICE = "cardano-explorer"

# Container images
CARDANO_NODE_IMAGE = "cardanocommunity/cardano-node:latest"
CARDANO_CLI_IMAGE = "cardanocommunity/cardano-node:latest"  # Use same image as node for CLI
CARDANO_DB_SYNC_IMAGE = "cardanocommunity/cardano-db-sync:latest"
POSTGRES_IMAGE = "postgres:15"

# plu-ts development images
PLUTUS_IMAGE = "plutus/plutus:latest"
PLU_TS_IMAGE = "node:18-alpine"  # Use standard Node.js image for plu-ts

# Network ports
CARDANO_NODE_PORT = 6000  # cardanocommunity image uses port 6000
CARDANO_HTTP_PORT = 12798  # HTTP monitoring port
CARDANO_SUBMIT_API_PORT = 8090
CARDANO_GRAPHQL_PORT = 3100
CARDANO_EXPLORER_PORT = 3000

# File paths
CARDANO_CONFIG_PATH = "/opt/cardano/cnode/priv"  # Mount to priv directory as specified in Guild Operators documentation
CARDANO_DATA_PATH = "/opt/cardano/cnode/db"
CARDANO_SOCKET_PATH = "/opt/cardano/cnode/sockets/node0.socket"

# Default additional services
DEFAULT_ADDITIONAL_SERVICES = [
    "cardano_explorer",
    "dvn_service", 
    "executor_service"
]

# Default resource limits
DEFAULT_RESOURCE_LIMITS = {
    "cardano_node": {
        "cpu": "2000m",
        "memory": "4Gi", 
        "storage": "100Gi"
    },
    "dvn_service": {
        "cpu": "500m",
        "memory": "1Gi"
    },
    "executor_service": {
        "cpu": "500m", 
        "memory": "1Gi"
    }
}

# Contract deployment constants
ENDPOINT_CONTRACT_NAME = "LayerZeroEndpointV2"
MESSAGELIB_CONTRACT_NAME = "MessageLib"
DVN_CONTRACT_NAME = "DVN"
EXECUTOR_CONTRACT_NAME = "Executor"
OAPP_CONTRACT_NAME = "OApp"

# UTXO and transaction constants
MIN_UTXO_VALUE = "1000000"  # 1 ADA minimum UTXO value
TX_FEE_BUFFER = "500000"    # 0.5 ADA buffer for transaction fees
MAX_TX_SIZE = 16384         # Maximum transaction size in bytes

# Cross-chain messaging constants
MESSAGE_TIMEOUT = 3600      # 1 hour timeout for cross-chain messages
MAX_MESSAGE_SIZE = 1024     # Maximum message payload size
NONCE_STEP = 1             # Nonce increment step
