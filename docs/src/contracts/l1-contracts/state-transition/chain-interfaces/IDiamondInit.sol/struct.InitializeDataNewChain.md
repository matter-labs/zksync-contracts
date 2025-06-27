# InitializeDataNewChain
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IDiamondInit.sol)


```solidity
struct InitializeDataNewChain {
  IVerifier verifier;
  VerifierParams verifierParams;
  bytes32 l2BootloaderBytecodeHash;
  bytes32 l2DefaultAccountBytecodeHash;
  uint256 priorityTxMaxGasLimit;
  FeeParams feeParams;
  address blobVersionedHashRetriever;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`verifier`|`IVerifier`|address of Verifier contract|
|`verifierParams`|`VerifierParams`|Verifier config parameters that describes the circuit to be verified|
|`l2BootloaderBytecodeHash`|`bytes32`|The hash of bootloader L2 bytecode|
|`l2DefaultAccountBytecodeHash`|`bytes32`|The hash of default account L2 bytecode|
|`priorityTxMaxGasLimit`|`uint256`|maximum number of the L2 gas that a user can request for L1 -> L2 transactions|
|`feeParams`|`FeeParams`|Fee parameters to be used for L1->L2 transactions|
|`blobVersionedHashRetriever`|`address`|Address of contract used to pull the blob versioned hash for a transaction.|

