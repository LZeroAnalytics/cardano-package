export declare const LzMessage: import("@harmoniclabs/plu-ts").PStruct<{
    LzMessage: {
        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
        receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
        guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const EndpointConfig: import("@harmoniclabs/plu-ts").PStruct<{
    EndpointConfig: {
        endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
        delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
        defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
        defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const NonceEntry: import("@harmoniclabs/plu-ts").PStruct<{
    NonceEntry: {
        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const InboundNonce: import("@harmoniclabs/plu-ts").PStruct<{
    InboundNonce: {
        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const EndpointDatum: import("@harmoniclabs/plu-ts").PStruct<{
    EndpointState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            EndpointConfig: {
                endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        nonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            NonceEntry: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        inboundNonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            InboundNonce: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const EndpointRedeemer: import("@harmoniclabs/plu-ts").PStruct<{
    Send: {
        message: import("@harmoniclabs/plu-ts").StructT<{
            LzMessage: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    Receive: {
        message: import("@harmoniclabs/plu-ts").StructT<{
            LzMessage: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        proof: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            EndpointConfig: {
                endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    SetDelegate: {
        delegate: [import("@harmoniclabs/plu-ts").PrimType.BS];
        approved: [import("@harmoniclabs/plu-ts").PrimType.Bool];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const endpointValidator: import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    EndpointState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            EndpointConfig: {
                endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        nonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            NonceEntry: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        inboundNonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            InboundNonce: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    Send: {
        message: import("@harmoniclabs/plu-ts").StructT<{
            LzMessage: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    Receive: {
        message: import("@harmoniclabs/plu-ts").StructT<{
            LzMessage: {
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        proof: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            EndpointConfig: {
                endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    SetDelegate: {
        delegate: [import("@harmoniclabs/plu-ts").PrimType.BS];
        approved: [import("@harmoniclabs/plu-ts").PrimType.Bool];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>>> & {
    $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
        EndpointState: {
            config: import("@harmoniclabs/plu-ts").StructT<{
                EndpointConfig: {
                    endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                    defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            nonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                NonceEntry: {
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>];
            inboundNonces: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                InboundNonce: {
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>];
        };
    }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
        Send: {
            message: import("@harmoniclabs/plu-ts").StructT<{
                LzMessage: {
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        Receive: {
            message: import("@harmoniclabs/plu-ts").StructT<{
                LzMessage: {
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            proof: [import("@harmoniclabs/plu-ts").PrimType.BS];
        };
        SetConfig: {
            newConfig: import("@harmoniclabs/plu-ts").StructT<{
                EndpointConfig: {
                    endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                    defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        SetDelegate: {
            delegate: [import("@harmoniclabs/plu-ts").PrimType.BS];
            approved: [import("@harmoniclabs/plu-ts").PrimType.Bool];
        };
    }, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>> & {
        $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
            Send: {
                message: import("@harmoniclabs/plu-ts").StructT<{
                    LzMessage: {
                        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            Receive: {
                message: import("@harmoniclabs/plu-ts").StructT<{
                    LzMessage: {
                        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        sender: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        guid: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
                proof: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
            SetConfig: {
                newConfig: import("@harmoniclabs/plu-ts").StructT<{
                    EndpointConfig: {
                        endpointId: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        delegates: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                        defaultSendLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        defaultReceiveLib: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            SetDelegate: {
                delegate: [import("@harmoniclabs/plu-ts").PrimType.BS];
                approved: [import("@harmoniclabs/plu-ts").PrimType.Bool];
            };
        }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>> & {
            $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PData>) => import("@harmoniclabs/plu-ts").UtilityTermOf<import("@harmoniclabs/plu-ts").PBool>;
        };
    };
};
export declare const compiledEndpoint: Uint8Array<ArrayBufferLike>;
export declare const endpointHash: Uint8Array<ArrayBufferLike>;
