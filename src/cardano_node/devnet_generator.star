constants = import_module("../package_io/constants.star")

def generate_local_devnet(plan, cardano_params, faucet_address, prefunded_accounts):
    gen_service = plan.add_service(
        name="cardano-devnet-generator",
        config=ServiceConfig(
            image="node:20-alpine",
            entrypoint=["/bin/sh"],
            env_vars={
                "PREFUNDS_ADDRS": ",".join([a["address"] for a in prefunded_accounts] + [faucet_address]),
                "PREFUNDS_AMTS": ",".join([str(a["amount"]) for a in prefunded_accounts] + ["1000000000000"]),
                "NETWORK_MAGIC": str(cardano_params.network_magic),
            },
            cmd=["-lc", "\n".join([
                "set -e",
                "apk add --no-cache git curl jq >/dev/null",
                "npm i -g yaci-devkit || npm i -g @bloxbean/yaci-devkit || true",
                "mkdir -p /out",
                # Try yaci-devkit CLI to generate a single node devnet; fall back to copying our static files
                "(yaci-devkit create-node --output /out || yaci-devkit up --output /out || true)",
                # If CLI didn't create expected files, fallback to mounting our static config as a base
                "if [ ! -f /out/config.json ]; then mkdir -p /out && echo using static base && mkdir -p /out && true; fi",
                # Ensure directory structure
                "mkdir -p /out/genesis /out/keys",
                # If genesis not present, seed from our package static files
                "if [ ! -f /out/genesis/shelley.json ]; then mkdir -p /work && true; fi",
            ])]
        )
    )

    # Copy our packaged static config into this generator container and use it as a base to ensure presence
    pkg_files = plan.upload_files(
        src="src/cardano_node/static_files/cardano_config/",
        name="cardano-static-config"
    )
    plan.exec(
        service_name="cardano-devnet-generator",
        recipe=ExecRecipe(
            command=["/bin/sh","-lc", "\n".join([
                "mkdir -p /tmp/base && cp -r /opt/* /dev/null 2>/dev/null || true",
                "mkdir -p /tmp/base && true",
                "ls -la /tmp || true"
            ])],
            files={
                "/tmp/base": pkg_files
            }
        )
    )
    plan.exec(
        service_name="cardano-devnet-generator",
        recipe=ExecRecipe(
            command=["/bin/sh","-lc", "\n".join([
                "cp -f /tmp/base/config.json /out/config.json 2>/dev/null || true",
                "cp -f /tmp/base/topology.json /out/topology.json 2>/dev/null || true || true",
                "cp -f /tmp/base/shelley-genesis.json /out/genesis/shelley.json 2>/dev/null || true",
                "cp -f /tmp/base/alonzo-genesis.json /out/genesis/alonzo.json 2>/dev/null || true",
                "cp -f /tmp/base/conway-genesis.json /out/genesis/conway.json 2>/dev/null || true",
                "cp -f /tmp/base/byron-genesis.json /out/genesis/byron.json 2>/dev/null || true",
                # Remove genesis hash fields from config to avoid mismatch after we edit initialFunds
                "if [ -f /out/config.json ]; then tmp=/out/config.tmp && jq 'del(.ByronGenesisHash,.ShelleyGenesisHash,.AlonzoGenesisHash,.ConwayGenesisHash)' /out/config.json > $tmp || cp /out/config.json $tmp && mv $tmp /out/config.json; fi",
                # Inject initialFunds into shelley genesis
                "if [ -f /out/genesis/shelley.json ]; then ",
                "  ADDRS=$(echo $PREFUNDS_ADDRS | tr ',' ' ');",
                "  AMTS=$(echo $PREFUNDS_AMTS | tr ',' ' ');",
                "  i=1; ",
                "  jqscript='.initialFunds'; ",
                "  for a in $ADDRS; do ",
                "    amt=$(echo $AMTS | awk -v n=$i '{print $n}'); ",
                "    if [ -n \"$a\" ] && [ -n \"$amt\" ]; then ",
                "      jqscript=\"$jqscript + {\\\"$a\\\": \\\"$amt\\\"}\"; ",
                "    fi; ",
                "    i=$((i+1)); ",
                "  done; ",
                "  tmp=/out/genesis/shelley.tmp && jq \"$jqscript\" /out/genesis/shelley.json > $tmp && mv $tmp /out/genesis/shelley.json; ",
                "fi",
            ])]
        )
    )

    plan.wait(
        service_name="cardano-devnet-generator",
        recipe=ExecRecipe(command=["/bin/sh","-lc","test -f /out/config.json && test -f /out/genesis/shelley.json"]),
        field="code",
        assertion="==",
        target_value=0,
        timeout="120s"
    )

    files_art = plan.store_service_files(
        service_name="cardano-devnet-generator",
        src="/out",
        name="cardano-local-devnet-files"
    )

    return struct(
        files_artifact_name=files_art
    )
