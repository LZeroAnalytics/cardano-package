constants = import_module("../package_io/constants.star")

def generate_local_devnet(plan, cardano_params, faucet_address, prefunded_accounts):
    pkg_files = plan.upload_files(
        src="./src/cardano_node/static_files/cardano_config/",
        name="cardano-static-config"
    )

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
            files={
                "/base": pkg_files
            },
            cmd=["-lc", "\n".join([
                "set -e",
                "apk add --no-cache git curl jq >/dev/null",
                "npm i -g yaci-devkit || npm i -g @bloxbean/yaci-devkit || true",
                "mkdir -p /out",
                "(yaci-devkit create-node --output /out || yaci-devkit up --output /out || true)",
                "if [ ! -f /out/config.json ]; then echo using static base; cp -f /base/config.json /out/config.json 2>/dev/null || true; fi",
                "if [ ! -f /out/topology.json ]; then cp -f /base/topology.json /out/topology.json 2>/dev/null || true; fi",
                "mkdir -p /out/genesis /out/keys",
                "test -f /out/genesis/byron.json || cp -f /base/byron-genesis.json /out/genesis/byron.json 2>/dev/null || true",
                "test -f /out/genesis/shelley.json || cp -f /base/shelley-genesis.json /out/genesis/shelley.json 2>/dev/null || true",
                "test -f /out/genesis/alonzo.json || cp -f /base/alonzo-genesis.json /out/genesis/alonzo.json 2>/dev/null || true",
                "test -f /out/genesis/conway.json || cp -f /base/conway-genesis.json /out/genesis/conway.json 2>/dev/null || true",
                "if [ -f /out/config.json ]; then tmp=/out/config.tmp && jq 'del(.ByronGenesisHash,.ShelleyGenesisHash,.AlonzoGenesisHash,.ConwayGenesisHash)' /out/config.json > $tmp || cp /out/config.json $tmp && mv $tmp /out/config.json; fi",
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
                "echo 'devnet prepared'",
                "sleep 1"
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
