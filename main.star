cardano_node = import_module("./src/cardano_node/cardano_launcher.star")
cardano_explorer = import_module("./src/cardano_explorer/cardano_explorer_launcher.star")
wallet_manager = import_module("./src/wallet/wallet_manager.star")
faucet_keys = import_module("./src/wallet/faucet_keys.star")
faucet_launcher = import_module("./src/wallet/faucet_launcher.star")
input_parser = import_module("./src/package_io/input_parser.star")

def run(plan, args={}):
    plan.print("Starting Cardano package deployment...")

    config = input_parser.parse_cardano_config(plan, args)

    faucet = faucet_keys.generate_faucet_keys(plan, config.cardano_params.network_magic)

    plan.print("Deploying Cardano node...")
    cardano_context = cardano_node.launch_cardano_node(
        plan,
        config.cardano_params,
        faucet.address,
        config.prefunded_accounts
    )

    plan.print("Creating funded wallet for development...")
    wallet_context = wallet_manager.create_funded_wallet(
        plan,
        cardano_context,
        "100000000000"
    )

    plan.print("Launching Cardano Explorer...")
    explorer_context = cardano_explorer.launch_cardano_explorer(
        plan,
        cardano_context
    )

    faucet_context = None
    if "faucet" in config.additional_services:
        faucet_context = faucet_launcher.launch_faucet(plan, cardano_context, explorer_context, faucet)

    return struct(
        cardano_context=cardano_context,
        wallet_context=wallet_context,
        explorer_context=explorer_context,
        faucet_context=faucet_context
    )
