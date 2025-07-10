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
    
    # Upload the entire endpoint directory structure
    endpoint_files = plan.upload_files(
        src=".",
        name="endpoint-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="endpoint-deployer",
        config=ServiceConfig(
            image=constants.PLU_TS_IMAGE,
            files={
                "/contracts": endpoint_files,
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
    
    # Wait for deployment to complete and capture the output
    plan.wait(
        service_name="endpoint-deployer",
        recipe=ExecRecipe(
            command=["sh", "-c", "cat /tmp/endpoint-address.txt 2>/dev/null || echo 'deployment-in-progress'"]
        ),
        field="output",
        assertion="!=",
        target_value="deployment-in-progress",
        timeout="300s"
    )
    
    # Get deployed contract address from the deployment service
    deployment_address = plan.exec(
        service_name="endpoint-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/endpoint-address.txt"]
        )
    )
    
    # Get deployment details
    deployment_details = plan.exec(
        service_name="endpoint-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/endpoint-deployment.json"]
        )
    )
    
    plan.print("EndpointV2 deployed successfully!")
    plan.print("Contract address: {}".format(deployment_address["output"].strip()))
    plan.print("Deployment details: {}".format(deployment_details["output"]))
    
    return deployment_address["output"].strip()
