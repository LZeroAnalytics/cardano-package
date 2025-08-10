constants = import_module("../package_io/constants.star")

def launch_cardano_node(plan, devnet_files_artifact, network_magic):
    plan.print("Launching Cardano node from generated local devnet files")

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
            files={
                "/devnet": devnet_files_artifact
            },
            cmd=[
                "-lc",
                "\n".join([
                    "set -e",
                    "mkdir -p /work /data",
                    "cp -r /devnet/* /work/",
                    "test -f /work/config.json || cp -f /work/cardano-node/config.json /work/config.json 2>/dev/null || true",
                    "test -f /genesis/shelley.json || cp -r /work/genesis /",
                    "KES=/work/keys/kes.skey; VRF=/work/keys/vrf.skey; CERT=/work/keys/opcert.cert;",
                    "EXTRA=\"\"; if [ -f $KES ] && [ -f $VRF ] && [ -f $CERT ]; then EXTRA=\"--shelley-kes-key $KES --shelley-vrf-key $VRF --shelley-operational-certificate $CERT\"; fi",
                    "cardano-node run --config /work/config.json --database-path /data --topology /work/topology.json --socket-path /work/node.socket $EXTRA &",
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
        network="local",
        network_magic=network_magic,
        config_artifact_name=devnet_files_artifact
    )
