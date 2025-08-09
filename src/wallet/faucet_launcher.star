constants = import_module("../package_io/constants.star")

def launch_faucet(plan, cardano_context, faucet_config={}):
    service = plan.add_service(
        name="cardano-faucet",
        config=ServiceConfig(
            image="node:20-alpine",
            ports={
                "http": PortSpec(
                    number=8081,
                    transport_protocol="TCP"
                )
            },
            cmd=[
                "sh", "-lc",
                "echo 'Starting faucet placeholder'; nc -lk -p 8081 -e echo"
            ],
            env_vars={
                "OGMIOS_URL": cardano_context.ogmios_url,
                "NETWORK_MAGIC": str(cardano_context.network_magic)
            }
        )
    )
    plan.print("Faucet service launched on http://{}:{}".format(service.ip_address, 8081))
    return struct(
        faucet_service=service,
        url="http://{}:{}".format(service.ip_address, 8081)
    )
