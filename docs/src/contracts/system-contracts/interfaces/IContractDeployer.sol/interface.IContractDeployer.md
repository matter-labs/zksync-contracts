# IContractDeployer
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IContractDeployer.sol)


## Functions
### getNewAddressCreate2


```solidity
function getNewAddressCreate2(
  address _sender,
  bytes32 _bytecodeHash,
  bytes32 _salt,
  bytes calldata _input
) external view returns (address newAddress);
```

### getNewAddressCreate


```solidity
function getNewAddressCreate(address _sender, uint256 _senderNonce)
  external
  pure
  returns (address newAddress);
```

### create2


```solidity
function create2(bytes32 _salt, bytes32 _bytecodeHash, bytes calldata _input)
  external
  payable
  returns (address newAddress);
```

### create2Account


```solidity
function create2Account(
  bytes32 _salt,
  bytes32 _bytecodeHash,
  bytes calldata _input,
  AccountAbstractionVersion _aaVersion
) external payable returns (address newAddress);
```

### create

*While the `_salt` parameter is not used anywhere here,
it is still needed for consistency between `create` and
`create2` functions (required by the compiler).*


```solidity
function create(bytes32 _salt, bytes32 _bytecodeHash, bytes calldata _input)
  external
  payable
  returns (address newAddress);
```

### createAccount

*While `_salt` is never used here, we leave it here as a parameter
for the consistency with the `create` function.*


```solidity
function createAccount(
  bytes32 _salt,
  bytes32 _bytecodeHash,
  bytes calldata _input,
  AccountAbstractionVersion _aaVersion
) external payable returns (address newAddress);
```

### getAccountInfo

Returns the information about a certain AA.


```solidity
function getAccountInfo(address _address)
  external
  view
  returns (AccountInfo memory info);
```

### updateAccountVersion

Can be called by an account to update its account version


```solidity
function updateAccountVersion(AccountAbstractionVersion _version) external;
```

### updateNonceOrdering

Can be called by an account to update its nonce ordering


```solidity
function updateNonceOrdering(AccountNonceOrdering _nonceOrdering) external;
```

### forceDeployOnAddresses

This method is to be used only during an upgrade to set bytecodes on specific addresses.


```solidity
function forceDeployOnAddresses(ForceDeployment[] calldata _deployments)
  external
  payable;
```

## Events
### ContractDeployed

```solidity
event ContractDeployed(
  address indexed deployerAddress,
  bytes32 indexed bytecodeHash,
  address indexed contractAddress
);
```

### AccountNonceOrderingUpdated

```solidity
event AccountNonceOrderingUpdated(
  address indexed accountAddress, AccountNonceOrdering nonceOrdering
);
```

### AccountVersionUpdated

```solidity
event AccountVersionUpdated(
  address indexed accountAddress, AccountAbstractionVersion aaVersion
);
```

## Structs
### AccountInfo

```solidity
struct AccountInfo {
  AccountAbstractionVersion supportedAAVersion;
  AccountNonceOrdering nonceOrdering;
}
```

## Enums
### AccountAbstractionVersion
Defines the version of the account abstraction protocol
that a contract claims to follow.
- `None` means that the account is just a contract and it should never be interacted
with as a custom account
- `Version1` means that the account follows the first version of the account abstraction protocol


```solidity
enum AccountAbstractionVersion {
  None,
  Version1
}
```

### AccountNonceOrdering
Defines the nonce ordering used by the account
- `Sequential` means that it is expected that the nonces are monotonic and increment by 1
at a time (the same as EOAs).
- `Arbitrary` means that the nonces for the accounts can be arbitrary. The operator
should serve the transactions from such an account on a first-come-first-serve basis.

*This ordering is more of a suggestion to the operator on how the AA expects its transactions
to be processed and is not considered as a system invariant.*


```solidity
enum AccountNonceOrdering {
  Sequential,
  Arbitrary
}
```

