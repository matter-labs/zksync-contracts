# IL2NativeTokenVault
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/ntv/IL2NativeTokenVault.sol)

**Inherits:**
[INativeTokenVault](/contracts/l1-contracts/bridge/ntv/INativeTokenVault.sol/interface.INativeTokenVault.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### l2TokenAddress


```solidity
function l2TokenAddress(address _l1Token) external view returns (address);
```

## Events
### FinalizeDeposit

```solidity
event FinalizeDeposit(
  address indexed l1Sender,
  address indexed l2Receiver,
  address indexed l2Token,
  uint256 amount
);
```

### WithdrawalInitiated

```solidity
event WithdrawalInitiated(
  address indexed l2Sender,
  address indexed l1Receiver,
  address indexed l2Token,
  uint256 amount
);
```

### L2TokenBeaconUpdated

```solidity
event L2TokenBeaconUpdated(
  address indexed l2TokenBeacon, bytes32 indexed l2TokenProxyBytecodeHash
);
```

