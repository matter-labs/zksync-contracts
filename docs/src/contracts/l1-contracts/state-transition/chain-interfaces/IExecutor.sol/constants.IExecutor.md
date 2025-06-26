# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol)

### L2_LOG_ADDRESS_OFFSET
*Offset used to pull Address From Log. Equal to 4 (bytes for isService)*


```solidity
uint256 constant L2_LOG_ADDRESS_OFFSET = 4;
```

### L2_LOG_KEY_OFFSET
*Offset used to pull Key From Log. Equal to 4 (bytes for isService) + 20 (bytes for address)*


```solidity
uint256 constant L2_LOG_KEY_OFFSET = 24;
```

### L2_LOG_VALUE_OFFSET
*Offset used to pull Value From Log. Equal to 4 (bytes for isService) + 20 (bytes for address) + 32 (bytes for key)*


```solidity
uint256 constant L2_LOG_VALUE_OFFSET = 56;
```

### MAX_NUMBER_OF_BLOBS
*Max number of blobs currently supported*


```solidity
uint256 constant MAX_NUMBER_OF_BLOBS = 6;
```

### TOTAL_BLOBS_IN_COMMITMENT
*The number of blobs that must be present in the commitment to a batch.
It represents the maximal number of blobs that circuits can support and can be larger
than the maximal number of blobs supported by the contract (`MAX_NUMBER_OF_BLOBS`).*


```solidity
uint256 constant TOTAL_BLOBS_IN_COMMITMENT = 16;
```

