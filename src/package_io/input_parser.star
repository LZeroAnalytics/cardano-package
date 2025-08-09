constants = import_module("./constants.star")

def parse_cardano_config(plan, args):
    cardano_params = _parse_cardano_params(args.get("cardano_params", {}))
    additional_services = args.get("additional_services", constants.DEFAULT_ADDITIONAL_SERVICES)
    log_level = args.get("log_level", "info")
    dev_mode = args.get("dev_mode", {"enabled": False})
    prefunded_accounts = args.get("prefunded_accounts", [])

    _validate_config(plan, cardano_params)
    _validate_prefunds(plan, prefunded_accounts)

    return struct(
        cardano_params=cardano_params,
        additional_services=additional_services,
        log_level=log_level,
        dev_mode=dev_mode,
        prefunded_accounts=prefunded_accounts
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

def _validate_prefunds(plan, accounts):
    for i, a in enumerate(accounts):
        if "address" not in a or "amount" not in a:
            fail("prefunded_accounts[{}] must have 'address' and 'amount'".format(i))
