# INativeTokenVault
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/ntv/INativeTokenVault.sol)

**Author:**
Matter Labs

The NTV is an Asset Handler for the L1AssetRouter to handle native tokens

**Note:**
security-contact: security@matterlabs.dev


## Functions
### WETH_TOKEN

The Weth token address


```solidity
function WETH_TOKEN() external view returns (address);
```

### ASSET_ROUTER

The AssetRouter contract


```solidity
function ASSET_ROUTER() external view returns (IAssetRouterBase);
```

### L1_CHAIN_ID

The chain ID of the L1 chain


```solidity
function L1_CHAIN_ID() external view returns (uint256);
```

### originChainId

Returns the chain ID of the origin chain for a given asset ID


```solidity
function originChainId(bytes32 assetId) external view returns (uint256);
```

### registerToken

Registers tokens within the NTV.

Allows the bridge to register a token address for the vault.

No access control is ok, since the bridging of tokens should be permissionless. This requires permissionless registration.

*The goal is to allow bridging native tokens automatically, by registering them on the fly.*


```solidity
function registerToken(address _l1Token) external;
```

### ensureTokenIsRegistered

Ensures that the native token is registered with the NTV.

*This function is used to ensure that the token is registered with the NTV.*


```solidity
function ensureTokenIsRegistered(address _nativeToken) external;
```

### getERC20Getters

Used to get the the ERC20 data for a token


```solidity
function getERC20Getters(address _token, uint256 _originChainId)
  external
  view
  returns (bytes memory);
```

### tokenAddress

Used to get the token address of an assetId


```solidity
function tokenAddress(bytes32 assetId) external view returns (address);
```

### assetId

Used to get the assetId of a token


```solidity
function assetId(address token) external view returns (bytes32);
```

### calculateCreate2TokenAddress

Used to get the expected bridged token address corresponding to its native counterpart


```solidity
function calculateCreate2TokenAddress(
  uint256 _originChainId,
  address _originToken
) external view returns (address);
```

### tryRegisterTokenFromBurnData

Tries to register a token from the provided `_burnData` and reverts if it is not possible.


```solidity
function tryRegisterTokenFromBurnData(
  bytes calldata _burnData,
  bytes32 _expectedAssetId
) external;
```

## Events
### BridgedTokenBeaconUpdated

```solidity
event BridgedTokenBeaconUpdated(
  address bridgedTokenBeacon, bytes32 bridgedTokenProxyBytecodeHash
);
```

