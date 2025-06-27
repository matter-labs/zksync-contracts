# IL1Messenger
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/interfaces/IL1Messenger.sol)

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

