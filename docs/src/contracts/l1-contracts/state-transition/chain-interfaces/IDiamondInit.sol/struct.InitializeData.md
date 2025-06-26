# InitializeData
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IDiamondInit.sol)


```solidity
struct InitializeData {
  uint256 chainId;
  address bridgehub;
  address chainTypeManager;
  uint256 protocolVersion;
  address admin;
  address validatorTimelock;
  bytes32 baseTokenAssetId;
  bytes32 storedBatchZero;
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
|`chainId`|`uint256`|the id of the chain|
|`bridgehub`|`address`|the address of the bridgehub contract|
|`chainTypeManager`|`address`|contract's address|
|`protocolVersion`|`uint256`|initial protocol version|
|`admin`|`address`|address who can manage the contract|
|`validatorTimelock`|`address`|address of the validator timelock that delays execution|
|`baseTokenAssetId`|`bytes32`|asset id of the base token of the chain|
|`storedBatchZero`|`bytes32`|hash of the initial genesis batch|
|`verifier`|`IVerifier`|address of Verifier contract|
|`verifierParams`|`VerifierParams`|Verifier config parameters that describes the circuit to be verified|
|`l2BootloaderBytecodeHash`|`bytes32`|The hash of bootloader L2 bytecode|
|`l2DefaultAccountBytecodeHash`|`bytes32`|The hash of default account L2 bytecode|
|`priorityTxMaxGasLimit`|`uint256`|maximum number of the L2 gas that a user can request for L1 -> L2 transactions|
|`feeParams`|`FeeParams`|Fee parameters to be used for L1->L2 transactions|
|`blobVersionedHashRetriever`|`address`|Address of contract used to pull the blob versioned hash for a transaction.|

