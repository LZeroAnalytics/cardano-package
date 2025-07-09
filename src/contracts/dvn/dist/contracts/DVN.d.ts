export declare const DVNConfig: import("@harmoniclabs/plu-ts").PStruct<{
    DVNConfig: {
        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
        signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
        threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const VerificationRequest: import("@harmoniclabs/plu-ts").PStruct<{
    VerificationRequest: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
        requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const DVNSignature: import("@harmoniclabs/plu-ts").PStruct<{
    DVNSignature: {
        signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
        signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const DVNDatum: import("@harmoniclabs/plu-ts").PStruct<{
    DVNState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            DVNConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        verifications: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            VerificationEntry: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signatures: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                    DVNSignature: {
                        signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>];
                verified: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const DVNRedeemer: import("@harmoniclabs/plu-ts").PStruct<{
    RequestVerification: {
        request: import("@harmoniclabs/plu-ts").StructT<{
            VerificationRequest: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    SubmitSignature: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        signature: import("@harmoniclabs/plu-ts").StructT<{
            DVNSignature: {
                signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    CompleteVerification: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            DVNConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawEarnings: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const dvnValidator: import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    DVNState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            DVNConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        verifications: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            VerificationEntry: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signatures: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                    DVNSignature: {
                        signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>];
                verified: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    RequestVerification: {
        request: import("@harmoniclabs/plu-ts").StructT<{
            VerificationRequest: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    SubmitSignature: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        signature: import("@harmoniclabs/plu-ts").StructT<{
            DVNSignature: {
                signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    CompleteVerification: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            DVNConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawEarnings: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>>> & {
    $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
        DVNState: {
            config: import("@harmoniclabs/plu-ts").StructT<{
                DVNConfig: {
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                    threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            verifications: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                VerificationEntry: {
                    messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    signatures: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                        DVNSignature: {
                            signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                            signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                            timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        };
                    }, import("@harmoniclabs/plu-ts").Methods>];
                    verified: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                    timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>];
            earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
    }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
        RequestVerification: {
            request: import("@harmoniclabs/plu-ts").StructT<{
                VerificationRequest: {
                    messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
        SubmitSignature: {
            messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
            signature: import("@harmoniclabs/plu-ts").StructT<{
                DVNSignature: {
                    signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        CompleteVerification: {
            messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        };
        SetConfig: {
            newConfig: import("@harmoniclabs/plu-ts").StructT<{
                DVNConfig: {
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                    threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        WithdrawEarnings: {
            amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
            recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
        };
    }, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>> & {
        $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
            RequestVerification: {
                request: import("@harmoniclabs/plu-ts").StructT<{
                    VerificationRequest: {
                        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        blockHeight: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
            SubmitSignature: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                signature: import("@harmoniclabs/plu-ts").StructT<{
                    DVNSignature: {
                        signer: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        signature: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            CompleteVerification: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
            SetConfig: {
                newConfig: import("@harmoniclabs/plu-ts").StructT<{
                    DVNConfig: {
                        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        signers: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.BS]];
                        threshold: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
            };
            WithdrawEarnings: {
                amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
                recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>> & {
            $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PData>) => import("@harmoniclabs/plu-ts").UtilityTermOf<import("@harmoniclabs/plu-ts").PBool>;
        };
    };
};
export declare const compiledDVN: Uint8Array<ArrayBufferLike>;
export declare const dvnHash: Uint8Array<ArrayBufferLike>;
