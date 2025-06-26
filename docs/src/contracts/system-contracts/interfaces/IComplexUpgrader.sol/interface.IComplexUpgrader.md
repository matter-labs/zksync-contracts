# IComplexUpgrader
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IComplexUpgrader.sol)

**Author:**
Matter Labs

The interface for the ComplexUpgrader contract.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### forceDeployAndUpgrade


```solidity
function forceDeployAndUpgrade(
  ForceDeployment[] calldata _forceDeployments,
  address _delegateTo,
  bytes calldata _calldata
) external payable;
```

### upgrade


```solidity
function upgrade(address _delegateTo, bytes calldata _calldata)
  external
  payable;
```

