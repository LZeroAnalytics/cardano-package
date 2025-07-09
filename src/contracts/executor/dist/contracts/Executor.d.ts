export declare const ExecutorConfig: import("@harmoniclabs/plu-ts").PStruct<{
    ExecutorConfig: {
        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
        supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
        treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const ExecutionRequest: import("@harmoniclabs/plu-ts").PStruct<{
    ExecutionRequest: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
        receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
        gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
        requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const ExecutionResult: import("@harmoniclabs/plu-ts").PStruct<{
    ExecutionResult: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        success: [import("@harmoniclabs/plu-ts").PrimType.Bool];
        gasUsed: [import("@harmoniclabs/plu-ts").PrimType.Int];
        timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
        txHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const ExecutorDatum: import("@harmoniclabs/plu-ts").PStruct<{
    ExecutorState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            ExecutorConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        executions: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            ExecutionResult: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                success: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                gasUsed: [import("@harmoniclabs/plu-ts").PrimType.Int];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                txHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const ExecutorRedeemer: import("@harmoniclabs/plu-ts").PStruct<{
    RequestExecution: {
        request: import("@harmoniclabs/plu-ts").StructT<{
            ExecutionRequest: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    ExecuteMessage: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            ExecutorConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawEarnings: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>;
export declare const executorValidator: import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    ExecutorState: {
        config: import("@harmoniclabs/plu-ts").StructT<{
            ExecutorConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        executions: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
            ExecutionResult: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                success: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                gasUsed: [import("@harmoniclabs/plu-ts").PrimType.Int];
                timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                txHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>];
        earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
        nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
    RequestExecution: {
        request: import("@harmoniclabs/plu-ts").StructT<{
            ExecutionRequest: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    ExecuteMessage: {
        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
        gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
    };
    SetConfig: {
        newConfig: import("@harmoniclabs/plu-ts").StructT<{
            ExecutorConfig: {
                owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
            };
        }, import("@harmoniclabs/plu-ts").Methods>;
    };
    WithdrawEarnings: {
        amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
        recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
    };
}, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>>> & {
    $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
        ExecutorState: {
            config: import("@harmoniclabs/plu-ts").StructT<{
                ExecutorConfig: {
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                    treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            executions: [import("@harmoniclabs/plu-ts").PrimType.List, import("@harmoniclabs/plu-ts").StructT<{
                ExecutionResult: {
                    messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    success: [import("@harmoniclabs/plu-ts").PrimType.Bool];
                    gasUsed: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    timestamp: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    txHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>];
            earnings: [import("@harmoniclabs/plu-ts").PrimType.Int];
            nonce: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
    }, import("@harmoniclabs/plu-ts").Methods>>) => import("@harmoniclabs/plu-ts").Term<import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PStruct<{
        RequestExecution: {
            request: import("@harmoniclabs/plu-ts").StructT<{
                ExecutionRequest: {
                    messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
            fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
        ExecuteMessage: {
            messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
            gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
        };
        SetConfig: {
            newConfig: import("@harmoniclabs/plu-ts").StructT<{
                ExecutorConfig: {
                    owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                    supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                    treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
                };
            }, import("@harmoniclabs/plu-ts").Methods>;
        };
        WithdrawEarnings: {
            amount: [import("@harmoniclabs/plu-ts").PrimType.Int];
            recipient: [import("@harmoniclabs/plu-ts").PrimType.BS];
        };
    }, import("@harmoniclabs/plu-ts").Methods>, import("@harmoniclabs/plu-ts").PLam<import("@harmoniclabs/plu-ts").PData, import("@harmoniclabs/plu-ts").PBool>>> & {
        $: (input: import("@harmoniclabs/plu-ts").PappArg<import("@harmoniclabs/plu-ts").PStruct<{
            RequestExecution: {
                request: import("@harmoniclabs/plu-ts").StructT<{
                    ExecutionRequest: {
                        messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        srcEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        dstEid: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        receiver: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        message: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        requester: [import("@harmoniclabs/plu-ts").PrimType.BS];
                    };
                }, import("@harmoniclabs/plu-ts").Methods>;
                fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
            ExecuteMessage: {
                messageHash: [import("@harmoniclabs/plu-ts").PrimType.BS];
                gasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
            };
            SetConfig: {
                newConfig: import("@harmoniclabs/plu-ts").StructT<{
                    ExecutorConfig: {
                        owner: [import("@harmoniclabs/plu-ts").PrimType.BS];
                        fee: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        maxGasLimit: [import("@harmoniclabs/plu-ts").PrimType.Int];
                        supportedChains: [import("@harmoniclabs/plu-ts").PrimType.List, [import("@harmoniclabs/plu-ts").PrimType.Int]];
                        treasury: [import("@harmoniclabs/plu-ts").PrimType.BS];
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
export declare const compiledExecutor: Uint8Array<ArrayBufferLike>;
export declare const executorHash: Uint8Array<ArrayBufferLike>;
