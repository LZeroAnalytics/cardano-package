cardano_node = import_module("./src/cardano_node/cardano_launcher.star")
cardano_explorer = import_module("./src/cardano_explorer/cardano_explorer_launcher.star")
wallet_manager = import_module("./src/wallet/wallet_manager.star")
input_parser = import_module("./src/package_io/input_parser.star")

def run(plan, args={}):
    plan.print("Starting Cardano package deployment...")

    config = input_parser.parse_cardano_config(plan, args)

    plan.print("Deploying Cardano node...")
    cardano_context = cardano_node.launch_cardano_node(
        plan,
        config.cardano_params,
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

    return struct(
        cardano_context=cardano_context,
        wallet_context=wallet_context,
        explorer_context=explorer_context
    )
