# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/L2ContractHelper.sol)

### SYSTEM_CONTRACTS_OFFSET

```solidity
uint160 constant SYSTEM_CONTRACTS_OFFSET = 0x8000;
```

### USER_CONTRACTS_OFFSET
*The offset from which the built-in, but user space contracts are located.*


```solidity
uint160 constant USER_CONTRACTS_OFFSET = 0x10000;
```

### BOOTLOADER_ADDRESS

```solidity
address constant BOOTLOADER_ADDRESS = address(SYSTEM_CONTRACTS_OFFSET + 0x01);
```

### MSG_VALUE_SYSTEM_CONTRACT

```solidity
address constant MSG_VALUE_SYSTEM_CONTRACT =
  address(SYSTEM_CONTRACTS_OFFSET + 0x09);
```

### DEPLOYER_SYSTEM_CONTRACT

```solidity
address constant DEPLOYER_SYSTEM_CONTRACT =
  address(SYSTEM_CONTRACTS_OFFSET + 0x06);
```

### L2_BRIDGEHUB_ADDRESS

```solidity
address constant L2_BRIDGEHUB_ADDRESS = address(USER_CONTRACTS_OFFSET + 0x02);
```

### L1_CHAIN_ID

```solidity
uint256 constant L1_CHAIN_ID = 1;
```

### L2_MESSENGER

```solidity
IL2Messenger constant L2_MESSENGER =
  IL2Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));
```

### L2_BASE_TOKEN_ADDRESS

```solidity
IBaseToken constant L2_BASE_TOKEN_ADDRESS =
  IBaseToken(address(SYSTEM_CONTRACTS_OFFSET + 0x0a));
```

### COMPRESSOR_CONTRACT

```solidity
ICompressor constant COMPRESSOR_CONTRACT =
  ICompressor(address(SYSTEM_CONTRACTS_OFFSET + 0x0e));
```

### PUBDATA_CHUNK_PUBLISHER

```solidity
IPubdataChunkPublisher constant PUBDATA_CHUNK_PUBLISHER =
  IPubdataChunkPublisher(address(SYSTEM_CONTRACTS_OFFSET + 0x11));
```

