# ICompressor
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/L2ContractHelper.sol)

**Author:**
Matter Labs

The interface for the Compressor contract, responsible for verifying the correctness of
the compression of the state diffs and bytecodes.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### verifyCompressedStateDiffs

Verifies that the compression of state diffs has been done correctly for the {_stateDiffs} param.


```solidity
function verifyCompressedStateDiffs(
  uint256 _numberOfStateDiffs,
  uint256 _enumerationIndexSize,
  bytes calldata _stateDiffs,
  bytes calldata _compressedStateDiffs
) external returns (bytes32 stateDiffHash);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_numberOfStateDiffs`|`uint256`|The number of state diffs being checked.|
|`_enumerationIndexSize`|`uint256`|Number of bytes used to represent an enumeration index for repeated writes.|
|`_stateDiffs`|`bytes`|Encoded full state diff structs. See the first dev comment below for encoding.|
|`_compressedStateDiffs`|`bytes`|The compressed state diffs|


