constants = import_module("../package_io/constants.star")

def generate_faucet_keys(plan, network_magic):
    svc = plan.add_service(
        name="faucet-keygen",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            entrypoint=["/bin/sh"],
            cmd=["-lc", "\n".join([
                "set -e",
                "cardano-cli address key-gen --verification-key-file /tmp/faucet.vkey --signing-key-file /tmp/faucet.skey",
                "cardano-cli address build --payment-verification-key-file /tmp/faucet.vkey --testnet-magic {}".format(network_magic) + " --out-file /tmp/faucet.addr",
                "echo ready",
                "sleep 1"
            ])]
        )
    )
    plan.wait(
        service_name="faucet-keygen",
        recipe=ExecRecipe(command=["test", "-f", "/tmp/faucet.addr"]),
        field="code",
        assertion="==",
        target_value=0,
        timeout="60s"
    )
    addr_res = plan.exec(service_name="faucet-keygen", recipe=ExecRecipe(command=["cat", "/tmp/faucet.addr"]))
    faucet_addr = addr_res["output"].strip()
    files_art = plan.store_service_files(
        service_name="faucet-keygen",
        src="/tmp",
        name="faucet-keys"
    )
    return struct(
        address=faucet_addr,
        files_artifact_name=files_art,
        vkey_path="/keys/faucet.vkey",
        skey_path="/keys/faucet.skey"
    )
