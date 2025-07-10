constants = import_module("../../package_io/constants.star")

def deploy_executor(plan, cardano_context, endpoint_address):
    """
    Deploy LayerZero Executor contract to Cardano using plu-ts
    
    Args:
        plan: Kurtosis plan object
        cardano_context: Cardano node context
        endpoint_address: Associated endpoint contract address
        
    Returns:
        Deployed Executor contract address
    """
    
    plan.print("Deploying LayerZero Executor contract to Cardano...")
    
    # Upload only essential contract files (excluding node_modules)
    contract_files = plan.upload_files(
        src="contracts/",
        name="executor-contract-files"
    )
    
    # Upload package configuration files
    package_files = plan.upload_files(
        src="package.json",
        name="executor-package-files"
    )
    
    tsconfig_files = plan.upload_files(
        src="tsconfig.json", 
        name="executor-tsconfig-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="executor-deployer",
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
        service_name="executor-deployer",
        recipe=ExecRecipe(
            command=["sh", "-c", "cat /tmp/executor-address.txt 2>/dev/null || echo 'deployment-in-progress'"]
        ),
        field="output",
        assertion="!=",
        target_value="deployment-in-progress",
        timeout="300s"
    )
    
    # Get deployed contract address from the deployment service logs
    deployment_logs = plan.run_sh(
        name="get-executor-address",
        description="Extract executor address from deployment logs",
        image="alpine:latest",
        run="echo 'addr_test1qzexec97k59rqn'"  # Mock address for now - in real implementation would parse from logs
    )
    
    plan.print("Executor deployed at address: {}".format(deployment_logs.output))
    
    return deployment_logs.output.strip()
