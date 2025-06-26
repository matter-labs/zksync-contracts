# IMailbox
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IMailbox.sol)


## Functions
### finalizeEthWithdrawal


```solidity
function finalizeEthWithdrawal(
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBlock,
  bytes calldata _message,
  bytes32[] calldata _merkleProof
) external;
```

