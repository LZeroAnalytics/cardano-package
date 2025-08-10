constants = import_module("../package_io/constants.star")

def generate_local_devnet(plan, cardano_params, faucet_address, prefunded_accounts):
    pkg_files = plan.upload_files(
        src="./static_files/cardano_config/",
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
                "apk add --no-cache git curl jq findutils >/dev/null || (apt-get update && apt-get install -y git curl jq findutils >/dev/null) || true",
                "npm i -g yaci-devkit || npm i -g @bloxbean/yaci-devkit || true",
                "mkdir -p /out /out/genesis /out/keys",
                "(yaci-devkit create-node --output /out || yaci-devkit up --output /out || true)",
                "if [ ! -f /out/config.json ]; then cfg=$(find /out -maxdepth 3 -type f -name 'config.json' | head -n1); if [ -n \"$cfg\" ]; then cp -f \"$cfg\" /out/config.json; fi; fi",
                "if [ ! -f /out/topology.json ]; then topo=$(find /out -maxdepth 3 -type f -name 'topology.json' | head -n1); if [ -n \"$topo\" ]; then cp -f \"$topo\" /out/topology.json; fi; fi",
                "by=$(find /out -maxdepth 4 -type f -name 'byron-genesis.json' -o -name 'byron.json' | head -n1); if [ -n \"$by\" ]; then cp -f \"$by\" /out/genesis/byron.json; fi",
                "sh=$(find /out -maxdepth 4 -type f -name 'shelley-genesis.json' -o -name 'shelley.json' | head -n1); if [ -n \"$sh\" ]; then cp -f \"$sh\" /out/genesis/shelley.json; fi",
                "al=$(find /out -maxdepth 4 -type f -name 'alonzo-genesis.json' -o -name 'alonzo.json' | head -n1); if [ -n \"$al\" ]; then cp -f \"$al\" /out/genesis/alonzo.json; fi",
                "co=$(find /out -maxdepth 4 -type f -name 'conway-genesis.json' -o -name 'conway.json' | head -n1); if [ -n \"$co\" ]; then cp -f \"$co\" /out/genesis/conway.json; fi",
                "ks=$(find /out -maxdepth 5 -type f -name 'kes.skey' | head -n1); if [ -n \"$ks\" ]; then cp -f \"$ks\" /out/keys/kes.skey; fi",
                "vr=$(find /out -maxdepth 5 -type f -name 'vrf.skey' | head -n1); if [ -n \"$vr\" ]; then cp -f \"$vr\" /out/keys/vrf.skey; fi",
                "oc=$(find /out -maxdepth 5 -type f -name 'opcert.cert' -o -name 'node.opcert' | head -n1); if [ -n \"$oc\" ]; then cp -f \"$oc\" /out/keys/opcert.cert; fi",
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
