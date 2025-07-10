cardano_node = import_module("./src/cardano_node/cardano_launcher.star")
cardano_explorer = import_module("./src/cardano_explorer/cardano_explorer_launcher.star")
wallet_manager = import_module("./src/wallet/wallet_manager.star")
endpoint_deployer = import_module("./src/contracts/endpoint/endpoint_deployer.star")
messagelib_deployer = import_module("./src/contracts/messagelib/messagelib_deployer.star")
dvn_contract_deployer = import_module("./src/contracts/dvn/dvn_deployer.star")
executor_contract_deployer = import_module("./src/contracts/executor/executor_deployer.star")
dvn_service = import_module("./src/dvn_service/dvn_launcher.star")
executor_service = import_module("./src/executor_service/executor_launcher.star")
oapp_deployer = import_module("./src/oapp/oapp_deployer.star")
input_parser = import_module("./src/package_io/input_parser.star")
redis = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args={}):
    """
    Launches a Cardano network with LayerZero V2 protocol implementation
    
    Args:
        args: Configuration parameters for Cardano network and LayerZero setup
    """
    
    plan.print("Starting Cardano LayerZero Package deployment...")
    
    # Parse input configuration
    config = input_parser.parse_cardano_config(plan, args)
    
    # Launch Cardano node with LayerZero configuration
    plan.print("Deploying Cardano node...")
    cardano_context = cardano_node.launch_cardano_node(
        plan,
        config.cardano_params,
        config.layerzero_params
    )
    
    # Create funded wallet for contract deployment
    plan.print("Creating funded wallet for contract deployment...")
    wallet_context = wallet_manager.create_funded_wallet(
        plan,
        cardano_context,
        "100000000000"  # 100 ADA
    )
    
    # Deploy LayerZero core contracts to Cardano
    plan.print("Deploying LayerZero contracts to Cardano...")
    
    # Deploy EndpointV2 contract
    endpoint_address = endpoint_deployer.deploy_endpoint(
        plan,
        cardano_context,
        config.layerzero_params.endpoint_id
    )
    
    # Deploy MessageLib contract
    messagelib_address = messagelib_deployer.deploy_messagelib(
        plan,
        cardano_context,
        endpoint_address
    )
    
    # Deploy DVN contract
    dvn_address = dvn_contract_deployer.deploy_dvn(
        plan,
        cardano_context,
        endpoint_address
    )
    
    # Deploy Executor contract
    executor_address = executor_contract_deployer.deploy_executor(
        plan,
        cardano_context,
        endpoint_address
    )
    
    # Start Redis brokers for off-chain services
    plan.print("Starting Redis brokers...")
    
    dvn_redis = redis.run(
        plan,
        service_name="cardano-dvn-redis",
        image="redis:7"
    )
    dvn_redis_url = "redis://{}:{}".format(dvn_redis.hostname, dvn_redis.port_number)
    
    executor_redis = redis.run(
        plan,
        service_name="cardano-executor-redis", 
        image="redis:7"
    )
    executor_redis_url = "redis://{}:{}".format(executor_redis.hostname, executor_redis.port_number)
    
    # Launch off-chain services for cross-chain connections
    if "connections" in args and len(args["connections"]) > 0:
        plan.print("Launching cross-chain services...")
        
        for connection in args["connections"]:
            if connection["to"] == "cardano":
                # Launch DVN service for this connection
                dvn_service.launch_dvn_service(
                    plan,
                    src_network=connection["from"],
                    src_rpc=connection.get("ethereum_rpc", ""),
                    src_endpoint=connection.get("ethereum_endpoint", ""),
                    dst_cardano_context=cardano_context,
                    dst_dvn_address=dvn_address,
                    redis_url=dvn_redis_url
                )
                
                # Launch Executor service for this connection
                executor_service.launch_executor_service(
                    plan,
                    src_network=connection["from"],
                    src_rpc=connection.get("ethereum_rpc", ""),
                    dst_cardano_context=cardano_context,
                    dst_executor_address=executor_address,
                    redis_url=executor_redis_url
                )
    
    # Deploy example OApp if requested
    oapp_address = None
    if "oapp" in config.additional_services:
        plan.print("Deploying example OApp...")
        oapp_address = oapp_deployer.deploy_oapp(
            plan,
            cardano_context,
            endpoint_address
        )
    
    # Launch Cardano Explorer (temporarily disabled due to Docker image availability)
    explorer_context = None
    plan.print("Cardano Explorer temporarily disabled - focusing on contract deployment verification")
    
    # Return deployment information
    return struct(
        cardano_context=cardano_context,
        wallet_context=wallet_context,
        contracts=struct(
            endpoint=endpoint_address,
            messagelib=messagelib_address,
            dvn=dvn_address,
            executor=executor_address,
            oapp=oapp_address
        ),
        redis_urls=struct(
            dvn=dvn_redis_url,
            executor=executor_redis_url
        ),
        explorer_context=explorer_context
    )
