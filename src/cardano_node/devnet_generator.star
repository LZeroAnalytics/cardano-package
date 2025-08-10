constants = import_module("../package_io/constants.star")

def generate_local_devnet(plan, cardano_params, faucet_address, prefunded_accounts):
    vendor_files = plan.upload_files(
        src="./static_files/devnet_vendor/",
        name="cardano-devnet-vendor"
    )

    gen_service = plan.add_service(
        name="cardano-devnet-generator",
        config=ServiceConfig(
            image=constants.CARDANO_NODE_IMAGE,
            entrypoint=["/bin/sh"],
            env_vars={
                "PREFUNDS_ADDRS": ",".join([a["address"] for a in prefunded_accounts] + [faucet_address]),
                "PREFUNDS_AMTS": ",".join([str(a["amount"]) for a in prefunded_accounts] + ["1000000000000"])
            },
            files={
                "/vendor": vendor_files
            },
            cmd=["-lc", "\n".join([
                "set -e",
                "apk add --no-cache jq coreutils >/dev/null || (apt-get update && apt-get install -y jq coreutils >/dev/null) || true",
                "mkdir -p /out /out/genesis /out/keys",
                "cp -r /vendor/* /out/ || true",
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
                "if [ -f /out/byron-genesis.json ]; then mv /out/byron-genesis.json /out/genesis/byron.json || true; fi",
                "if [ -f /out/shelley-genesis.json ]; then mv /out/shelley-genesis.json /out/genesis/shelley.json || true; fi",
                "if [ -f /out/alonzo-genesis.json ]; then mv /out/alonzo-genesis.json /out/genesis/alonzo.json || true; fi",
                "if [ -f /out/conway-genesis.json ]; then mv /out/conway-genesis.json /out/genesis/conway.json || true; fi",
                "BY_HASH=$(cardano-cli byron genesis print-genesis-hash --genesis-json /out/genesis/byron.json || echo \"\")",
                "SH_HASH=$(cardano-cli genesis hash --genesis /out/genesis/shelley.json || echo \"\")",
                "AL_HASH=$(cardano-cli genesis hash --genesis /out/genesis/alonzo.json || echo \"\")",
                "CO_HASH=$(cardano-cli genesis hash --genesis /out/genesis/conway.json || echo \"\")",
                "if [ -f /out/config.json ]; then jq \".ByronGenesisHash=\\\"$BY_HASH\\\" | .ShelleyGenesisHash=\\\"$SH_HASH\\\" | .AlonzoGenesisHash=\\\"$AL_HASH\\\" | .ConwayGenesisHash=\\\"$CO_HASH\\\"\" /out/config.json > /out/config.tmp && mv /out/config.tmp /out/config.json; fi",
                "echo 'devnet prepared'",
                "sleep 120"
            ])]
        )
    )

    plan.wait(
        service_name="cardano-devnet-generator",
        recipe=ExecRecipe(command=["/bin/sh","-lc","test -f /out/config.json && test -f /out/genesis/shelley.json"]),
        field="code",
        assertion="==",
        target_value=0,
        timeout="180s"
    )

    files_art = plan.store_service_files(
        service_name="cardano-devnet-generator",
        src="/out",
        name="cardano-local-devnet-files"
    )

    return struct(
        files_artifact_name=files_art
    )
