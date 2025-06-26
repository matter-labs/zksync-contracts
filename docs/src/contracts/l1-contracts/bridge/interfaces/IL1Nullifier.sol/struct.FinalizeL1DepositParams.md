# FinalizeL1DepositParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL1Nullifier.sol)


```solidity
struct FinalizeL1DepositParams {
  uint256 chainId;
  uint256 l2BatchNumber;
  uint256 l2MessageIndex;
  address l2Sender;
  uint16 l2TxNumberInBatch;
  bytes message;
  bytes32[] merkleProof;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`chainId`|`uint256`|The chain ID of the transaction to check.|
|`l2BatchNumber`|`uint256`|The L2 batch number where the withdrawal was processed.|
|`l2MessageIndex`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message.|
|`l2Sender`|`address`||
|`l2TxNumberInBatch`|`uint16`|The L2 transaction number in the batch, in which the log was sent.|
|`message`|`bytes`|The L2 withdraw data, stored in an L2 -> L1 message.|
|`merkleProof`|`bytes32[]`|The Merkle proof of the inclusion L2 -> L1 message about withdrawal initialization.|

