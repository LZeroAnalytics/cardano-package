# Cardano Package Constants

# Default Cardano network parameters
DEFAULT_CARDANO_NETWORK = "testnet"
DEFAULT_SLOT_LENGTH = 1
DEFAULT_EPOCH_LENGTH = 432000
DEFAULT_SECURITY_PARAM = 2160
DEFAULT_NETWORK_MAGIC = 1097911063

# Service names
CARDANO_NODE_SERVICE = "cardano-node"
CARDANO_EXPLORER_SERVICE = "cardano-explorer"

# Container images
CARDANO_NODE_IMAGE = "cardanosolutions/cardano-node-ogmios:latest-preprod"
CARDANO_CLI_IMAGE = "cardanocommunity/cardano-node:latest"

# Explorer/indexer images
OGMIOS_IMAGE = "cardanosolutions/ogmios:latest"
KUPO_IMAGE = "cardanosolutions/kupo:latest"
YACI_STORE_IMAGE = "bloxbean/yaci-store:2.0.0-beta3"
YACI_VIEWER_IMAGE = "bloxbean/yaci-viewer:latest"

# Network ports
CARDANO_NODE_PORT = 6000
CARDANO_HTTP_PORT = 12798
CARDANO_SUBMIT_API_PORT = 8090
CARDANO_EXPLORER_PORT = 5173
FAUCET_PORT = 8081

# File paths
CARDANO_CONFIG_PATH = "/opt/cardano/cnode/priv"
CARDANO_DATA_PATH = "/opt/cardano/cnode/db"
CARDANO_SOCKET_PATH = "/opt/cardano/cnode/sockets/node0.socket"

# Default additional services
DEFAULT_ADDITIONAL_SERVICES = [
    "cardano_explorer"
]

# UTXO and transaction constants
MIN_UTXO_VALUE = "1000000"
TX_FEE_BUFFER = "500000"
MAX_TX_SIZE = 16384
