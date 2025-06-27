# IMailbox
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IMailbox.sol)


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

