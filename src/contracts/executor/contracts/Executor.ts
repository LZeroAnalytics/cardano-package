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

export const ExecutorConfig = pstruct({
    ExecutorConfig: {
        owner: bs,              // Executor owner address
        fee: int,               // Execution fee per message
        maxGasLimit: int,       // Maximum gas limit for execution
        supportedChains: list(int), // Supported destination chains
        treasury: bs            // Treasury address for fees
    }
});

export const ExecutionRequest = pstruct({
    ExecutionRequest: {
        messageHash: bs,        // Hash of message to execute
        srcEid: int,           // Source endpoint ID
        dstEid: int,           // Destination endpoint ID
        receiver: bs,          // Receiver contract address
        message: bs,           // Message payload
        gasLimit: int,         // Gas limit for execution
        requester: bs          // Address requesting execution
    }
});

export const ExecutionResult = pstruct({
    ExecutionResult: {
        messageHash: bs,       // Executed message hash
        success: bool,         // Execution success status
        gasUsed: int,          // Gas consumed
        timestamp: int,        // Execution timestamp
        txHash: bs            // Transaction hash
    }
});

export const ExecutorDatum = pstruct({
    ExecutorState: {
        config: ExecutorConfig.type,
        executions: list(ExecutionResult.type),
        earnings: int,         // Accumulated earnings
        nonce: int            // Execution nonce
    }
});

export const ExecutorRedeemer = pstruct({
    RequestExecution: { 
        request: ExecutionRequest.type,
        fee: int
    },
    ExecuteMessage: { 
        messageHash: bs,
        gasLimit: int
    },
    SetConfig: { 
        newConfig: ExecutorConfig.type 
    },
    WithdrawEarnings: { 
        amount: int,
        recipient: bs
    }
});

export const executorValidator = pfn([
    ExecutorDatum.type,
    ExecutorRedeemer.type,
    data
], bool)
((_datum, redeemer, _ctx) => {
    
    return pmatch(redeemer)
    .onRequestExecution((_) => {
        return pBool(true);
    })
    .onExecuteMessage((_) => {
        return pBool(true);
    })
    .onSetConfig((_) => {
        return pBool(true);
    })
    .onWithdrawEarnings((_) => {
        return pBool(true);
    });
});

export const compiledExecutor = compile(executorValidator);

export const executorHash = compiledExecutor;
