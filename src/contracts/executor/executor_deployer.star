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
    
    # Upload contract files from local directory
    contract_files = plan.upload_files(
        src="src/contracts/executor/",
        name="executor-contract-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="executor-deployer",
        config=ServiceConfig(
            image=constants.PLU_TS_IMAGE,
            files={
                "/contracts": contract_files,
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
    
    # Wait for deployment to complete
    plan.wait(
        service_name="executor-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/executor-address.txt"]
        ),
        field="output",
        assertion="!=",
        target_value="",
        timeout="300s"
    )
    
    # Get deployed contract address
    executor_address = plan.exec(
        service_name="executor-deployer",
        recipe=ExecRecipe(
            command=["cat", "/tmp/executor-address.txt"]
        )
    )
    
    plan.print("Executor deployed at address: {}".format(executor_address.output))
    
    return executor_address.output.strip()
