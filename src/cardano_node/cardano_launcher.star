constants = import_module("../package_io/constants.star")

def launch_cardano_node(plan, cardano_params):
    plan.print("Launching Cardano node with network: {}".format(cardano_params.network))

    config_files = _generate_cardano_config(plan, cardano_params)

    cardano_node_service = plan.add_service(
        name=constants.CARDANO_NODE_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            ports={
                "node": PortSpec(
                    number=6000,
                    transport_protocol="TCP"
                ),
                "http": PortSpec(
                    number=17798,
                    transport_protocol="TCP"
                ),
                "ogmios": PortSpec(
                    number=1337,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/cnode/priv/files": config_files,
            },
            env_vars={
                "NETWORK": "guild",
                "CARDANO_NODE_SOCKET_PATH": "/opt/cardano/cnode/sockets/node0.socket"
            }
        )
    )

    plan.wait(
        service_name=constants.CARDANO_NODE_SERVICE,
        recipe=ExecRecipe(
            command=["sh", "-c", "netstat -ln | grep :6000 || ss -ln | grep :6000"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="300s"
    )

    submit_api_service = plan.add_service(
        name="cardano-submit-api",
        config=ServiceConfig(
            image="apexpool/cardano-submit-api:latest",
            ports={
                "api": PortSpec(
                    number=8090,
                    transport_protocol="TCP"
                )
            },
            files={
                "/opt/cardano/config": config_files,
            },
            cmd=[
                "cardano-submit-api",
                "--config", "/opt/cardano/config/submit-api.json",
                "--socket-path", "/opt/cardano/cnode/sockets/node0.socket",
                "--port", "8090",
                "--listen-address", "0.0.0.0",
                "--testnet-magic", str(cardano_params.network_magic)
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": constants.CARDANO_SOCKET_PATH
            }
        )
    )

    return struct(
        node_service=cardano_node_service,
        submit_api_service=submit_api_service,
        node_ip=cardano_node_service.ip_address,
        node_port=6000,
        submit_api_url="http://{}:{}".format(
            submit_api_service.ip_address,
            8090
        ),
        socket_path=constants.CARDANO_SOCKET_PATH,
        network=cardano_params.network,
        network_magic=cardano_params.network_magic,
        config_artifact_name=config_files
    )

def _generate_cardano_config(plan, cardano_params):
    config_files = plan.upload_files(
        src="static_files/cardano_config/",
        name="cardano-config-files"
    )
    return config_files
