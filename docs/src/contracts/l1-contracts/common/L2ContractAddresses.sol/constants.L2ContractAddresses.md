# Constants
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/L2ContractAddresses.sol)

### L2_BOOTLOADER_ADDRESS
*The formal address of the initial program of the system: the bootloader*


```solidity
address constant L2_BOOTLOADER_ADDRESS = address(0x8001);
```

### L2_KNOWN_CODE_STORAGE_SYSTEM_CONTRACT_ADDR
*The address of the known code storage system contract*


```solidity
address constant L2_KNOWN_CODE_STORAGE_SYSTEM_CONTRACT_ADDR = address(0x8004);
```

### L2_DEPLOYER_SYSTEM_CONTRACT_ADDR
*The address of the L2 deployer system contract.*


```solidity
address constant L2_DEPLOYER_SYSTEM_CONTRACT_ADDR = address(0x8006);
```

### L2_FORCE_DEPLOYER_ADDR
*The special reserved L2 address. It is located in the system contracts space but doesn't have deployed
bytecode.*

*The L2 deployer system contract allows changing bytecodes on any address if the `msg.sender` is this address.*

*So, whenever the governor wants to redeploy system contracts, it just initiates the L1 upgrade call deployer
system contract
via the L1 -> L2 transaction with `sender == L2_FORCE_DEPLOYER_ADDR`. For more details see the
`diamond-initializers` contracts.*


```solidity
address constant L2_FORCE_DEPLOYER_ADDR = address(0x8007);
```

### L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR
*The address of the special smart contract that can send arbitrary length message as an L2 log*


```solidity
address constant L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR = address(0x8008);
```

### L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR
*The address of the eth token system contract*


```solidity
address constant L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR = address(0x800a);
```

### L2_SYSTEM_CONTEXT_SYSTEM_CONTRACT_ADDR
*The address of the context system contract*


```solidity
address constant L2_SYSTEM_CONTEXT_SYSTEM_CONTRACT_ADDR = address(0x800b);
```

### L2_PUBDATA_CHUNK_PUBLISHER_ADDR
*The address of the pubdata chunk publisher contract*


```solidity
address constant L2_PUBDATA_CHUNK_PUBLISHER_ADDR = address(0x8011);
```

### L2_COMPLEX_UPGRADER_ADDR
*The address used to execute complex upgragedes, also used for the genesis upgrade*


```solidity
address constant L2_COMPLEX_UPGRADER_ADDR = address(0x800f);
```

### L2_GENESIS_UPGRADE_ADDR
*The address used to execute the genesis upgrade*


```solidity
address constant L2_GENESIS_UPGRADE_ADDR = address(0x10001);
```

### L2_BRIDGEHUB_ADDR
*The address of the L2 bridge hub system contract, used to start L1->L2 transactions*


```solidity
address constant L2_BRIDGEHUB_ADDR = address(0x10002);
```

### L2_ASSET_ROUTER_ADDR
*the address of the l2 asset router.*


```solidity
address constant L2_ASSET_ROUTER_ADDR = address(0x10003);
```

### L2_NATIVE_TOKEN_VAULT_ADDR
*An l2 system contract address, used in the assetId calculation for native assets.
This is needed for automatic bridging, i.e. without deploying the AssetHandler contract,
if the assetId can be calculated with this address then it is in fact an NTV asset*


```solidity
address constant L2_NATIVE_TOKEN_VAULT_ADDR = address(0x10004);
```

### L2_MESSAGE_ROOT_ADDR
*the address of the l2 asset router.*


```solidity
address constant L2_MESSAGE_ROOT_ADDR = address(0x10005);
```

### SYSTEM_CONTRACTS_OFFSET
*the offset for the system contracts*


```solidity
uint160 constant SYSTEM_CONTRACTS_OFFSET = 0x8000;
```

### L2_MESSENGER
*the address of the l2 messenger system contract*


```solidity
IL2Messenger constant L2_MESSENGER =
  IL2Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));
```

### MSG_VALUE_SYSTEM_CONTRACT
*the address of the msg value system contract*


```solidity
address constant MSG_VALUE_SYSTEM_CONTRACT =
  address(SYSTEM_CONTRACTS_OFFSET + 0x09);
```

