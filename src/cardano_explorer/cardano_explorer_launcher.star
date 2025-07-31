constants = import_module("../package_io/constants.star")

def launch_cardano_explorer(plan, cardano_context):
    """
    Launch Cardano Explorer with GraphQL backend and React frontend
    
    Args:
        plan: Kurtosis plan object
        cardano_context: Cardano node context
        
    Returns:
        Explorer service context
    """
    
    plan.print("Launching Cardano Explorer with GraphQL backend...")
    
    # Launch PostgreSQL database for cardano-db-sync
    postgres_service = plan.add_service(
        name="cardano-postgres",
        config=ServiceConfig(
            image=constants.POSTGRES_IMAGE,
            ports={
                "postgres": PortSpec(
                    number=5432,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "POSTGRES_DB": "cexplorer",
                "POSTGRES_USER": "cardano",
                "POSTGRES_HOST_AUTH_METHOD": "trust"
            }
        )
    )
    
    # Wait for PostgreSQL to be ready
    plan.wait(
        service_name="cardano-postgres",
        recipe=ExecRecipe(
            command=["pg_isready", "-U", "cardano", "-d", "cexplorer"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="60s"
    )
    
    # Launch cardano-db-sync to sync blockchain data to PostgreSQL
    db_sync_service = plan.add_service(
        name="cardano-db-sync",
        config=ServiceConfig(
            image=constants.CARDANO_DB_SYNC_IMAGE,
            env_vars={
                "POSTGRES_HOST": postgres_service.ip_address,
                "POSTGRES_PORT": "5432",
                "POSTGRES_DB": "cexplorer",
                "POSTGRES_USER": "cardano",
                "POSTGRES_PASSWORD": "",
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "CARDANO_NODE_CONFIG_PATH": "/opt/cardano/config/config.json",
                "NETWORK": "custom"
            },
            cmd=[
                "cardano-db-sync",
                "--config", "/opt/cardano/config/config.json",
                "--socket-path", cardano_context.socket_path,
                "--state-dir", "/opt/cardano/data",
                "--schema-dir", "/opt/cardano/schema"
            ],
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
            }
        )
    )
    
    # Launch cardano-graphql backend
    graphql_service = plan.add_service(
        name="cardano-graphql",
        config=ServiceConfig(
            image=constants.CARDANO_GRAPHQL_IMAGE,
            ports={
                "graphql": PortSpec(
                    number=constants.CARDANO_GRAPHQL_PORT,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "POSTGRES_HOST": postgres_service.ip_address,
                "POSTGRES_PORT": "5432",
                "POSTGRES_DB": "cexplorer",
                "POSTGRES_USER": "cardano",
                "POSTGRES_PASSWORD": "",
                "CARDANO_NODE_CONFIG_PATH": "/opt/cardano/config/config.json",
                "HASURA_URI": "http://localhost:8080/v1/graphql"
            },
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
            }
        )
    )
    
    # Launch cardano-explorer-app frontend
    explorer_frontend_service = plan.add_service(
        name=constants.CARDANO_EXPLORER_SERVICE,
        config=ServiceConfig(
            image=constants.CARDANO_EXPLORER_IMAGE,
            ports={
                "frontend": PortSpec(
                    number=constants.CARDANO_EXPLORER_PORT,
                    transport_protocol="TCP"
                )
            },
            env_vars={
                "GRAPHQL_URI": "http://{}:{}".format(
                    graphql_service.ip_address,
                    constants.CARDANO_GRAPHQL_PORT
                ),
                "CARDANO_NETWORK": cardano_context.network
            }
        )
    )
    
    # Wait for GraphQL service to be ready
    plan.wait(
        service_name="cardano-graphql",
        recipe=ExecRecipe(
            command=["curl", "-f", "http://localhost:3100/graphql"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="60s"
    )
    
    plan.print("Cardano Explorer launched successfully!")
    plan.print("Frontend available at: http://{}:{}".format(
        explorer_frontend_service.ip_address,
        constants.CARDANO_EXPLORER_PORT
    ))
    plan.print("GraphQL API available at: http://{}:{}".format(
        graphql_service.ip_address,
        constants.CARDANO_GRAPHQL_PORT
    ))
    
    return struct(
        frontend_service=explorer_frontend_service,
        graphql_service=graphql_service,
        postgres_service=postgres_service,
        db_sync_service=db_sync_service,
        frontend_url="http://{}:{}".format(
            explorer_frontend_service.ip_address,
            constants.CARDANO_EXPLORER_PORT
        ),
        graphql_url="http://{}:{}".format(
            graphql_service.ip_address,
            constants.CARDANO_GRAPHQL_PORT
        )
    )
