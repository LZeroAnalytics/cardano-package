constants = import_module("../package_io/constants.star")

def launch_cardano_node(plan, cardano_params, faucet_address, prefunded_accounts):
    plan.print("Launching Cardano node with mounted config and genesis prefunds")

    config_files = _generate_cardano_config(plan, cardano_params)

    prefunds_map = {}
    for a in prefunded_accounts:
        prefunds_map[a["address"]] = str(a["amount"])
    prefunds_map[faucet_address] = "1000000000000"

    prefunds_json_entries = []
    for k, v in prefunds_map.items():
        prefunds_json_entries.append('"%s":"%s"' % (k, v))
    prefunds_json = "{" + ",".join(prefunds_json_entries) + "}"

    cardano_node_service = plan.add_service(
        name=constants.CARDANO_NODE_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            entrypoint=["/bin/sh"],
            ports={
                "ogmios": PortSpec(
                    number=1337,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "PREFUNDS_JSON": prefunds_json
            },
            cmd=[
                "-lc",
                "\n".join([
                    "set -e",
                    "mkdir -p /work /data",
                    "cp -r /config/cardano-node/* /work/",
                    "cp -r /config/genesis /",
                    "cardano-node run --config /work/config.json --database-path /data --topology /work/topology.json --socket-path /work/node.socket &",
                    "sleep 2",
                    "ogmios --node-socket /work/node.socket --node-config /work/config.json --host 0.0.0.0 --port 1337 &",
                    "tail -f /dev/null"
                ])
            ]
        )
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
