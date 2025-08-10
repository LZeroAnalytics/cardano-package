constants = import_module("../package_io/constants.star")

def launch_faucet(plan, cardano_context, explorer_context, faucet_keys, faucet_config={}):
    server_files = plan.upload_files(
        src="./faucet_server/",
        name="faucet-server-files"
    )
    service = plan.add_service(
        name="cardano-faucet",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            ports={
                "http": PortSpec(
                    number=constants.FAUCET_PORT,
                    transport_protocol="TCP"
                )
            },
            files={
                "/app": server_files,
                "/app/keys": faucet_keys.files_artifact_name
            },
            env_vars={
                "OGMIOS_URL": cardano_context.ogmios_url,
                "KUPO_URL": "http://{}:{}".format(explorer_context.kupo_service.ip_address, 1442),
                "NETWORK_MAGIC": str(cardano_context.network_magic),
                "FAUCET_SIGNING_KEY_PATH": "/app/keys/faucet.skey",
                "FAUCET_ADDRESS": faucet_keys.address,
                "PORT": str(constants.FAUCET_PORT)
            },
            cmd=[
                "sh","-lc",
                "\n".join([
                    "set -e",
                    "(apk add --no-cache curl nodejs npm || (apt-get update && apt-get install -y curl nodejs npm) || true)",
                    "cd /app",
                    "npm install --omit=dev || true",
                    "node server.js"
                ])
            ]
        )
    )
    return struct(
        faucet_service=service,
        url="http://{}:{}".format(service.ip_address, constants.FAUCET_PORT)
    )
