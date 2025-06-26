# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/SystemContractsCaller.sol)

### SYSTEM_CALL_CALL_ADDRESS

```solidity
address constant SYSTEM_CALL_CALL_ADDRESS = address((1 << 16) - 11);
```

### MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT
*If the bitwise AND of the extraAbi[2] param when calling the MSG_VALUE_SIMULATOR
is non-zero, the call will be assumed to be a system one.*


```solidity
uint256 constant MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT = 1;
```

