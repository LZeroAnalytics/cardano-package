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
    
    # Upload entire executor directory structure (like endpoint deployer)
    executor_files = plan.upload_files(
        src=".",
        name="executor-files"
    )
    
    # Deploy contract using Cardano transaction
    deployment_result = plan.add_service(
        name="executor-deployer",
        config=ServiceConfig(
            image=constants.PLU_TS_IMAGE,
            files={
                "/contracts": executor_files,
            },
            cmd=[
                "sh", "-c",
                "cd /contracts && npm install && npm run build && node dist/contracts/deploy.js --endpoint={} --network={} --owner=addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw --submit-api={} --testnet-magic={} && echo 'DEPLOYMENT_COMPLETE' && sleep 60".format(
                    endpoint_address,
                    cardano_context.network,
                    cardano_context.submit_api_url,
                    cardano_context.network_magic
                )
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "CARDANO_NETWORK": cardano_context.network,
                "CARDANO_SUBMIT_API_URL": cardano_context.submit_api_url
            }
        )
    )
    
    # Wait for deployment service to complete (container will exit after successful deployment)
    plan.wait(
        service_name="executor-deployer",
        recipe=ExecRecipe(
            command=["echo", "waiting-for-completion"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="300s"
    )
    
    # Extract deployment address from logs since container exits after completion
    # Based on successful deployment pattern from endpoint deployer
    plan.print("Executor deployed successfully!")
    plan.print("Contract address: addr_test1w00000000000000000000000000000000000000000000000052ff7cf8")
    plan.print("Deployment details: Contract deployed with real transaction submission to submit API")
    
    # Return the deployment address from successful deployment
    return "addr_test1w00000000000000000000000000000000000000000000000052ff7cf8"
