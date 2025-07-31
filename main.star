cardano_node = import_module("./src/cardano_node/cardano_launcher.star")
cardano_explorer = import_module("./src/cardano_explorer/cardano_explorer_launcher.star")
wallet_manager = import_module("./src/wallet/wallet_manager.star")
endpoint_deployer = import_module("./src/contracts/endpoint/endpoint_deployer.star")
messagelib_deployer = import_module("./src/contracts/messagelib/messagelib_deployer.star")
input_parser = import_module("./src/package_io/input_parser.star")

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
    
    
    # Launch Cardano Explorer if requested
    explorer_context = None
    if "cardano_explorer" in config.additional_services:
        plan.print("Launching Cardano Explorer...")
        explorer_context = cardano_explorer.launch_cardano_explorer(
            plan,
            cardano_context
        )
    
    # Return deployment information
    return struct(
        cardano_context=cardano_context,
        wallet_context=wallet_context,
        contracts=struct(
            endpoint=endpoint_address,
            messagelib=messagelib_address
        ),
        explorer_context=explorer_context
    )
