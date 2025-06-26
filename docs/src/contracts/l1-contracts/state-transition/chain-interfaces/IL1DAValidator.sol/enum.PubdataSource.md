# PubdataSource
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IL1DAValidator.sol)

*Enum used to determine the source of pubdata. At first we will support calldata and blobs but this can be extended.*


```solidity
enum PubdataSource {
  Calldata,
  Blob
}
```

