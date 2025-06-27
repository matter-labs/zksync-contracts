# IL2GenesisUpgrade
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/l2-deps/IL2GenesisUpgrade.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### genesisUpgrade


```solidity
function genesisUpgrade(
  uint256 _chainId,
  address _ctmDeployer,
  bytes calldata _fixedForceDeploymentsData,
  bytes calldata _additionalForceDeploymentsData
) external payable;
```

## Events
### UpgradeComplete

```solidity
event UpgradeComplete(uint256 _chainId);
```

