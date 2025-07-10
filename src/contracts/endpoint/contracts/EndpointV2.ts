import { 
    Address, 
    PCredential, 
    DataI, 
    PaymentCredentials, 
    Script, 
    StakeCredentials,
    TxBuilder,
    TxOut,
    UTxO,
    Value,
    bool,
    bs,
    compile,
    data,
    int,
    list,
    pBool,
    pByteString,
    pData,
    pInt,
    pList,
    pfn,
    phoist,
    plam,
    plet,
    pmatch,
    pstruct,
    punsafeConvertType,
    unit
} from "@harmoniclabs/plu-ts";

export const LzMessage = pstruct({
    LzMessage: {
        srcEid: int,        // Source endpoint ID
        sender: bs,         // Sender address bytes
        receiver: bs,       // Receiver address bytes  
        nonce: int,         // Message nonce
        guid: bs,           // Global unique identifier
        message: bs         // Message payload
    }
});

export const EndpointConfig = pstruct({
    EndpointConfig: {
        endpointId: int,           // LayerZero endpoint ID
        owner: bs,                 // Owner address
        delegates: list(bs),       // Authorized delegates
        defaultSendLib: bs,        // Default send library
        defaultReceiveLib: bs      // Default receive library
    }
});

export const NonceEntry = pstruct({
    NonceEntry: {
        srcEid: int,      // Source endpoint ID
        sender: bs,       // Sender address
        nonce: int        // Current nonce
    }
});

export const InboundNonce = pstruct({
    InboundNonce: {
        srcEid: int,      // Source endpoint ID
        sender: bs,       // Sender address
        nonce: int        // Expected nonce
    }
});

export const EndpointDatum = pstruct({
    EndpointState: {
        config: EndpointConfig.type,
        nonces: list(NonceEntry.type),
        inboundNonces: list(InboundNonce.type)
    }
});

export const EndpointRedeemer = pstruct({
    Send: { message: LzMessage.type },
    Receive: { message: LzMessage.type, proof: bs },
    SetConfig: { newConfig: EndpointConfig.type },
    SetDelegate: { delegate: bs, approved: bool }
});

export const endpointValidator = pfn([
    EndpointDatum.type,
    EndpointRedeemer.type,
    data
], bool)
((datum, redeemer, ctx) => {
    
    return pmatch(redeemer)
    .onSend(({ message }) => {
        const validSender = plet(
            datum.config.owner.eq(message.sender)
        );
        
        const validNonce = plet(
            message.nonce.gt(pInt(0))
        );
        
        const validMessage = plet(
            message.message.length.gt(pInt(0)).and(
                message.message.length.lt(pInt(1024))
            )
        );
        
        const validEndpoint = plet(
            message.srcEid.eq(datum.config.endpointId)
        );
        
        return validSender.and(validNonce).and(validMessage).and(validEndpoint);
    })
    .onReceive(({ message, proof }) => {
        const validProof = plet(
            proof.length.gt(pInt(0))
        );
        
        const validInboundNonce = plet(
            message.nonce.gt(pInt(0))
        );
        
        const validDestination = plet(
            message.receiver.length.gt(pInt(0))
        );
        
        return validProof.and(validInboundNonce).and(validDestination);
    })
    .onSetConfig(({ newConfig }) => {
        const isOwner = plet(
            datum.config.owner.eq(newConfig.owner)
        );
        
        const validEndpointId = plet(
            datum.config.endpointId.eq(newConfig.endpointId)
        );
        
        return isOwner.and(validEndpointId);
    })
    .onSetDelegate(({ delegate, approved }) => {
        const isOwner = plet(
            datum.config.owner.length.gt(pInt(0))
        );
        
        const validDelegate = plet(
            delegate.length.gt(pInt(0))
        );
        
        return isOwner.and(validDelegate);
    });
});

export const compiledEndpoint = compile(endpointValidator);

export const endpointHash = compiledEndpoint;
