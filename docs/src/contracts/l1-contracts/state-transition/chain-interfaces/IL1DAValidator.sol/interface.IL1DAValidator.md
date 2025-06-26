# IL1DAValidator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IL1DAValidator.sol)


## Functions
### checkDA

The function that checks the data availability for the given batch input.


```solidity
function checkDA(
  uint256 _chainId,
  uint256 _batchNumber,
  bytes32 _l2DAValidatorOutputHash,
  bytes calldata _operatorDAInput,
  uint256 _maxBlobsSupported
) external returns (L1DAValidatorOutput memory output);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The chain id of the chain that is being committed.|
|`_batchNumber`|`uint256`|The batch number for which the data availability is being checked.|
|`_l2DAValidatorOutputHash`|`bytes32`|The hash of that was returned by the l2DAValidator.|
|`_operatorDAInput`|`bytes`|The DA input by the operator provided on L1.|
|`_maxBlobsSupported`|`uint256`|The maximal number of blobs supported by the chain. We provide this value for future compatibility. This is needed because the corresponding `blobsLinearHashes`/`blobsOpeningCommitments` in the `L1DAValidatorOutput` struct will have to have this length as it is required to be static by the circuits.|


