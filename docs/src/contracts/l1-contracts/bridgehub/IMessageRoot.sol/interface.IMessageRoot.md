# IMessageRoot
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridgehub/IMessageRoot.sol)

**Author:**
Matter Labs

MessageRoot contract is responsible for storing and aggregating the roots of the batches from different chains into the MessageRoot.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### BRIDGE_HUB


```solidity
function BRIDGE_HUB() external view returns (IBridgehub);
```

### addNewChain


```solidity
function addNewChain(uint256 _chainId) external;
```

### addChainBatchRoot


```solidity
function addChainBatchRoot(
  uint256 _chainId,
  uint256 _batchNumber,
  bytes32 _chainBatchRoot
) external;
```

