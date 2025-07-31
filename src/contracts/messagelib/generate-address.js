import { compiledMessageLib } from './dist/contracts/MessageLib.js';
import { Script, Address, PaymentCredentials } from '@harmoniclabs/plu-ts';
import fs from 'fs';

try {
    const script = new Script('PlutusScriptV2', compiledMessageLib);
    const scriptAddress = Address.testnet(
        PaymentCredentials.script(script.hash)
    ).toString();
    
    fs.writeFileSync('/tmp/messagelib-address.txt', scriptAddress);
    console.log('MessageLib contract address generated:', scriptAddress);
} catch (error) {
    console.error('Error generating address:', error);
    process.exit(1);
}
