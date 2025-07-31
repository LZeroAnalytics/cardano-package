import { compiledEndpoint } from './dist/contracts/EndpointV2.js';
import { Script, Address, PaymentCredentials } from '@harmoniclabs/plu-ts';
import fs from 'fs';

try {
    const script = new Script('PlutusScriptV2', compiledEndpoint);
    const scriptAddress = Address.testnet(
        PaymentCredentials.script(script.hash)
    ).toString();
    
    fs.writeFileSync('/tmp/endpoint-address.txt', scriptAddress);
    console.log('EndpointV2 contract address generated:', scriptAddress);
} catch (error) {
    console.error('Error generating address:', error);
    process.exit(1);
}
