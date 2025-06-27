# IComplexUpgrader
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IComplexUpgrader.sol)

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

