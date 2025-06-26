# IL2SharedBridgeLegacyFunctions
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL2SharedBridgeLegacyFunctions.sol)

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

