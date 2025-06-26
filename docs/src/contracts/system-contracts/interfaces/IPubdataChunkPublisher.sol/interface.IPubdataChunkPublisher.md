# IPubdataChunkPublisher
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IPubdataChunkPublisher.sol)

**Author:**
Matter Labs

Interface for contract responsible chunking pubdata into the appropriate size for EIP-4844 blobs.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### chunkPubdataToBlobs

Chunks pubdata into pieces that can fit into blobs.

*Note: This is an early implementation, in the future we plan to support up to 16 blobs per l1 batch.*


```solidity
function chunkPubdataToBlobs(bytes calldata _pubdata)
  external
  pure
  returns (bytes32[] memory blobLinearHashes);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pubdata`|`bytes`|The total l2 to l1 pubdata that will be sent via L1 blobs.|


