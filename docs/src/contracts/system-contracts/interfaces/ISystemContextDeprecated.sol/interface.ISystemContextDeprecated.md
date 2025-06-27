# ISystemContextDeprecated
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/ISystemContextDeprecated.sol)

**Author:**
Matter Labs

The interface with deprecated functions of the SystemContext contract. It is aimed for backward compatibility.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### currentBlockInfo


```solidity
function currentBlockInfo() external view returns (uint256);
```

### getBlockNumberAndTimestamp


```solidity
function getBlockNumberAndTimestamp()
  external
  view
  returns (uint256 blockNumber, uint256 blockTimestamp);
```

### blockHash


```solidity
function blockHash(uint256 _blockNumber) external view returns (bytes32 hash);
```

