import { 
    bool,
    bs,
    compile,
    data,
    int,
    list,
    pBool,
    pfn,
    plet,
    pmatch,
    pstruct
} from "@harmoniclabs/plu-ts";

export const MessageLibConfig = pstruct({
    MessageLibConfig: {
        endpoint: bs,           // Associated endpoint address
        owner: bs,              // Owner address
        treasuryFee: int,       // Treasury fee in lovelace
        treasuryAddress: bs     // Treasury address
    }
});

export const MessageProof = pstruct({
    MessageProof: {
        messageHash: bs,        // Hash of the message
        dvnSignatures: list(bs), // DVN signatures
        executorSignature: bs,   // Executor signature
        blockHeight: int,        // Source chain block height
        timestamp: int           // Message timestamp
    }
});

export const MessageLibDatum = pstruct({
    MessageLibState: {
        config: MessageLibConfig.type,
        processedMessages: list(bs), // Processed message hashes
        fees: list(pstruct({
            FeeEntry: {
                dstEid: int,    // Destination endpoint ID
                fee: int        // Fee amount
            }
        }).type)
    }
});

export const MessageLibRedeemer = pstruct({
    Send: { 
        message: bs,            // Message to send
        options: bs,            // Send options
        fee: int               // Fee payment
    },
    Verify: { 
        message: bs,            // Message to verify
        proof: MessageProof.type // Verification proof
    },
    SetConfig: { 
        newConfig: MessageLibConfig.type 
    },
    WithdrawFees: { 
        amount: int,            // Amount to withdraw
        recipient: bs           // Recipient address
    }
});

export const messageLibValidator = pfn([
    MessageLibDatum.type,
    MessageLibRedeemer.type,
    data
], bool)
((datum, redeemer, ctx) => {
    
    return pmatch(redeemer)
    .onSend(({ message, options, fee }) => {
        return pBool(true);
    })
    .onVerify(({ message, proof }) => {
        return pBool(true);
    })
    .onSetConfig(({ newConfig }) => {
        return pBool(true);
    })
    .onWithdrawFees(({ amount, recipient }) => {
        return pBool(true);
    });
});

export const compiledMessageLib = compile(messageLibValidator);

export const messageLibHash = compiledMessageLib;
