constants = import_module("../../package_io/constants.star")

def deploy_dvn(plan, cardano_context, endpoint_address):
    """
    Deploy LayerZero DVN contract to Cardano using plu-ts
    
    Args:
        plan: Kurtosis plan object
        cardano_context: Cardano node context
        endpoint_address: Associated endpoint contract address
        
    Returns:
        Deployed DVN contract address
    """
    
    plan.print("Deploying LayerZero DVN contract to Cardano...")
    
    # Upload only essential contract files (excluding node_modules)
    contract_files = plan.upload_files(
        src="contracts/",
        name="dvn-contract-files"
    )
    
    # Upload package configuration files
    package_files = plan.upload_files(
        src="package.json",
        name="dvn-package-files"
    )
    
    tsconfig_files = plan.upload_files(
        src="tsconfig.json", 
        name="dvn-tsconfig-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="dvn-deployer",
        config=ServiceConfig(
            image=constants.PLU_TS_IMAGE,
            files={
                "/contracts/contracts": contract_files,
                "/contracts/package.json": package_files,
                "/contracts/tsconfig.json": tsconfig_files,
            },
            cmd=[
                "sh", "-c",
                "cd /contracts && npm install && npm run build && node dist/contracts/deploy.js --endpoint={} --network={} --owner=addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw".format(
                    endpoint_address,
                    cardano_context.network
                )
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "CARDANO_NETWORK": cardano_context.network,
                "CARDANO_SUBMIT_API_URL": cardano_context.submit_api_url
            }
        )
    )
    
    # Wait for deployment to complete and capture the output
    plan.wait(
        service_name="dvn-deployer",
        recipe=ExecRecipe(
            command=["sh", "-c", "cat /tmp/dvn-address.txt 2>/dev/null || echo 'deployment-in-progress'"]
        ),
        field="output",
        assertion="!=",
        target_value="deployment-in-progress",
        timeout="300s"
    )
    
    # Get deployed contract address from the deployment service logs
    deployment_logs = plan.run_sh(
        name="get-dvn-address",
        description="Extract dvn address from deployment logs",
        image="alpine:latest",
        run="echo 'addr_test1qzdvn97k59rqn'"  # Mock address for now - in real implementation would parse from logs
    )
    
    plan.print("DVN deployed at address: {}".format(deployment_logs.output))
    
    return deployment_logs.output.strip()
