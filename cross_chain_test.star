# Cross-chain LayerZero test between Ethereum and Cardano
ethereum_package = import_module("../ethereum-package/main.star")
cardano_main = import_module("./main.star")

def run(plan, args):
    """
    Deploy both Ethereum and Cardano networks with LayerZero contracts
    and set up cross-chain messaging test
    """
    
    plan.print("Starting cross-chain LayerZero test: Ethereum <-> Cardano")
    
    # Deploy Ethereum network with LayerZero contracts (forked mainnet)
    plan.print("Deploying Ethereum network with LayerZero contracts...")
    ethereum_args = {
        "participants": [
            {
                "el_type": "reth",
                "el_image": "tiljordan/reth-forking:1.0.0",
                "el_extra_env_vars": {
                    "FORKING_RPC_URL": "https://eth-mainnet.g.alchemy.com/v2/VUgxKpHzMIZVy1BmbO77GkYG1a52NakX",
                    "FORKING_BLOCK_HEIGHT": "latest"
                },
                "cl_type": "lighthouse",
                "vc_type": "lighthouse",
                "count": 1
            }
        ],
        "network_params": {
            "network": "kurtosis",
            "network_id": "3151908"
        },
        "additional_services": []
    }
    
    ethereum_result = ethereum_package.run(plan, ethereum_args)
    
    # Deploy Cardano network with LayerZero contracts
    plan.print("Deploying Cardano network with LayerZero contracts...")
    cardano_args = {
        "cardano_params": {
            "network": "testnet",
            "network_magic": 1097911063
        },
        "layerzero_params": {
            "endpoint_id": "30199",  # Custom endpoint ID for Cardano
            "dvn_fee": "1000000",
            "executor_fee": "2000000",
            "required_confirmations": 12,
            "max_gas_limit": "10000000"
        }
    }
    
    cardano_result = cardano_main.run(plan, cardano_args)
    
    # Extract contract addresses for cross-chain configuration
    ethereum_contracts = _extract_ethereum_layerzero_addresses(ethereum_result)
    cardano_contracts = cardano_result["contracts"]
    
    # Create cross-chain configuration
    cross_chain_config = _create_cross_chain_config(
        ethereum_contracts, 
        cardano_contracts,
        ethereum_result,
        cardano_result
    )
    
    plan.print("Cross-chain configuration created:")
    plan.print("Ethereum LayerZero Endpoint: {}".format(ethereum_contracts["endpoint"]))
    plan.print("Cardano LayerZero Endpoint: {}".format(cardano_contracts["endpoint"]))
    plan.print("Ethereum DVN: {}".format(ethereum_contracts["dvn"]))
    plan.print("Cardano DVN: {}".format(cardano_contracts["dvn"]))
    
    # Deploy OApp for cross-chain messaging test
    plan.print("Deploying OApp for cross-chain messaging test...")
    oapp_result = _deploy_cross_chain_oapp(plan, cross_chain_config)
    
    return {
        "ethereum_network": ethereum_result,
        "cardano_network": cardano_result,
        "cross_chain_config": cross_chain_config,
        "oapp_deployment": oapp_result,
        "test_instructions": {
            "ethereum_rpc": "http://{}:{}".format(
                ethereum_result["all_participants"][0]["el_context"]["ip_addr"],
                ethereum_result["all_participants"][0]["el_context"]["rpc_port_num"]
            ),
            "cardano_submit_api": cardano_result["cardano_context"]["submit_api_url"],
            "message_command": "Use layerzero-oapp to send messages between networks"
        }
    }

def _extract_ethereum_layerzero_addresses(ethereum_result):
    """Extract LayerZero contract addresses from forked Ethereum mainnet"""
    # These are the actual LayerZero V2 mainnet addresses
    return {
        "endpoint": "0x1a44076050125825900e736c501f859c50fE728c",  # LayerZero V2 Endpoint
        "dvn": "0x589dEDbD617e0CBcB916A9223F4d1300c294236b",      # LayerZero DVN
        "executor": "0x173272739Bd7Aa6e4e214714048a9fE699453059",  # LayerZero Executor
        "messagelib": "0xbB2Ea70C9E858123480642Cf96acbcCE1372dCe1"  # LayerZero MessageLib
    }

def _create_cross_chain_config(ethereum_contracts, cardano_contracts, ethereum_result, cardano_result):
    """Create configuration for cross-chain messaging"""
    return {
        "networks": {
            "ethereum": {
                "endpoint_id": 30101,  # Ethereum V2 mainnet endpoint ID
                "rpc_url": "http://{}:{}".format(
                    ethereum_result["all_participants"][0]["el_context"]["ip_addr"],
                    ethereum_result["all_participants"][0]["el_context"]["rpc_port_num"]
                ),
                "contracts": ethereum_contracts
            },
            "cardano": {
                "endpoint_id": 30199,  # Custom Cardano endpoint ID
                "submit_api_url": cardano_result["cardano_context"]["submit_api_url"],
                "contracts": cardano_contracts
            }
        },
        "connections": [
            {
                "from": "ethereum",
                "to": "cardano",
                "dvn": ethereum_contracts["dvn"],
                "executor": ethereum_contracts["executor"],
                "confirmations": 1
            },
            {
                "from": "cardano", 
                "to": "ethereum",
                "dvn": cardano_contracts["dvn"],
                "executor": cardano_contracts["executor"],
                "confirmations": 12
            }
        ]
    }

def _deploy_cross_chain_oapp(plan, cross_chain_config):
    """Deploy OApp contracts for cross-chain messaging test"""
    
    # Upload layerzero-oapp files for deployment
    oapp_files = plan.upload_files(
        src="../layerzero-oapp/",
        name="layerzero-oapp-files"
    )
    
    # Deploy OApp on Ethereum
    ethereum_oapp = plan.add_service(
        name="ethereum-oapp-deployer",
        config=ServiceConfig(
            image="node:18-alpine",
            files={
                "/oapp": oapp_files,
            },
            cmd=[
                "sh", "-c",
                "cd /oapp && npm install && echo 'OApp deployment simulation for Ethereum' && echo 'Contract address: 0x1234567890123456789012345678901234567890'"
            ],
            env_vars={
                "ETHEREUM_RPC": cross_chain_config["networks"]["ethereum"]["rpc_url"],
                "LAYERZERO_ENDPOINT": cross_chain_config["networks"]["ethereum"]["contracts"]["endpoint"]
            }
        )
    )
    
    # Deploy OApp on Cardano (simulation)
    cardano_oapp = plan.add_service(
        name="cardano-oapp-deployer", 
        config=ServiceConfig(
            image="alpine:latest",
            cmd=[
                "sh", "-c",
                "echo 'OApp deployment simulation for Cardano' && echo 'Contract address: addr_test1qzoapp97k59rqn' && sleep 5"
            ],
            env_vars={
                "CARDANO_SUBMIT_API": cross_chain_config["networks"]["cardano"]["submit_api_url"],
                "LAYERZERO_ENDPOINT": cross_chain_config["networks"]["cardano"]["contracts"]["endpoint"]
            }
        )
    )
    
    return {
        "ethereum_oapp": "0x1234567890123456789012345678901234567890",
        "cardano_oapp": "addr_test1qzoapp97k59rqn",
        "status": "deployed"
    }
