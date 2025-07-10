constants = import_module("./constants.star")

def parse_cardano_config(plan, args):
    """
    Parse and validate input configuration for Cardano LayerZero package
    
    Args:
        plan: Kurtosis plan object
        args: Raw configuration arguments
        
    Returns:
        Parsed and validated configuration struct
    """
    
    # Set default values
    cardano_params = _parse_cardano_params(args.get("cardano_params", {}))
    layerzero_params = _parse_layerzero_params(args.get("layerzero_params", {}))
    connections = args.get("connections", [])
    additional_services = args.get("additional_services", constants.DEFAULT_ADDITIONAL_SERVICES)
    log_level = args.get("log_level", "info")
    resource_limits = args.get("resource_limits", constants.DEFAULT_RESOURCE_LIMITS)
    dev_mode = args.get("dev_mode", {"enabled": False})
    
    # Validate configuration
    _validate_config(plan, cardano_params, layerzero_params, connections)
    
    return struct(
        cardano_params=cardano_params,
        layerzero_params=layerzero_params,
        connections=connections,
        additional_services=additional_services,
        log_level=log_level,
        resource_limits=resource_limits,
        dev_mode=dev_mode
    )

def _parse_cardano_params(params):
    """Parse Cardano-specific parameters"""
    return struct(
        network=params.get("network", "testnet"),
        slot_length=params.get("slot_length", 1),
        epoch_length=params.get("epoch_length", 432000),
        security_param=params.get("security_param", 2160),
        initial_supply=params.get("initial_supply", "45000000000000000"),
        network_magic=params.get("network_magic", 1097911063)
    )

def _parse_layerzero_params(params):
    """Parse LayerZero protocol parameters"""
    return struct(
        endpoint_id=params.get("endpoint_id", "30199"),
        dvn_fee=params.get("dvn_fee", "1000000"),
        executor_fee=params.get("executor_fee", "2000000"),
        required_confirmations=params.get("required_confirmations", 12),
        max_gas_limit=params.get("max_gas_limit", "10000000")
    )

def _validate_config(plan, cardano_params, layerzero_params, connections):
    """Validate configuration parameters"""
    
    # Validate Cardano network type
    valid_networks = ["testnet", "mainnet", "custom"]
    if cardano_params.network not in valid_networks:
        fail("Invalid Cardano network type: {}. Must be one of: {}".format(
            cardano_params.network, valid_networks
        ))
    
    # Validate LayerZero endpoint ID
    if not layerzero_params.endpoint_id:
        fail("LayerZero endpoint_id is required")
    
    # Validate connections
    for i, conn in enumerate(connections):
        if "from" not in conn or "to" not in conn:
            fail("Connection {} missing required 'from' or 'to' field".format(i))
        
        if conn["to"] == "cardano":
            required_fields = ["ethereum_rpc", "ethereum_endpoint"]
            for field in required_fields:
                if field not in conn:
                    fail("Connection {} to Cardano missing required field: {}".format(i, field))
    
    plan.print("Configuration validation passed")
