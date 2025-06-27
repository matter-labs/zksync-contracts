# IVerifier
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l2-contracts/verifier/chain-interfaces/IVerifier.sol)

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


