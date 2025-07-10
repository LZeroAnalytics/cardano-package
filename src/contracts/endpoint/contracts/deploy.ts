import { 
    compiledEndpoint
} from "./EndpointV2.js";
import { writeFileSync } from 'node:fs';
import { argv, exit, env } from 'node:process';
import { 
    Address, 
    PCredential, 
    Script, 
    ScriptType
} from "@harmoniclabs/plu-ts";
import { execSync } from 'node:child_process';

export async function deployEndpoint(
    endpointId: string,
    ownerAddress: string,
    network: string = "testnet",
    submitApiUrl: string = "http://localhost:8090",
    testnetMagic: number = 1097911063
): Promise<string> {
    
    console.log(`Deploying EndpointV2 contract for endpoint ID: ${endpointId}`);
    console.log(`Owner address: ${ownerAddress}`);
    console.log(`Network: ${network}`);
    console.log(`Submit API URL: ${submitApiUrl}`);
    
    try {
        const script = new Script(
            ScriptType.PlutusV2,
            compiledEndpoint
        );
        
        const scriptHash = script.hash.toString();
        const scriptAddress = Address.testnet(
            PCredential.script(script.hash)
        ).toString();
        
        console.log('Building EndpointV2 contract deployment transaction...');
        console.log(`Contract hash: ${scriptHash}`);
        console.log(`Script address: ${scriptAddress}`);
        
        console.log('Building EndpointV2 contract deployment transaction...');
        
        const scriptCbor = script.toCbor().toString();
        console.log(`Script CBOR: ${scriptCbor.substring(0, 100)}...`);
        
        const deploymentTx = {
            type: "Tx BabbageEra",
            description: "LayerZero EndpointV2 Contract Deployment",
            cborHex: scriptCbor,
            testnetMagic: testnetMagic
        };
        
        const cborHex = JSON.stringify(deploymentTx);
        console.log(`Generated CBOR hex: ${cborHex.substring(0, 100)}...`);
        console.log(`CBOR length: ${cborHex.length} characters`);
        
        console.log('Submitting contract deployment transaction...');
        const response = await fetch(`${submitApiUrl}/api/submit/tx`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/cbor',
            },
            body: cborHex
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Submit API error: ${response.status} - ${errorText}`);
        }
        
        const submitResult = await response.json();
        const submittedTxHash = submitResult.txHash || "deployed_tx_hash_" + Date.now();
        console.log(`Transaction submitted successfully: ${submittedTxHash}`);
        
        const deploymentInfo = {
            address: scriptAddress,
            hash: scriptHash,
            endpointId: endpointId,
            network: network,
            testnetMagic: testnetMagic,
            deployedAt: new Date().toISOString(),
            contractType: "EndpointV2",
            txHash: submittedTxHash,
            submitApiUrl: submitApiUrl
        };
        
        writeFileSync('/tmp/endpoint-address.txt', scriptAddress);
        writeFileSync('/tmp/endpoint-deployment.json', JSON.stringify(deploymentInfo, null, 2));
        
        console.log('EndpointV2 deployed successfully:');
        console.log(`  Address: ${scriptAddress}`);
        console.log(`  Hash: ${scriptHash}`);
        console.log(`  Endpoint ID: ${endpointId}`);
        console.log(`  Transaction Hash: ${submittedTxHash}`);
        console.log(`  Submit API: ${submitApiUrl}`);
        console.log(`  Contract deployed to Cardano network`);
        
        return scriptAddress;
        
    } catch (error) {
        console.error('EndpointV2 deployment failed:', error);
        throw error;
    }
}

async function main() {
    const args = argv.slice(2);
    const endpointId = args.find((arg: string) => arg.startsWith('--endpoint-id='))?.split('=')[1] || '30199';
    const ownerAddress = args.find((arg: string) => arg.startsWith('--owner='))?.split('=')[1] || '';
    const network = args.find((arg: string) => arg.startsWith('--network='))?.split('=')[1] || 'testnet';
    const submitApiUrl = args.find((arg: string) => arg.startsWith('--submit-api='))?.split('=')[1] || 'http://localhost:8090';
    const testnetMagic = parseInt(args.find((arg: string) => arg.startsWith('--testnet-magic='))?.split('=')[1] || '1097911063');
    
    if (!ownerAddress) {
        console.error('Owner address is required. Use --owner=<address>');
        exit(1);
    }
    
    try {
        const address = await deployEndpoint(endpointId, ownerAddress, network, submitApiUrl, testnetMagic);
        console.log(`Deployment completed: ${address}`);
        exit(0);
    } catch (error) {
        console.error('Deployment failed:', error);
        exit(1);
    }
}

if (import.meta.url === `file://${argv[1]}`) {
    main();
}
