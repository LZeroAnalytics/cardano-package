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
            ports={
                "ogmios": PortSpec(
                    number=1337,
                    transport_protocol="TCP"
                )
            },
            files={
                "/config": config_files
            },
            env_vars={
                "PREFUNDS_JSON": prefunds_json
            },
            cmd=[
                "/bin/sh","-lc",
                "\n".join([
                    "set -e",
                    "mkdir -p /work /data",
                    "cp -r /config/* /work/",
                    "(apk add --no-cache jq || (apt-get update && apt-get install -y jq) || true)",
                    "if [ -f /work/shelley-genesis.json ]; then",
                    "  tmp=/work/shelley-genesis.tmp",
                    "  jq --argjson add '{}' '.initialFunds += $add' /work/shelley-genesis.json > $tmp && mv $tmp /work/shelley-genesis.json",
                    "fi",
                    "if [ -n \"$PREFUNDS_JSON\" ]; then",
                    "  tmp2=/work/shelley-genesis.tmp",
                    "  jq --argjson add \"$PREFUNDS_JSON\" '.initialFunds += $add' /work/shelley-genesis.json > $tmp2 && mv $tmp2 /work/shelley-genesis.json",
                    "fi",
                    "cardano-node run --config /work/config.json --database-path /data --topology /work/topology.json --socket-path /work/node.socket &",
                    "sleep 2",
                    "ogmios --node-socket /work/node.socket --node-config /work/config.json --host 0.0.0.0 --port 1337 &",
                    "for i in $(seq 1 120); do curl -sf http://127.0.0.1:1337/health && break || sleep 1; done",
                    "tail -f /dev/null"
                ])
            ]
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
