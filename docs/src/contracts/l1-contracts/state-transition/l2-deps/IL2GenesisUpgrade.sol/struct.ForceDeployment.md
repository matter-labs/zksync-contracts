# ForceDeployment
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/l2-deps/IL2GenesisUpgrade.sol)

A struct that describes a forced deployment on an address


```solidity
struct ForceDeployment {
  bytes32 bytecodeHash;
  address newAddress;
  bool callConstructor;
  uint256 value;
  bytes input;
}
```

