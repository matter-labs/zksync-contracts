# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/Config.sol)

### EMPTY_STRING_KECCAK
*`keccak256("")`*


```solidity
bytes32 constant EMPTY_STRING_KECCAK =
  0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
```

### L2_TO_L1_LOG_SERIALIZE_SIZE
*Bytes in raw L2 log*

*Equal to the bytes size of the tuple - (uint8 ShardId, bool isService, uint16 txNumberInBatch, address sender,
bytes32 key, bytes32 value)*


```solidity
uint256 constant L2_TO_L1_LOG_SERIALIZE_SIZE = 88;
```

### MAX_L2_TO_L1_LOGS_COMMITMENT_BYTES
*The maximum length of the bytes array with L2 -> L1 logs*


```solidity
uint256 constant MAX_L2_TO_L1_LOGS_COMMITMENT_BYTES =
  4 + L2_TO_L1_LOG_SERIALIZE_SIZE * 512;
```

### L2_L1_LOGS_TREE_DEFAULT_LEAF_HASH
*The value of default leaf hash for L2 -> L1 logs Merkle tree*

*An incomplete fixed-size tree is filled with this value to be a full binary tree*

*Actually equal to the `keccak256(new bytes(L2_TO_L1_LOG_SERIALIZE_SIZE))`*


```solidity
bytes32 constant L2_L1_LOGS_TREE_DEFAULT_LEAF_HASH =
  0x72abee45b59e344af8a6e520241c4744aff26ed411f4c4b00f8af09adada43ba;
```

### DEFAULT_L2_LOGS_TREE_ROOT_HASH

```solidity
bytes32 constant DEFAULT_L2_LOGS_TREE_ROOT_HASH = bytes32(0);
```

### PRIORITY_OPERATION_L2_TX_TYPE
*Denotes the type of the ZKsync transaction that came from L1.*


```solidity
uint256 constant PRIORITY_OPERATION_L2_TX_TYPE = 255;
```

### SYSTEM_UPGRADE_L2_TX_TYPE
*Denotes the type of the ZKsync transaction that is used for system upgrades.*


```solidity
uint256 constant SYSTEM_UPGRADE_L2_TX_TYPE = 254;
```

### MAX_ALLOWED_MINOR_VERSION_DELTA
*The maximal allowed difference between protocol minor versions in an upgrade. The 100 gap is needed
in case a protocol version has been tested on testnet, but then not launched on mainnet, e.g.
due to a bug found.
We are allowed to jump at most 100 minor versions at a time. The major version is always expected to be 0.*


```solidity
uint256 constant MAX_ALLOWED_MINOR_VERSION_DELTA = 100;
```

### PRIORITY_EXPIRATION
*The amount of time in seconds the validator has to process the priority transaction
NOTE: The constant is set to zero for the Alpha release period*


```solidity
uint256 constant PRIORITY_EXPIRATION = 0 days;
```

### COMMIT_TIMESTAMP_NOT_OLDER
*Timestamp - seconds since unix epoch.*


```solidity
uint256 constant COMMIT_TIMESTAMP_NOT_OLDER = 3 days;
```

### COMMIT_TIMESTAMP_APPROXIMATION_DELTA
*Maximum available error between real commit batch timestamp and analog used in the verifier (in seconds)*

*Must be used cause miner's `block.timestamp` value can differ on some small value (as we know - 12 seconds)*


```solidity
uint256 constant COMMIT_TIMESTAMP_APPROXIMATION_DELTA = 1 hours;
```

### PUBLIC_INPUT_SHIFT
*Shift to apply to verify public input before verifying.*


```solidity
uint256 constant PUBLIC_INPUT_SHIFT = 32;
```

### MAX_GAS_PER_TRANSACTION
*The maximum number of L2 gas that a user can request for an L2 transaction*


```solidity
uint256 constant MAX_GAS_PER_TRANSACTION = 80_000_000;
```

### L1_GAS_PER_PUBDATA_BYTE
*Even though the price for 1 byte of pubdata is 16 L1 gas, we have a slightly increased
value.*


```solidity
uint256 constant L1_GAS_PER_PUBDATA_BYTE = 17;
```

### L1_TX_INTRINSIC_L2_GAS
*The intrinsic cost of the L1->l2 transaction in computational L2 gas*


```solidity
uint256 constant L1_TX_INTRINSIC_L2_GAS = 167_157;
```

### L1_TX_INTRINSIC_PUBDATA
*The intrinsic cost of the L1->l2 transaction in pubdata*


```solidity
uint256 constant L1_TX_INTRINSIC_PUBDATA = 88;
```

### L1_TX_MIN_L2_GAS_BASE
*The minimal base price for L1 transaction*


```solidity
uint256 constant L1_TX_MIN_L2_GAS_BASE = 173_484;
```

### L1_TX_DELTA_544_ENCODING_BYTES
*The number of L2 gas the transaction starts costing more with each 544 bytes of encoding*


```solidity
uint256 constant L1_TX_DELTA_544_ENCODING_BYTES = 1656;
```

### L1_TX_DELTA_FACTORY_DEPS_L2_GAS
*The number of L2 gas an L1->L2 transaction gains with each new factory dependency*


```solidity
uint256 constant L1_TX_DELTA_FACTORY_DEPS_L2_GAS = 2473;
```

### L1_TX_DELTA_FACTORY_DEPS_PUBDATA
*The number of L2 gas an L1->L2 transaction gains with each new factory dependency*


```solidity
uint256 constant L1_TX_DELTA_FACTORY_DEPS_PUBDATA = 64;
```

### MAX_NEW_FACTORY_DEPS
*The number of pubdata an L1->L2 transaction requires with each new factory dependency*


```solidity
uint256 constant MAX_NEW_FACTORY_DEPS = 64;
```

### REQUIRED_L2_GAS_PRICE_PER_PUBDATA
*The L2 gasPricePerPubdata required to be used in bridges.*


```solidity
uint256 constant REQUIRED_L2_GAS_PRICE_PER_PUBDATA = 800;
```

### PACKED_L2_BLOCK_TIMESTAMP_MASK
*The mask which should be applied to the packed batch and L2 block timestamp in order
to obtain the L2 block timestamp. Applying this mask is equivalent to calculating modulo 2**128*


```solidity
uint256 constant PACKED_L2_BLOCK_TIMESTAMP_MASK =
  0xffffffffffffffffffffffffffffffff;
```

### POINT_EVALUATION_PRECOMPILE_ADDR
*Address of the point evaluation precompile used for EIP-4844 blob verification.*


```solidity
address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
```

### TX_SLOT_OVERHEAD_L2_GAS
*The overhead for a transaction slot in L2 gas.
It is roughly equal to 80kk/MAX_TRANSACTIONS_IN_BATCH, i.e. how many gas would an L1->L2 transaction
need to pay to compensate for the batch being closed.*

*It is expected that the L1 contracts will enforce that the L2 gas price will be high enough to compensate
the operator in case the batch is closed because of tx slots filling up.*


```solidity
uint256 constant TX_SLOT_OVERHEAD_L2_GAS = 10000;
```

### MEMORY_OVERHEAD_GAS
*The overhead for each byte of the bootloader memory that the encoding of the transaction.
It is roughly equal to 80kk/BOOTLOADER_MEMORY_FOR_TXS, i.e. how many gas would an L1->L2 transaction
need to pay to compensate for the batch being closed.*

*It is expected that the L1 contracts will enforce that the L2 gas price will be high enough to compensate
the operator in case the batch is closed because of the memory for transactions being filled up.*


```solidity
uint256 constant MEMORY_OVERHEAD_GAS = 10;
```

### PRIORITY_TX_MAX_GAS_LIMIT
*The maximum gas limit for a priority transaction in L2.*


```solidity
uint256 constant PRIORITY_TX_MAX_GAS_LIMIT = 72_000_000;
```

### ETH_TOKEN_ADDRESS
*the address used to identify eth as the base token for chains.*


```solidity
address constant ETH_TOKEN_ADDRESS = address(1);
```

### TWO_BRIDGES_MAGIC_VALUE
*the value returned in bridgehubDeposit in the TwoBridges function.*


```solidity
bytes32 constant TWO_BRIDGES_MAGIC_VALUE =
  bytes32(uint256(keccak256("TWO_BRIDGES_MAGIC_VALUE")) - 1);
```

### BRIDGEHUB_MIN_SECOND_BRIDGE_ADDRESS
*https://eips.ethereum.org/EIPS/eip-1352*


```solidity
address constant BRIDGEHUB_MIN_SECOND_BRIDGE_ADDRESS =
  address(uint160(type(uint16).max));
```

### MAX_NUMBER_OF_ZK_CHAINS
*the maximum number of supported chains, this is an arbitrary limit.*

*Note, that in case of a malicious Bridgehub admin, the total number of chains
can be up to 2 times higher. This may be possible, in case the old ChainTypeManager
had `100` chains and these were migrated to the Bridgehub only after `MAX_NUMBER_OF_ZK_CHAINS`
were added to the bridgehub via creation of new chains.*


```solidity
uint256 constant MAX_NUMBER_OF_ZK_CHAINS = 100;
```

### SETTLEMENT_LAYER_RELAY_SENDER
*Used as the `msg.sender` for transactions that relayed via a settlement layer.*


```solidity
address constant SETTLEMENT_LAYER_RELAY_SENDER =
  address(uint160(0x1111111111111111111111111111111111111111));
```

### SUPPORTED_PROOF_METADATA_VERSION
*The metadata version that is supported by the ZK Chains to prove that an L2->L1 log was included in a batch.*


```solidity
uint256 constant SUPPORTED_PROOF_METADATA_VERSION = 1;
```

### L1_SETTLEMENT_LAYER_VIRTUAL_ADDRESS
*The virtual address of the L1 settlement layer.*


```solidity
address constant L1_SETTLEMENT_LAYER_VIRTUAL_ADDRESS = address(
  uint160(uint256(keccak256("L1_SETTLEMENT_LAYER_VIRTUAL_ADDRESS")) - 1)
);
```

