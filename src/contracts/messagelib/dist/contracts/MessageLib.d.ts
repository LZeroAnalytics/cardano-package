export declare const MessageLibConfig: import("@harmoniclabs/plu-ts").PStruct<{
    MessageLibConfig: {
        endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
        treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const MessageProof: import("@harmoniclabs/plu-ts").PStruct<{
    MessageProof: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        dvnSignatures: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
        executorSignature: [import("@harmoniclabs/plu-ts").PrimType.BS];
        blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const MessageLibDatum: import("@harmoniclabs/plu-ts").PStruct<{
    MessageLibState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            MessageLibConfig: {
                endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        processedMessages: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
        fees: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            FeeEntry: {
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const MessageLibRedeemer: import("@harmoniclabs/plu-ts").PStruct<{
    Send: {
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
        options: [import("@harmoniclabs/plu-ts").PrimType.BS];
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    Verify: {
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
        proof: import("@harmoniclabs/plu-ts").StructT<{
            MessageProof: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                dvnSignatures: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                executorSignature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            MessageLibConfig: {
                endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawFees: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const messageLibValidator: import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    MessageLibState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            MessageLibConfig: {
                endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        processedMessages: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
        fees: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            FeeEntry: {
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    Send: {
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
        options: [import("@harmoniclabs/plu-ts").PrimType.BS];
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    Verify: {
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
        proof: import("@harmoniclabs/plu-ts").StructT<{
            MessageProof: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                dvnSignatures: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                executorSignature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            MessageLibConfig: {
                endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawFees: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>>> & {
    $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
        MessageLibState: {
            config: import("@harmoniclabs/plu-ts").StructT<{
                MessageLibConfig: {
                    endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            processedMessages: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
            fees: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                FeeEntry: {
                    dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>];
        };
    }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
        Send: {
            message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            options: [import("@harmoniclabs/plu-ts").PrimType.BS];
            fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
        Verify: {
            message: [import("@harmoniclabs/plu-ts").PrimType.BS];
            proof: import("@harmoniclabs/plu-ts").StructT<{
                MessageProof: {
                    messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    dvnSignatures: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                    executorSignature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        SetConfig: {
            newConfig: import("@harmoniclabs/plu-ts").StructT<{
                MessageLibConfig: {
                    endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        WithdrawFees: {
            amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
            recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
        };
    }, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>> & {
        $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
            Send: {
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                options: [import("@harmoniclabs/plu-ts").PrimType.BS];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
            Verify: {
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                proof: import("@harmoniclabs/plu-ts").StructT<{
                    MessageProof: {
                        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        dvnSignatures: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                        executorSignature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            SetConfig: {
                newConfig: import("@harmoniclabs/plu-ts").StructT<{
                    MessageLibConfig: {
                        endpoint: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        treasuryFee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        treasuryAddress: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            WithdrawFees: {
                amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
                recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>> & {
            $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PData>) => import("@harmoniclabs/plu-ts").UtilityTermOf<import("@harmoniclabs/plu-ts").PBool>;
        };
    };
};
export declare const compiledMessageLib: Uint8Array<ArrayBufferLike>;
export declare const messageLibHash: Uint8Array<ArrayBufferLike>;
