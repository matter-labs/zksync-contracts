# SystemContractsCaller
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l2-contracts/SystemContractsCaller.sol)

The library contains the functions to make system calls.

*A more detailed description of the library and its methods can be found in the `system-contracts` repo.*


## Functions
### systemCall


```solidity
function systemCall(
  uint32 gasLimit,
  address to,
  uint256 value,
  bytes memory data
) internal returns (bool success);
```

### systemCallWithReturndata


```solidity
function systemCallWithReturndata(
  uint32 gasLimit,
  address to,
  uint128 value,
  bytes memory data
) internal returns (bool success, bytes memory returnData);
```

### getFarCallABI


```solidity
function getFarCallABI(
  uint32 dataOffset,
  uint32 memoryPage,
  uint32 dataStart,
  uint32 dataLength,
  uint32 gasPassed,
  uint8 shardId,
  CalldataForwardingMode forwardingMode,
  bool isConstructorCall,
  bool isSystemCall
) internal pure returns (uint256 farCallAbi);
```

### getFarCallABIWithEmptyFatPointer


```solidity
function getFarCallABIWithEmptyFatPointer(
  uint32 gasPassed,
  uint8 shardId,
  CalldataForwardingMode forwardingMode,
  bool isConstructorCall,
  bool isSystemCall
) internal pure returns (uint256 farCallAbiWithEmptyFatPtr);
```

