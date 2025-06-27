# IL2GenesisUpgrade
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IL2GenesisUpgrade.sol)


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

