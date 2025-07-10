constants = import_module("../package_io/constants.star")

def launch_cardano_node(plan, cardano_params, layerzero_params):
    """
    Launch a Cardano node with LayerZero configuration
    
    Args:
        plan: Kurtosis plan object
        cardano_params: Cardano network configuration
        layerzero_params: LayerZero protocol configuration
        
    Returns:
        Cardano context with node information and LayerZero setup
    """
    
    plan.print("Launching Cardano node with network: {}".format(cardano_params.network))
    
    # Generate Cardano network configuration files
    config_files = _generate_cardano_config(plan, cardano_params)
    
    # Launch Cardano node using cardanocommunity/cardano-node image format
    cardano_node_service = plan.add_service(
        name=constants.CARDANO_NODE_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            ports={
                "node": PortSpec(
                    number=6000,  # cardanocommunity image uses port 6000
                    transport_protocol="TCP"
                ),
                "http": PortSpec(
                    number=12798,  # HTTP monitoring port
                    transport_protocol="TCP"
                )
            },
            files={
                "/conf/testnet": config_files,  # Mount to conf/testnet as expected by cardanocommunity image
            },
            env_vars={
                "NETWORK": cardano_params.network,  # Required by cardanocommunity image
                "CARDANO_NODE_SOCKET_PATH": "/opt/cardano/cnode/sockets/node0.socket"
            }
        )
    )
    
    # Wait for Cardano node to be ready (check if node port is accessible)
    plan.wait(
        service_name=constants.CARDANO_NODE_SERVICE,
        recipe=ExecRecipe(
            command=["sh", "-c", "netstat -ln | grep :6000 || ss -ln | grep :6000"]
        ),
        field="code",
        assertion="==",
        target_value=0,  # Command should succeed when port is listening
        timeout="300s"
    )
    
    # Launch Cardano submit API service
    submit_api_service = plan.add_service(
        name="cardano-submit-api",
        config=ServiceConfig(
            image="apexpool/cardano-submit-api:latest",
            ports={
                "api": PortSpec(
                    number=8090,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/config": config_files,
            },
            cmd=[
                "cardano-submit-api",
                "--config", "/opt/cardano/config/submit-api.json",
                "--socket-path", "/opt/cardano/ipc/socket",
                "--port", "8090",
                "--listen-address", "0.0.0.0"
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": constants.CARDANO_SOCKET_PATH
            }
        )
    )
    
    # Create LayerZero-specific configuration
    layerzero_config = _setup_layerzero_config(plan, layerzero_params)
    
    return struct(
        node_service=cardano_node_service,
        submit_api_service=submit_api_service,
        node_ip=cardano_node_service.ip_address,
        node_port=6000,  # Updated to match cardanocommunity image
        submit_api_url="http://{}:{}".format(
            submit_api_service.ip_address, 
            8090
        ),
        socket_path=constants.CARDANO_SOCKET_PATH,
        network=cardano_params.network,
        network_magic=cardano_params.network_magic,
        layerzero_config=layerzero_config
    )

def _generate_cardano_config(plan, cardano_params):
    """Generate Cardano node configuration files"""
    
    # Use the existing static configuration files
    config_files = plan.upload_files(
        src="static_files/cardano_config/",
        name="cardano-config-files"
    )
    
    return config_files

def _setup_layerzero_config(plan, layerzero_params):
    """Setup LayerZero-specific configuration for Cardano"""
    
    return struct(
        endpoint_id=layerzero_params.endpoint_id,
        dvn_fee=layerzero_params.dvn_fee,
        executor_fee=layerzero_params.executor_fee,
        required_confirmations=layerzero_params.required_confirmations,
        max_gas_limit=layerzero_params.max_gas_limit
    )
