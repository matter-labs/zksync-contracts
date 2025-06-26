# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL1Messenger.sol)

### L2_TO_L1_LOG_SERIALIZE_SIZE
*Bytes in raw L2 to L1 log*

*Equal to the bytes size of the tuple - (uint8 ShardId, bool isService, uint16 txNumberInBlock, address sender, bytes32 key, bytes32 value)*


```solidity
uint256 constant L2_TO_L1_LOG_SERIALIZE_SIZE = 88;
```

### L2_L1_LOGS_TREE_DEFAULT_LEAF_HASH
*The value of default leaf hash for L2 to L1 logs Merkle tree*

*An incomplete fixed-size tree is filled with this value to be a full binary tree*

*Actually equal to the `keccak256(new bytes(L2_TO_L1_LOG_SERIALIZE_SIZE))`*


```solidity
bytes32 constant L2_L1_LOGS_TREE_DEFAULT_LEAF_HASH =
  0x72abee45b59e344af8a6e520241c4744aff26ed411f4c4b00f8af09adada43ba;
```

### STATE_DIFF_COMPRESSION_VERSION_NUMBER
*The current version of state diff compression being used.*


```solidity
uint256 constant STATE_DIFF_COMPRESSION_VERSION_NUMBER = 1;
```

