# DynamicIncrementalMerkle
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/libraries/DynamicIncrementalMerkle.sol)

*Library for managing https://wikipedia.org/wiki/Merkle_Tree[Merkle Tree] data structures.
Each tree is a complete binary tree with the ability to sequentially insert leaves, changing them from a zero to a
non-zero value and updating its root. This structure allows inserting commitments (or other entries) that are not
stored, but can be proven to be part of the tree at a later time if the root is kept. See {MerkleProof}.
A tree is defined by the following parameters:
Depth: The number of levels in the tree, it also defines the maximum number of leaves as 2**depth.
Zero value: The value that represents an empty leaf. Used to avoid regular zero values to be part of the tree.
Hashing function: A cryptographic hash function used to produce internal nodes.
This is a fork of OpenZeppelin's [`MerkleTree`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/9af280dc4b45ee5bda96ba47ff829b407eaab67e/contracts/utils/structs/MerkleTree.sol)
library, with the changes to support dynamic tree growth (doubling the size when full).*


## Functions
### setup

*Initialize a [Bytes32PushTree](/contracts/l1-contracts/common/libraries/DynamicIncrementalMerkle.sol/library.DynamicIncrementalMerkle.md#bytes32pushtree) using {Hashes-Keccak256} to hash internal nodes.
The capacity of the tree (i.e. number of leaves) is set to `2**levels`.
IMPORTANT: The zero value should be carefully chosen since it will be stored in the tree representing
empty leaves. It should be a value that is not expected to be part of the tree.*


```solidity
function setup(Bytes32PushTree storage self, bytes32 zero)
  internal
  returns (bytes32 initialRoot);
```

### reset

*Resets the tree to a blank state.
Calling this function on MerkleTree that was already setup and used will reset it to a blank state.*


```solidity
function reset(Bytes32PushTree storage self, bytes32 zero)
  internal
  returns (bytes32 initialRoot);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`Bytes32PushTree`||
|`zero`|`bytes32`|The value that represents an empty leaf.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`initialRoot`|`bytes32`|The initial root of the tree.|


### push

*Insert a new leaf in the tree, and compute the new root. Returns the position of the inserted leaf in the
tree, and the resulting root.
Hashing the leaf before calling this function is recommended as a protection against
second pre-image attacks.*


```solidity
function push(Bytes32PushTree storage self, bytes32 leaf)
  internal
  returns (uint256 index, bytes32 newRoot);
```

### root

*Tree's root.*


```solidity
function root(Bytes32PushTree storage self) internal view returns (bytes32);
```

### height

*Tree's height (does not include the root node).*


```solidity
function height(Bytes32PushTree storage self) internal view returns (uint256);
```

## Structs
### Bytes32PushTree
*A complete `bytes32` Merkle tree.
The `sides` and `zero` arrays are set to have a length equal to the depth of the tree during setup.
Struct members have an underscore prefix indicating that they are "private" and should not be read or written to
directly. Use the functions provided below instead. Modifying the struct manually may violate assumptions and
lead to unexpected behavior.
NOTE: The `root` and the updates history is not stored within the tree. Consider using a secondary structure to
store a list of historical roots from the values returned from [setup](/contracts/l1-contracts/common/libraries/DynamicIncrementalMerkle.sol/library.DynamicIncrementalMerkle.md#setup) and {push} (e.g. a mapping, {BitMaps} or
{Checkpoints}).
WARNING: Updating any of the tree's parameters after the first insertion will result in a corrupted tree.*


```solidity
struct Bytes32PushTree {
  uint256 _nextLeafIndex;
  bytes32[] _sides;
  bytes32[] _zeros;
}
```

