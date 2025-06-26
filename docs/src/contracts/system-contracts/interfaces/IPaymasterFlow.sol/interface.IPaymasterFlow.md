# IPaymasterFlow
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IPaymasterFlow.sol)

**Author:**
Matter Labs

This is NOT an interface to be implemented
by contracts. It is just used for encoding.

*The interface that is used for encoding/decoding of
different types of paymaster flows.*


## Functions
### general


```solidity
function general(bytes calldata input) external;
```

### approvalBased


```solidity
function approvalBased(
  address _token,
  uint256 _minAllowance,
  bytes calldata _innerInput
) external;
```

