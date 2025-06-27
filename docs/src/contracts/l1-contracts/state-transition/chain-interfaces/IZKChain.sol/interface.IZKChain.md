# IZKChain
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IZKChain.sol)

**Inherits:**
[IAdmin](/contracts/l1-contracts/state-transition/chain-interfaces/IAdmin.sol/interface.IAdmin.md), [IExecutor](/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol/interface.IExecutor.md), [IGetters](/contracts/l1-contracts/state-transition/chain-interfaces/IGetters.sol/interface.IGetters.md), [IMailbox](/contracts/l1-contracts/state-transition/chain-interfaces/IMailbox.sol/interface.IMailbox.md)


## Events
### ProposeTransparentUpgrade

```solidity
event ProposeTransparentUpgrade(
  Diamond.DiamondCutData diamondCut,
  uint256 indexed proposalId,
  bytes32 proposalSalt
);
```

