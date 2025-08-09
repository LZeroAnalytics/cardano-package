constants = import_module("../package_io/constants.star")

def launch_cardano_explorer(plan, cardano_context):
    plan.print("Launching Cardano explorer stack (Ogmios + Kupo + Yaci Store + Viewer)...")

    ogmios = plan.add_service(
        name="ogmios",
        config=ServiceConfig(
            image=constants.OGMIOS_IMAGE,
            ports={
                "http": PortSpec(
                    number=1337,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
            },
            cmd=[
                "--node-socket", constants.CARDANO_SOCKET_PATH,
                "--node-config", "/opt/cardano/config/config.json",
                "--host", "0.0.0.0",
                "--port", "1337"
            ]
        )
    )

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
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
            },
            cmd=[
                "--node-socket", constants.CARDANO_SOCKET_PATH,
                "--node-config", "/opt/cardano/config/config.json",
                "--workdir", "/var/lib/kupo",
                "--since", "origin",
                "--prune-utxo",
                "--defer-db-indexes",
                "--host", "0.0.0.0",
                "--port", "1442"
            ]
        )
    )

    yaci_store = plan.add_service(
        name="yaci-store",
        config=ServiceConfig(
            image=constants.YACI_STORE_IMAGE,
            ports={
                "http": PortSpec(
                    number=9999,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "OGMIOS_URL": "http://{}:{}".format(ogmios.ip_address, 1337),
                "KUPO_URL": "http://{}:{}".format(kupo.ip_address, 1442)
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
                "YACI_STORE_URL": "http://{}:{}".format(yaci_store.ip_address, 9999)
            }
        )
    )

    plan.print("Explorer launched")
    plan.print("Viewer: http://{}:{}".format(yaci_viewer.ip_address, constants.CARDANO_EXPLORER_PORT))

    return struct(
        viewer_service=yaci_viewer,
        yaci_store_service=yaci_store,
        kupo_service=kupo,
        ogmios_service=ogmios,
        frontend_url="http://{}:{}".format(yaci_viewer.ip_address, constants.CARDANO_EXPLORER_PORT)
    )
