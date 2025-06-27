# PubdataSource
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IL1DAValidator.sol)

*Enum used to determine the source of pubdata. At first we will support calldata and blobs but this can be extended.*


```solidity
enum PubdataSource {
  Calldata,
  Blob
}
```

