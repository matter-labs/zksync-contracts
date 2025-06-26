# IConsensusRegistry
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/interfaces/IConsensusRegistry.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### add


```solidity
function add(
  address _nodeOwner,
  uint32 _validatorWeight,
  BLS12_381PublicKey calldata _validatorPubKey,
  BLS12_381Signature calldata _validatorPoP,
  uint32 _attesterWeight,
  Secp256k1PublicKey calldata _attesterPubKey
) external;
```

### deactivate


```solidity
function deactivate(address _nodeOwner) external;
```

### activate


```solidity
function activate(address _nodeOwner) external;
```

### remove


```solidity
function remove(address _nodeOwner) external;
```

### changeValidatorWeight


```solidity
function changeValidatorWeight(address _nodeOwner, uint32 _weight) external;
```

### changeAttesterWeight


```solidity
function changeAttesterWeight(address _nodeOwner, uint32 _weight) external;
```

### changeValidatorKey


```solidity
function changeValidatorKey(
  address _nodeOwner,
  BLS12_381PublicKey calldata _pubKey,
  BLS12_381Signature calldata _pop
) external;
```

### changeAttesterKey


```solidity
function changeAttesterKey(
  address _nodeOwner,
  Secp256k1PublicKey calldata _pubKey
) external;
```

### commitAttesterCommittee


```solidity
function commitAttesterCommittee() external;
```

### commitValidatorCommittee


```solidity
function commitValidatorCommittee() external;
```

### getAttesterCommittee


```solidity
function getAttesterCommittee()
  external
  view
  returns (CommitteeAttester[] memory);
```

### getValidatorCommittee


```solidity
function getValidatorCommittee()
  external
  view
  returns (CommitteeValidator[] memory);
```

## Events
### NodeAdded

```solidity
event NodeAdded(
  address indexed nodeOwner,
  uint32 validatorWeight,
  BLS12_381PublicKey validatorPubKey,
  BLS12_381Signature validatorPoP,
  uint32 attesterWeight,
  Secp256k1PublicKey attesterPubKey
);
```

### NodeDeactivated

```solidity
event NodeDeactivated(address indexed nodeOwner);
```

### NodeActivated

```solidity
event NodeActivated(address indexed nodeOwner);
```

### NodeRemoved

```solidity
event NodeRemoved(address indexed nodeOwner);
```

### NodeDeleted

```solidity
event NodeDeleted(address indexed nodeOwner);
```

### NodeValidatorWeightChanged

```solidity
event NodeValidatorWeightChanged(address indexed nodeOwner, uint32 newWeight);
```

### NodeAttesterWeightChanged

```solidity
event NodeAttesterWeightChanged(address indexed nodeOwner, uint32 newWeight);
```

### NodeValidatorKeyChanged

```solidity
event NodeValidatorKeyChanged(
  address indexed nodeOwner,
  BLS12_381PublicKey newPubKey,
  BLS12_381Signature newPoP
);
```

### NodeAttesterKeyChanged

```solidity
event NodeAttesterKeyChanged(
  address indexed nodeOwner, Secp256k1PublicKey newPubKey
);
```

### ValidatorsCommitted

```solidity
event ValidatorsCommitted(uint32 commit);
```

### AttestersCommitted

```solidity
event AttestersCommitted(uint32 commit);
```

## Errors
### UnauthorizedOnlyOwnerOrNodeOwner

```solidity
error UnauthorizedOnlyOwnerOrNodeOwner();
```

### NodeOwnerExists

```solidity
error NodeOwnerExists();
```

### NodeOwnerDoesNotExist

```solidity
error NodeOwnerDoesNotExist();
```

### NodeOwnerNotFound

```solidity
error NodeOwnerNotFound();
```

### ValidatorPubKeyExists

```solidity
error ValidatorPubKeyExists();
```

### AttesterPubKeyExists

```solidity
error AttesterPubKeyExists();
```

### InvalidInputNodeOwnerAddress

```solidity
error InvalidInputNodeOwnerAddress();
```

### InvalidInputBLS12_381PublicKey

```solidity
error InvalidInputBLS12_381PublicKey();
```

### InvalidInputBLS12_381Signature

```solidity
error InvalidInputBLS12_381Signature();
```

### InvalidInputSecp256k1PublicKey

```solidity
error InvalidInputSecp256k1PublicKey();
```

## Structs
### Node
*Represents a consensus node.*


```solidity
struct Node {
  uint32 attesterLastUpdateCommit;
  uint32 validatorLastUpdateCommit;
  uint32 nodeOwnerIdx;
  AttesterAttr attesterLatest;
  AttesterAttr attesterSnapshot;
  ValidatorAttr validatorLatest;
  ValidatorAttr validatorSnapshot;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`attesterLastUpdateCommit`|`uint32`|The latest `attestersCommit` where the node's attester attributes were updated.|
|`validatorLastUpdateCommit`|`uint32`|The latest `validatorsCommit` where the node's validator attributes were updated.|
|`nodeOwnerIdx`|`uint32`|Index of the node owner within the array of node owners.|
|`attesterLatest`|`AttesterAttr`|Attester attributes to read if `node.attesterLastUpdateCommit` < `attestersCommit`.|
|`attesterSnapshot`|`AttesterAttr`|Attester attributes to read if `node.attesterLastUpdateCommit` == `attestersCommit`.|
|`validatorLatest`|`ValidatorAttr`|Validator attributes to read if `node.validatorLastUpdateCommit` < `validatorsCommit`.|
|`validatorSnapshot`|`ValidatorAttr`|Validator attributes to read if `node.validatorLastUpdateCommit` == `validatorsCommit`.|

### AttesterAttr
*Represents the attester attributes of a consensus node.*


```solidity
struct AttesterAttr {
  bool active;
  bool removed;
  uint32 weight;
  Secp256k1PublicKey pubKey;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`active`|`bool`|A flag stating if the attester is active.|
|`removed`|`bool`|A flag stating if the attester has been removed (and is pending a deletion).|
|`weight`|`uint32`|Attester's voting weight.|
|`pubKey`|`Secp256k1PublicKey`|Attester's Secp256k1 public key.|

### CommitteeAttester
*Represents an attester within a committee.*


```solidity
struct CommitteeAttester {
  uint32 weight;
  Secp256k1PublicKey pubKey;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`weight`|`uint32`|Attester's voting weight.|
|`pubKey`|`Secp256k1PublicKey`|Attester's Secp256k1 public key.|

### ValidatorAttr
*Represents the validator attributes of a consensus node.*


```solidity
struct ValidatorAttr {
  bool active;
  bool removed;
  uint32 weight;
  BLS12_381PublicKey pubKey;
  BLS12_381Signature proofOfPossession;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`active`|`bool`|A flag stating if the validator is active.|
|`removed`|`bool`|A flag stating if the validator has been removed (and is pending a deletion).|
|`weight`|`uint32`|Validator's voting weight.|
|`pubKey`|`BLS12_381PublicKey`|Validator's BLS12-381 public key.|
|`proofOfPossession`|`BLS12_381Signature`|Validator's Proof-of-possession (a signature over the public key).|

### CommitteeValidator
*Represents a validator within a committee.*


```solidity
struct CommitteeValidator {
  uint32 weight;
  BLS12_381PublicKey pubKey;
  BLS12_381Signature proofOfPossession;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`weight`|`uint32`|Validator's voting weight.|
|`pubKey`|`BLS12_381PublicKey`|Validator's BLS12-381 public key.|
|`proofOfPossession`|`BLS12_381Signature`|Validator's Proof-of-possession (a signature over the public key).|

### BLS12_381PublicKey
*Represents BLS12_381 public key.*


```solidity
struct BLS12_381PublicKey {
  bytes32 a;
  bytes32 b;
  bytes32 c;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`a`|`bytes32`|First component of the BLS12-381 public key.|
|`b`|`bytes32`|Second component of the BLS12-381 public key.|
|`c`|`bytes32`|Third component of the BLS12-381 public key.|

### BLS12_381Signature
*Represents BLS12_381 signature.*


```solidity
struct BLS12_381Signature {
  bytes32 a;
  bytes16 b;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`a`|`bytes32`|First component of the BLS12-381 signature.|
|`b`|`bytes16`|Second component of the BLS12-381 signature.|

### Secp256k1PublicKey
*Represents Secp256k1 public key.*


```solidity
struct Secp256k1PublicKey {
  bytes1 tag;
  bytes32 x;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`tag`|`bytes1`|Y-coordinate's even/odd indicator of the Secp256k1 public key.|
|`x`|`bytes32`|X-coordinate component of the Secp256k1 public key.|

