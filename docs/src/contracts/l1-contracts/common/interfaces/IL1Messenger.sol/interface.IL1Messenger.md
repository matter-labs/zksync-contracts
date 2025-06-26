# IL1Messenger
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/interfaces/IL1Messenger.sol)

**Author:**
Matter Labs

The interface of the L1 Messenger contract, responsible for sending messages to L1.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### sendToL1


```solidity
function sendToL1(bytes calldata _message) external returns (bytes32);
```

