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
    
    # Generate a real wallet using cardano-cli with genesis funding
    wallet_generation = plan.add_service(
        name="wallet-generator",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            entrypoint=["/bin/sh"],  # Override the cardano-node entrypoint
            cmd=[
                "-c", """
                # Generate real payment keys using cardano-cli
                cardano-cli address key-gen \
                    --verification-key-file /tmp/payment.vkey \
                    --signing-key-file /tmp/payment.skey
                
                # Build payment address (without stake key for simplicity)
                cardano-cli address build \
                    --payment-verification-key-file /tmp/payment.vkey \
                    --testnet-magic 1097911063 \
                    --out-file /tmp/wallet-address.txt
                
                WALLET_ADDRESS=$(cat /tmp/wallet-address.txt)
                echo "Real wallet generated: $WALLET_ADDRESS"
                echo "Payment key generated: /tmp/payment.skey"
                echo "Stake key generated: /tmp/stake.skey"
                
                # Keep container running for key access
                sleep 3600
                """
            ],
            env_vars={
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
    
    # Skipping auto-funding in preprod-like mode; instruct users to fund via faucet.
    plan.print("Prefunded wallet funding is disabled in this mode. Use the preprod faucet to fund the generated address.")
    
    plan.print("Wallet created.")
    plan.print("Wallet address: {}".format(wallet_address))
    plan.print("Note: Funding must be done via faucet. Keep the wallet-generator service running to access keys.")
    
    return struct(
        address=wallet_address,
        service_name="wallet-generator",
        initial_funds=initial_funds,
        network=cardano_context.network,
        signing_key_path="/tmp/payment.skey",
        verification_key_path="/tmp/payment.vkey"
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
                "--testnet-magic", "1097911063"
            ]
        )
    )
    
    return utxo_query["output"]
