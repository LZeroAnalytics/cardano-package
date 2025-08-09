constants = import_module("./constants.star")

def parse_cardano_config(plan, args):
    cardano_params = _parse_cardano_params(args.get("cardano_params", {}))
    additional_services = args.get("additional_services", constants.DEFAULT_ADDITIONAL_SERVICES)
    log_level = args.get("log_level", "info")
    dev_mode = args.get("dev_mode", {"enabled": False})

    _validate_config(plan, cardano_params)

    return struct(
        cardano_params=cardano_params,
        additional_services=additional_services,
        log_level=log_level,
        dev_mode=dev_mode
    )

def _parse_cardano_params(params):
    return struct(
        network=params.get("network", "testnet"),
        slot_length=params.get("slot_length", 1),
        epoch_length=params.get("epoch_length", 432000),
        security_param=params.get("security_param", 2160),
        initial_supply=params.get("initial_supply", "45000000000000000"),
        network_magic=params.get("network_magic", 1097911063)
    )

def _validate_config(plan, cardano_params):
    valid_networks = ["testnet", "mainnet", "custom"]
    if cardano_params.network not in valid_networks:
        fail("Invalid Cardano network type: {}. Must be one of: {}".format(
            cardano_params.network, valid_networks
        ))
    plan.print("Configuration validation passed")
