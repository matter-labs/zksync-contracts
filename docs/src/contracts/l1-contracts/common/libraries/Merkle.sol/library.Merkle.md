# Merkle
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/libraries/Merkle.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### calculateRoot

*Calculate Merkle root by the provided Merkle proof.
NOTE: When using this function, check that the _path length is equal to the tree height to prevent shorter/longer paths attack
however, for chains settling on GW the proof includes the GW proof, so the path increases. See Mailbox for more details.*


```solidity
function calculateRoot(
  bytes32[] calldata _path,
  uint256 _index,
  bytes32 _itemHash
) internal pure returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_path`|`bytes32[]`|Merkle path from the leaf to the root|
|`_index`|`uint256`|Leaf index in the tree|
|`_itemHash`|`bytes32`|Hash of leaf content|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The Merkle root|


### calculateRootMemory

*Calculate Merkle root by the provided Merkle proof.
NOTE: When using this function, check that the _path length is equal to the tree height to prevent shorter/longer paths attack*


```solidity
function calculateRootMemory(
  bytes32[] memory _path,
  uint256 _index,
  bytes32 _itemHash
) internal pure returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_path`|`bytes32[]`|Merkle path from the leaf to the root|
|`_index`|`uint256`|Leaf index in the tree|
|`_itemHash`|`bytes32`|Hash of leaf content|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The Merkle root|


### calculateRootPaths

*Calculate Merkle root by the provided Merkle proof for a range of elements
NOTE: When using this function, check that the _startPath and _endPath lengths are equal to the tree height to prevent shorter/longer paths attack*


```solidity
function calculateRootPaths(
  bytes32[] memory _startPath,
  bytes32[] memory _endPath,
  uint256 _startIndex,
  bytes32[] memory _itemHashes
) internal pure returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_startPath`|`bytes32[]`|Merkle path from the first element of the range to the root|
|`_endPath`|`bytes32[]`|Merkle path from the last element of the range to the root|
|`_startIndex`|`uint256`|Index of the first element of the range in the tree|
|`_itemHashes`|`bytes32[]`|Hashes of the elements in the range|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The Merkle root|


### efficientHash

*Keccak hash of the concatenation of two 32-byte words*


```solidity
function efficientHash(bytes32 _lhs, bytes32 _rhs)
  internal
  pure
  returns (bytes32 result);
```

### _validatePathLengthForSingleProof


```solidity
function _validatePathLengthForSingleProof(uint256 _index, uint256 _pathLength)
  private
  pure;
```

