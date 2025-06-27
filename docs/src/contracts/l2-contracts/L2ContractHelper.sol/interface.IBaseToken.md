# IBaseToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l2-contracts/L2ContractHelper.sol)

**Author:**
Matter Labs

Interface for the contract that is used to simulate ETH on L2.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### withdrawWithMessage

Allows the withdrawal of ETH to a given L1 receiver along with an additional message.


```solidity
function withdrawWithMessage(address _l1Receiver, bytes memory _additionalData)
  external
  payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_l1Receiver`|`address`|The address on L1 to receive the withdrawn ETH.|
|`_additionalData`|`bytes`|Additional message or data to be sent alongside the withdrawal.|


