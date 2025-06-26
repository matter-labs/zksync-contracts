# IVerifier
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IVerifier.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### verify

*Verifies a zk-SNARK proof.*


```solidity
function verify(uint256[] calldata _publicInputs, uint256[] calldata _proof)
  external
  view
  returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|A boolean value indicating whether the zk-SNARK proof is valid. Note: The function may revert execution instead of returning false in some cases.|


### verificationKeyHash

Calculates a keccak256 hash of the runtime loaded verification keys.


```solidity
function verificationKeyHash() external pure returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|vkHash The keccak256 hash of the loaded verification keys.|


