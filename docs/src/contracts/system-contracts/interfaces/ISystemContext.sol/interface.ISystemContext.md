# ISystemContext
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/ISystemContext.sol)

**Author:**
Matter Labs

Contract that stores some of the context variables, that may be either
block-scoped, tx-scoped or system-wide.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### chainId


```solidity
function chainId() external view returns (uint256);
```

### origin


```solidity
function origin() external view returns (address);
```

### gasPrice


```solidity
function gasPrice() external view returns (uint256);
```

### blockGasLimit


```solidity
function blockGasLimit() external view returns (uint256);
```

### coinbase


```solidity
function coinbase() external view returns (address);
```

### difficulty


```solidity
function difficulty() external view returns (uint256);
```

### baseFee


```solidity
function baseFee() external view returns (uint256);
```

### txNumberInBlock


```solidity
function txNumberInBlock() external view returns (uint16);
```

### getBlockHashEVM


```solidity
function getBlockHashEVM(uint256 _block) external view returns (bytes32);
```

### getBatchHash


```solidity
function getBatchHash(uint256 _batchNumber)
  external
  view
  returns (bytes32 hash);
```

### getBlockNumber


```solidity
function getBlockNumber() external view returns (uint128);
```

### getBlockTimestamp


```solidity
function getBlockTimestamp() external view returns (uint128);
```

### getBatchNumberAndTimestamp


```solidity
function getBatchNumberAndTimestamp()
  external
  view
  returns (uint128 blockNumber, uint128 blockTimestamp);
```

### getL2BlockNumberAndTimestamp


```solidity
function getL2BlockNumberAndTimestamp()
  external
  view
  returns (uint128 blockNumber, uint128 blockTimestamp);
```

### gasPerPubdataByte


```solidity
function gasPerPubdataByte() external view returns (uint256 gasPerPubdataByte);
```

### getCurrentPubdataSpent


```solidity
function getCurrentPubdataSpent()
  external
  view
  returns (uint256 currentPubdataSpent);
```

### setChainId


```solidity
function setChainId(uint256 _newChainId) external;
```

## Structs
### BlockInfo

```solidity
struct BlockInfo {
  uint128 timestamp;
  uint128 number;
}
```

### VirtualBlockUpgradeInfo
A structure representing the timeline for the upgrade from the batch numbers to the L2 block numbers.

*It will be used for the L1 batch -> L2 block migration in Q3 2023 only.*


```solidity
struct VirtualBlockUpgradeInfo {
  uint128 virtualBlockStartBatch;
  uint128 virtualBlockFinishL2Block;
}
```

