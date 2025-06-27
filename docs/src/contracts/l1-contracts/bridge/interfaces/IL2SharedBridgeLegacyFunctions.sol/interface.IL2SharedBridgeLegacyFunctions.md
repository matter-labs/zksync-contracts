# IL2SharedBridgeLegacyFunctions
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/IL2SharedBridgeLegacyFunctions.sol)

**Author:**
Matter Labs


## Functions
### finalizeDeposit


```solidity
function finalizeDeposit(
  address _l1Sender,
  address _l2Receiver,
  address _l1Token,
  uint256 _amount,
  bytes calldata _data
) external;
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

