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
    
    # Launch Cardano node
    cardano_node_service = plan.add_service(
        name=constants.CARDANO_NODE_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            ports={
                "node": PortSpec(
                    number=constants.CARDANO_NODE_PORT,
                    transport_protocol="TCP"
                ),
                "submit-api": PortSpec(
                    number=constants.CARDANO_SUBMIT_API_PORT,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/config": config_files,
            },
            cmd=[
                "cardano-node", "run",
                "--config", "/opt/cardano/config/config.json",
                "--topology", "/opt/cardano/config/topology.json", 
                "--database-path", "/opt/cardano/data",
                "--socket-path", "/opt/cardano/ipc/socket",
                "--host-addr", "0.0.0.0",
                "--port", str(constants.CARDANO_NODE_PORT)
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": constants.CARDANO_SOCKET_PATH
            }
        )
    )
    
    # Wait for Cardano node to be ready
    plan.wait(
        service_name=constants.CARDANO_NODE_SERVICE,
        recipe=GetHttpRequestRecipe(
            port_id="submit-api",
            endpoint="/api/submit/tx"
        ),
        field="code",
        assertion="==",
        target_value=405,  # Method not allowed is expected for GET on submit endpoint
        timeout="300s"
    )
    
    # Launch Cardano submit API service
    submit_api_service = plan.add_service(
        name="cardano-submit-api",
        config=ServiceConfig(
            image="inputoutput/cardano-submit-api:latest",
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
        node_port=constants.CARDANO_NODE_PORT,
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
    
    # Basic node configuration
    config_json = {
        "AlonzoGenesisFile": "alonzo-genesis.json",
        "AlonzoGenesisHash": "7e94a15f55d1e82d10f09203fa04bd80b016838e2ed3f0b7e5b175a65c1a99a7",
        "ByronGenesisFile": "byron-genesis.json", 
        "ByronGenesisHash": "5f20df933584822601f9e3f8c024eb5eb252fe8cefb24d1317dc3d432e940ebb",
        "ConwayGenesisFile": "conway-genesis.json",
        "ConwayGenesisHash": "f28f1c1280ea0d32f8cd3143e268650d6c1a8e221522ce4a7d20d62fc09783b7",
        "ShelleyGenesisFile": "shelley-genesis.json",
        "ShelleyGenesisHash": "1a3be38bcbb7911969283716ad7aa550250226b76a61fc51cc9a9a35d9276d81",
        "Protocol": "Cardano",
        "RequiresNetworkMagic": "RequiresNoMagic" if cardano_params.network == "mainnet" else "RequiresMagic",
        "EnableLogMetrics": False,
        "EnableLogging": True,
        "hasEKG": 12788,
        "hasPrometheus": ["127.0.0.1", 12798],
        "minSeverity": "Info",
        "TraceBlockFetchClient": False,
        "TraceBlockFetchDecisions": False,
        "TraceBlockFetchProtocol": False,
        "TraceBlockFetchProtocolSerialised": False,
        "TraceBlockFetchServer": False,
        "TraceChainDb": True,
        "TraceChainSyncBlockServer": False,
        "TraceChainSyncClient": False,
        "TraceChainSyncHeaderServer": False,
        "TraceChainSyncProtocol": False,
        "TraceDNSResolver": True,
        "TraceDNSSubscription": True,
        "TraceErrorPolicy": True,
        "TraceForge": True,
        "TraceHandshake": False,
        "TraceIpSubscription": True,
        "TraceLocalChainSyncProtocol": False,
        "TraceLocalErrorPolicy": True,
        "TraceLocalHandshake": False,
        "TraceLocalTxSubmissionProtocol": False,
        "TraceLocalTxSubmissionServer": False,
        "TraceMempool": True,
        "TraceMux": False,
        "TraceTxInbound": False,
        "TraceTxOutbound": False,
        "TraceTxSubmissionProtocol": False
    }
    
    # Network topology
    topology_json = {
        "Producers": [
            {
                "addr": "relays-new.cardano-testnet.iohkdev.io",
                "port": 3001,
                "valency": 2
            }
        ]
    }
    
    # Submit API configuration
    submit_api_json = {
        "EnableLogMetrics": False,
        "EnableLogging": True,
        "ScribeKind": "StdoutSK",
        "ScribeFormat": "ScribeFormatText",
        "minSeverity": "Info"
    }
    
    # Upload configuration files
    config_files = plan.upload_files(
        src="src/cardano_node/static_files/cardano_config/",
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
