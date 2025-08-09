constants = import_module("../package_io/constants.star")

def launch_cardano_explorer(plan, cardano_context):
    plan.print("Launching Cardano explorer stack (Ogmios + Kupo + Yaci Store + Viewer)...")


    kupo = plan.add_service(
        name="kupo",
        config=ServiceConfig(
            image=constants.KUPO_IMAGE,
            ports={
                "http": PortSpec(
                    number=1442,
                    transport_protocol="TCP"
                )
            },
            cmd=[
                "--workdir", "/var/lib/kupo",
                "--since", "origin",
                "--prune-utxo",
                "--defer-db-indexes",
                "--host", "0.0.0.0",
                "--port", "1442",
                "--match", "*",
                "--ogmios-host", cardano_context.node_ip,
                "--ogmios-port", "1337"
            ]
        )
    )

    yaci_store = plan.add_service(
        name="yaci-store",
        config=ServiceConfig(
            image=constants.YACI_STORE_IMAGE,
            ports={
                "http": PortSpec(
                    number=8080,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
            },
            env_vars={
                "SPRING_PROFILES_ACTIVE": "ogmios,kupo",
                "STORE_CARDANO_NETWORK": "preprod",
                "STORE_CARDANO_PROTOCOL_MAGIC": "1",
                "STORE_CARDANO_OGMIOS_URL": "http://{}:{}".format(cardano_context.node_ip, 1337),
                "STORE_CARDANO_KUPO_URL": "http://{}:{}".format(kupo.ip_address, 1442)
            }
        )
    )

    yaci_viewer = plan.add_service(
        name=constants.CARDANO_EXPLORER_SERVICE,
        config=ServiceConfig(
            image=constants.YACI_VIEWER_IMAGE,
            ports={
                "frontend": PortSpec(
                    number=constants.CARDANO_EXPLORER_PORT,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "YACI_STORE_URL": "http://{}:{}".format(yaci_store.ip_address, 8080)
            }
        )
    )

    plan.print("Explorer launched")
    plan.print("Viewer: http://{}:{}".format(yaci_viewer.ip_address, constants.CARDANO_EXPLORER_PORT))

    return struct(
        viewer_service=yaci_viewer,
        yaci_store_service=yaci_store,
        kupo_service=kupo,
        frontend_url="http://{}:{}".format(yaci_viewer.ip_address, constants.CARDANO_EXPLORER_PORT)
    )
