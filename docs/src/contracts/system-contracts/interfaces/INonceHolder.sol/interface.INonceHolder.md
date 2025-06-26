# INonceHolder
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/INonceHolder.sol)

**Author:**
Matter Labs

*Interface of the nonce holder contract -- a contract used by the system to ensure
that there is always a unique identifier for a transaction with a particular account (we call it nonce).
In other words, the pair of (address, nonce) should always be unique.*

*Custom accounts should use methods of this contract to store nonces or other possible unique identifiers
for the transaction.*


## Functions
### getMinNonce

*Returns the current minimal nonce for account.*


```solidity
function getMinNonce(address _address) external view returns (uint256);
```

### getRawNonce

*Returns the raw version of the current minimal nonce
(equal to minNonce + 2^128 * deployment nonce).*


```solidity
function getRawNonce(address _address) external view returns (uint256);
```

### increaseMinNonce

*Increases the minimal nonce for the msg.sender.*


```solidity
function increaseMinNonce(uint256 _value) external returns (uint256);
```

### setValueUnderNonce

*Sets the nonce value `key` as used.*


```solidity
function setValueUnderNonce(uint256 _key, uint256 _value) external;
```

### getValueUnderNonce

*Gets the value stored inside a custom nonce.*


```solidity
function getValueUnderNonce(uint256 _key) external view returns (uint256);
```

### incrementMinNonceIfEquals

*A convenience method to increment the minimal nonce if it is equal
to the `_expectedNonce`.*


```solidity
function incrementMinNonceIfEquals(uint256 _expectedNonce) external;
```

### getDeploymentNonce

*Returns the deployment nonce for the accounts used for CREATE opcode.*


```solidity
function getDeploymentNonce(address _address) external view returns (uint256);
```

### incrementDeploymentNonce

*Increments the deployment nonce for the account and returns the previous one.*


```solidity
function incrementDeploymentNonce(address _address) external returns (uint256);
```

### validateNonceUsage

*Determines whether a certain nonce has been already used for an account.*


```solidity
function validateNonceUsage(address _address, uint256 _key, bool _shouldBeUsed)
  external
  view;
```

### isNonceUsed

*Returns whether a nonce has been used for an account.*


```solidity
function isNonceUsed(address _address, uint256 _nonce)
  external
  view
  returns (bool);
```

## Events
### ValueSetUnderNonce

```solidity
event ValueSetUnderNonce(
  address indexed accountAddress, uint256 indexed key, uint256 value
);
```

