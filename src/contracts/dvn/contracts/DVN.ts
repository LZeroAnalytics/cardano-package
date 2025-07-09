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

export const DVNConfig = pstruct({
    DVNConfig: {
        owner: bs,              // DVN owner address
        signers: list(bs),      // Authorized signer addresses
        threshold: int,         // Minimum signatures required
        fee: int,               // DVN fee per verification
        supportedChains: list(int) // Supported chain endpoint IDs
    }
});

export const VerificationRequest = pstruct({
    VerificationRequest: {
        messageHash: bs,        // Hash of message to verify
        srcEid: int,           // Source endpoint ID
        dstEid: int,           // Destination endpoint ID
        blockHeight: int,       // Source block height
        requester: bs          // Address requesting verification
    }
});

export const DVNSignature = pstruct({
    DVNSignature: {
        signer: bs,            // Signer address
        signature: bs,         // Signature bytes
        timestamp: int         // Signature timestamp
    }
});

export const DVNDatum = pstruct({
    DVNState: {
        config: DVNConfig.type,
        verifications: list(pstruct({
            VerificationEntry: {
                messageHash: bs,
                signatures: list(DVNSignature.type),
                verified: bool,
                timestamp: int
            }
        }).type),
        earnings: int          // Accumulated earnings
    }
});

export const DVNRedeemer = pstruct({
    RequestVerification: { 
        request: VerificationRequest.type,
        fee: int
    },
    SubmitSignature: { 
        messageHash: bs,
        signature: DVNSignature.type
    },
    CompleteVerification: { 
        messageHash: bs
    },
    SetConfig: { 
        newConfig: DVNConfig.type 
    },
    WithdrawEarnings: { 
        amount: int,
        recipient: bs
    }
});

export const dvnValidator = pfn([
    DVNDatum.type,
    DVNRedeemer.type,
    data
], bool)
((_datum, redeemer, _ctx) => {
    
    return pmatch(redeemer)
    .onRequestVerification((_) => {
        return pBool(true);
    })
    .onSubmitSignature((_) => {
        return pBool(true);
    })
    .onCompleteVerification((_) => {
        return pBool(true);
    })
    .onSetConfig((_) => {
        return pBool(true);
    })
    .onWithdrawEarnings((_) => {
        return pBool(true);
    });
});

export const compiledDVN = compile(dvnValidator);

export const dvnHash = compiledDVN;
