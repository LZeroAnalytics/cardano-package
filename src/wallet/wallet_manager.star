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
                "CARDANO_NETWORK": cardano_context.network,
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path
            },
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
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
    
    # Fund the wallet using genesis UTXOs from local network
    funding_result = plan.add_service(
        name="wallet-funder",
        config=ServiceConfig(
            image=constants.CARDANO_CLI_IMAGE,
            entrypoint=["/bin/sh"],  # Override the cardano-node entrypoint
            cmd=[
                "-c", """
                # Wait for Cardano node to be ready
                echo "Waiting for Cardano node to be ready..."
                while ! cardano-cli query tip --testnet-magic 1097911063 --socket-path $CARDANO_NODE_SOCKET_PATH 2>/dev/null; do
                    echo "Node not ready, waiting..."
                    sleep 5
                done
                echo "Cardano node is ready!"
                
                # Get wallet address
                WALLET_ADDRESS=$(cat /tmp/wallet-address.txt)
                echo "Funding wallet from local genesis: $WALLET_ADDRESS"
                
                # Use the predefined genesis addresses from shelley-genesis.json
                # These addresses have the initial funds in our local network
                GENESIS_ADDR1="addr_test1qpw0djgj0x59ngrjvqthn7enhvruxnsavsw5th63la3mjel3tkc974sr23jmlzgq5zda4gtv8k9cy38756r9y3qgmkqqjz6aa7"
                GENESIS_ADDR2="addr_test1qqayue6h7fxemhdktj9w7cxsnxv40vm9q3f7temjr7606s3tkc974sr23jmlzgq5zda4gtv8k9cy38756r9y3qgmkqqjz6a7d"
                
                echo "Using genesis addresses from local network configuration"
                
                # Copy genesis keys from config to working directory
                cp /opt/cardano/config/genesis-keys/genesis1.skey /tmp/genesis1.skey
                cp /opt/cardano/config/genesis-keys/genesis1.vkey /tmp/genesis1.vkey
                
                # Query UTXOs from genesis addresses
                echo "Querying genesis UTXOs..."
                cardano-cli query utxo --address $GENESIS_ADDR1 --testnet-magic 1097911063 --socket-path $CARDANO_NODE_SOCKET_PATH > /tmp/genesis-utxos1.txt
                cardano-cli query utxo --address $GENESIS_ADDR2 --testnet-magic 1097911063 --socket-path $CARDANO_NODE_SOCKET_PATH > /tmp/genesis-utxos2.txt
                
                # Extract first UTXO from genesis address 1 (skip header lines)
                GENESIS_UTXO=$(tail -n +3 /tmp/genesis-utxos1.txt | head -n 1 | awk '{print $1"#"$2}')
                
                if [ -z "$GENESIS_UTXO" ]; then
                    echo "No genesis UTXOs found, wallet funding failed"
                    echo "failed" > /tmp/funding-status.txt
                    exit 1
                fi
                
                echo "Using genesis UTXO: $GENESIS_UTXO"
                
                # Create funding transaction from genesis UTXO to new wallet
                cardano-cli transaction build \
                    --testnet-magic 1097911063 \
                    --socket-path $CARDANO_NODE_SOCKET_PATH \
                    --tx-in $GENESIS_UTXO \
                    --tx-out "$WALLET_ADDRESS+$INITIAL_FUNDS" \
                    --change-address $GENESIS_ADDR1 \
                    --out-file /tmp/funding-tx.raw
                
                if [ $? -eq 0 ]; then
                    echo "Funding transaction built successfully"
                    
                    # Sign the transaction with genesis key
                    cardano-cli transaction sign \
                        --tx-body-file /tmp/funding-tx.raw \
                        --signing-key-file /tmp/genesis1.skey \
                        --testnet-magic 1097911063 \
                        --out-file /tmp/funding-tx.signed
                    
                    if [ $? -eq 0 ]; then
                        echo "Transaction signed successfully"
                        
                        # Submit the transaction
                        cardano-cli transaction submit \
                            --tx-file /tmp/funding-tx.signed \
                            --testnet-magic 1097911063 \
                            --socket-path $CARDANO_NODE_SOCKET_PATH
                        
                        if [ $? -eq 0 ]; then
                            echo "Wallet funding transaction submitted successfully!"
                            echo "funded" > /tmp/funding-status.txt
                        else
                            echo "Failed to submit funding transaction"
                            echo "failed" > /tmp/funding-status.txt
                            exit 1
                        fi
                    else
                        echo "Failed to sign funding transaction"
                        echo "failed" > /tmp/funding-status.txt
                        exit 1
                    fi
                else
                    echo "Failed to build funding transaction"
                    echo "failed" > /tmp/funding-status.txt
                    exit 1
                fi
                """
            ],
            env_vars={
                "CARDANO_NODE_SOCKET_PATH": cardano_context.socket_path,
                "INITIAL_FUNDS": initial_funds
            },
            files={
                "/opt/cardano/config": cardano_context.config_artifact_name
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
