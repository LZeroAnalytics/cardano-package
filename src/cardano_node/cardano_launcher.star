constants = import_module("../package_io/constants.star")

def launch_cardano_node(plan, cardano_params):
    plan.print("Launching Cardano node with network: {}".format(cardano_params.network))

    config_files = _generate_cardano_config(plan, cardano_params)

    cardano_node_service = plan.add_service(
        name=constants.CARDANO_NODE_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            ports={
                "ogmios": PortSpec(
                    number=1337,
                    transport_protocol="TCP"
                )
            }
        )
    )

    plan.wait(
        service_name=constants.CARDANO_NODE_SERVICE,
        recipe=ExecRecipe(
            command=["sh", "-c", "curl -sf http://localhost:1337/health >/dev/null"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="300s"
    )

    return struct(
        node_service=cardano_node_service,
        node_ip=cardano_node_service.ip_address,
        ogmios_url="http://{}:{}".format(cardano_node_service.ip_address, 1337),
        network="preprod",
        network_magic=cardano_params.network_magic,
        config_artifact_name=config_files
    )

def _generate_cardano_config(plan, cardano_params):
    config_files = plan.upload_files(
        src="static_files/cardano_config/",
        name="cardano-config-files"
    )
    return config_files
