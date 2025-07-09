constants = import_module("../../package_io/constants.star")

def deploy_endpoint(plan, cardano_context, endpoint_id):
    """
    Deploy LayerZero EndpointV2 contract to Cardano using plu-ts
    
    Args:
        plan: Kurtosis plan object
        cardano_context: Cardano node context
        endpoint_id: LayerZero endpoint identifier
        
    Returns:
        Deployed endpoint contract address
    """
    
    plan.print("Deploying LayerZero EndpointV2 contract to Cardano...")
    
    # Upload only essential contract files (excluding node_modules)
    contract_files = plan.upload_files(
        src="contracts/",
        name="endpoint-contract-files"
    )
    
    # Upload package configuration files
    package_files = plan.upload_files(
        src="package.json",
        name="endpoint-package-files"
    )
    
    tsconfig_files = plan.upload_files(
        src="tsconfig.json", 
        name="endpoint-tsconfig-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="endpoint-deployer",
        config=ServiceConfig(
            image=constants.PLU_TS_IMAGE,
            files={
                "/contracts/contracts": contract_files,
                "/contracts/package.json": package_files,
                "/contracts/tsconfig.json": tsconfig_files,
            },
            cmd=[
                "sh", "-c",
                "cd /contracts && npm install && npm run build && node dist/contracts/deploy.js --endpoint-id={} --network={} --owner=addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw".format(
                    endpoint_id,
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
    
    # Wait for deployment to complete
    plan.wait(
        service_name="endpoint-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/endpoint-address.txt"]
        ),
        field="output",
        assertion="!=",
        target_value="",
        timeout="300s"
    )
    
    # Get deployed contract address
    endpoint_address = plan.exec(
        service_name="endpoint-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/endpoint-address.txt"]
        )
    )
    
    plan.print("EndpointV2 deployed at address: {}".format(endpoint_address.output))
    
    return endpoint_address.output.strip()
