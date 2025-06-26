# FeeParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

The fee params for L1->L2 transactions for the network.


```solidity
struct FeeParams {
  PubdataPricingMode pubdataPricingMode;
  uint32 batchOverheadL1Gas;
  uint32 maxPubdataPerBatch;
  uint32 maxL2GasPerBatch;
  uint32 priorityTxMaxPubdata;
  uint64 minimalL2GasPrice;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`pubdataPricingMode`|`PubdataPricingMode`|How the users will charged for pubdata in L1->L2 transactions.|
|`batchOverheadL1Gas`|`uint32`|The amount of L1 gas required to process the batch (except for the calldata).|
|`maxPubdataPerBatch`|`uint32`|The maximal number of pubdata that can be emitted per batch.|
|`maxL2GasPerBatch`|`uint32`||
|`priorityTxMaxPubdata`|`uint32`|The maximal amount of pubdata a priority transaction is allowed to publish. It can be slightly less than maxPubdataPerBatch in order to have some margin for the bootloader execution.|
|`minimalL2GasPrice`|`uint64`|The minimal L2 gas price to be used by L1->L2 transactions. It should represent the price that a single unit of compute costs.|

