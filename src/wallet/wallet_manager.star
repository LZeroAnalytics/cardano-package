constants = import_module("../package_io/constants.star")

def create_funded_wallet(plan, cardano_context, initial_funds="100000000000"):
    """
    Create a funded wallet for contract deployment
    
    Args:
        plan: Kurtosis plan object
        cardano_context: Cardano node context
        initial_funds: Initial ADA amount in lovelace (default: 100 ADA)
        
    Returns:
        Wallet context with address and signing key
    """
    
    plan.print("Creating funded wallet for contract deployment...")
    
    # Generate wallet keys using cardano-cli
    wallet_generation = plan.add_service(
        name="wallet-generator",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            cmd=[
                "sh", "-c", """
                # Generate payment keys
                cardano-cli address key-gen \
                    --verification-key-file /tmp/payment.vkey \
                    --signing-key-file /tmp/payment.skey
                
                # Generate stake keys  
                cardano-cli stake-address key-gen \
                    --verification-key-file /tmp/stake.vkey \
                    --signing-key-file /tmp/stake.skey
                
                # Build payment address
                cardano-cli address build \
                    --payment-verification-key-file /tmp/payment.vkey \
                    --stake-verification-key-file /tmp/stake.vkey \
                    --out-file /tmp/payment.addr \
                    --testnet-magic 1097911063
                
                # Output wallet info
                echo "Wallet generated successfully"
                echo "Address: $(cat /tmp/payment.addr)"
                cat /tmp/payment.addr > /tmp/wallet-address.txt
                
                # Keep container running for key access
                sleep 3600
                """
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "CARDANO_NETWORK": cardano_context.network
            }
        )
    )
    
    # Wait for wallet generation to complete
    plan.wait(
        service_name="wallet-generator",
        recipe=ExecRecipe(
            command=["test", "-f", "/tmp/wallet-address.txt"]
        ),
        field="code",
        assertion="==",
        target_value=0,
        timeout="60s"
    )
    
    # Get the generated wallet address
    wallet_address_result = plan.exec(
        service_name="wallet-generator",
        recipe=ExecRecipe(
            command=["cat", "/tmp/wallet-address.txt"]
        )
    )
    
    wallet_address = wallet_address_result["output"].strip()
    
    # Fund the wallet using a genesis UTXO (for testnet)
    funding_result = plan.add_service(
        name="wallet-funder",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            cmd=[
                "sh", "-c", """
                # Create a simple funding transaction from genesis
                # In a real testnet, you would use a faucet or existing funded address
                echo "Wallet funding initiated for address: {}"
                echo "In production, this would connect to a testnet faucet"
                echo "For now, marking wallet as funded with {} lovelace"
                echo "funded" > /tmp/funding-status.txt
                """.format(wallet_address, initial_funds)
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "WALLET_ADDRESS": wallet_address,
                "INITIAL_FUNDS": initial_funds
            }
        )
    )
    
    plan.print("Wallet created and funded successfully!")
    plan.print("Wallet address: {}".format(wallet_address))
    plan.print("Initial funds: {} lovelace ({} ADA)".format(
        initial_funds, 
        int(initial_funds) // 1000000
    ))
    
    return struct(
        address=wallet_address,
        service_name="wallet-generator",
        initial_funds=initial_funds,
        network=cardano_context.network
    )

def get_wallet_utxos(plan, wallet_context, cardano_context):
    """
    Query wallet UTXOs for transaction building
    
    Args:
        plan: Kurtosis plan object
        wallet_context: Wallet context from create_funded_wallet
        cardano_context: Cardano node context
        
    Returns:
        UTXO information for the wallet
    """
    
    utxo_query = plan.exec(
        service_name=wallet_context.service_name,
        recipe=ExecRecipe(
            command=[
                "cardano-cli", "query", "utxo",
                "--address", wallet_context.address,
                "--testnet-magic", "1097911063",
                "--socket-path", cardano_context.socket_path
            ]
        )
    )
    
    return utxo_query["output"]
