# Interop Demo Scripts

This demo shows:
- L2 -> L1 interop bundle (send + execute on L1)
- L2 -> L2 interop calls using `InteropLibrary`
- **L2 -> L2 token transfers** with full execution flow

Edit `l1ChainId`, `l2ChainId`, and `l2InteropCenterAddress` in `InteropScripts.s.sol` if your environment differs.

## Prerequisites

```bash
export L1_RPC_URL=http://localhost:8545
export L2A_RPC_URL=http://localhost:3050    # Source L2 chain
export L2B_RPC_URL=http://localhost:3150    # Destination L2 chain
export PRIVATE_KEY=0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
```

Default chain IDs:
- L1: 31337 (Anvil/Hardhat)
- L2A: 6565
- L2B: 6566

Key system contract addresses:
- InteropCenter: `0x0000000000000000000000000000000000010010`
- InteropHandler: `0x000000000000000000000000000000000001000d`
- NativeTokenVault: `0x0000000000000000000000000000000000010004`
- AssetRouter: `0x0000000000000000000000000000000000010003`

---

## L2 -> L2 Token Transfer (Complete Flow)

This is the most common interop use case: sending ERC20 tokens from one L2 to another.

### Step 1: Send Token Bundle (Source L2)

```bash
# Using InteropLibrary.sendToken() via forge script
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendToken(string,address,address,uint256,uint256)" \
  $L2A_RPC_URL \
  <TOKEN_ADDRESS> \
  <RECIPIENT_ADDRESS> \
  <AMOUNT> \
  <DEST_CHAIN_ID>

# Example: Send 1 token (with 18 decimals) to L2B
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendToken(string,address,address,uint256,uint256)" \
  $L2A_RPC_URL \
  0x1bD23c065e237689e98cBCa20206EC0e77040000 \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 \
  1000000000000000000 \
  6566
```

**Save the bundle hash from the output** - you'll need it for execution.

### Step 2: Wait for Batch Sealing

The transaction must be included in a sealed batch before execution. Check with:

```bash
cast rpc zks_getL2ToL1LogProof <TX_HASH> 0 --rpc-url=$L2A_RPC_URL
```

If it returns `null`, the batch hasn't been sealed yet. Wait and retry.

### Step 3: Wait for Interop Root Propagation

The interop root must propagate from source L2 to destination L2. Check with:

```bash
# Get batch number from log proof
BATCH_NUMBER=$(cast rpc zks_getL2ToL1LogProof <TX_HASH> 0 --rpc-url=$L2A_RPC_URL | jq -r '.l1BatchNumber' | xargs printf "%d")

# Check if root is available on destination
cast call 0x0000000000000000000000000000000000010008 \
  "interopRoots(uint256,uint256)(bytes32)" \
  6565 \
  $BATCH_NUMBER \
  --rpc-url=$L2B_RPC_URL
```

When the result is non-zero, the root has propagated.

### Step 4: Execute Bundle (Destination L2)

**Option A: Using the script (recommended)**

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2B_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "executeInteropBundle(string,string,bytes32,address)" \
  $L2B_RPC_URL \
  $L2A_RPC_URL \
  <SEND_BUNDLE_TX_HASH> \
  0x000000000000000000000000000000000001000d
```

**Option B: Manual execution with cast**

```bash
# 1. Get the log proof
LOG_PROOF=$(cast rpc zks_getL2ToL1LogProof <TX_HASH> 0 --rpc-url=$L2A_RPC_URL)

# 2. Get transaction receipt and extract L2ToL1Messenger event data
# Look for event topic: 0x3a36e47291f4201faf137fab081d92295bce2d53be2c6ca68ba82c7faa9ce241
RECEIPT=$(cast rpc eth_getTransactionReceipt <TX_HASH> --rpc-url=$L2A_RPC_URL)

# 3. Extract the raw message data from the L2ToL1Messenger log
# The message format is: 0x01 || abi.encode(InteropBundle)

# 4. Build and send executeBundle transaction
cast send 0x000000000000000000000000000000000001000d \
  "executeBundle(bytes,(uint256,uint256,uint256,(uint16,address,bytes),bytes32[]))" \
  <ENCODED_BUNDLE> \
  "(<SOURCE_CHAIN_ID>,<BATCH_NUMBER>,<MESSAGE_INDEX>,(<TX_INDEX>,0x0000000000000000000000000000000000010010,<RAW_MESSAGE>),[<PROOF_ARRAY>])" \
  --rpc-url=$L2B_RPC_URL \
  --private-key=$PRIVATE_KEY
```

### Step 5: Verify Token Receipt

```bash
cast call <TOKEN_ADDRESS> "balanceOf(address)(uint256)" <RECIPIENT> --rpc-url=$L2B_RPC_URL
```

---

## L2 -> L2 Native Token Transfer

Send base tokens (ETH) from one L2 to another:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendNativeToL2(string,address,address,uint256,uint256)" \
  $L2A_RPC_URL \
  <RECIPIENT> \
  <UNBUNDLER> \
  <AMOUNT_IN_WEI> \
  <DEST_CHAIN_ID>
```

Then execute the bundle on destination using the same steps as token transfer.

---

## L2 -> L2 Arbitrary Call

Send an arbitrary contract call from one L2 to another:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendL2ToL2Call(string,uint256,address,bytes,address,address)" \
  $L2A_RPC_URL \
  <DEST_CHAIN_ID> \
  <TARGET_CONTRACT> \
  <CALLDATA> \
  <EXECUTION_ADDRESS> \
  <UNBUNDLER_ADDRESS>
```

---

## Two-Step Flow: Verify then Execute

For more control, you can verify a bundle first without executing, then execute later.

### Verify Bundle (Step 1)

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2B_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "verifyInteropBundle(string,string,bytes32,address)" \
  $L2B_RPC_URL \
  $L2A_RPC_URL \
  <SEND_BUNDLE_TX_HASH> \
  0x000000000000000000000000000000000001000d
```

### Execute Verified Bundle (Step 2)

Use `executeInteropBundle` as shown above - it will skip verification if already done.

---

## Bundle Status

Check if a bundle has been verified, executed, or is still pending:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2B_RPC_URL --skip-simulation \
  --sig "getBundleStatus(string,bytes32)" \
  $L2B_RPC_URL \
  <BUNDLE_HASH>
```

Status values:
- `Unreceived` - Bundle not yet processed
- `Verified` - Bundle verified but not executed
- `FullyExecuted` - Bundle fully executed
- `Unbundled` - Bundle was unbundled (partial execution)

Check individual call status:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2B_RPC_URL --skip-simulation \
  --sig "getCallStatus(string,bytes32,uint256)" \
  $L2B_RPC_URL \
  <BUNDLE_HASH> \
  0  # call index
```

---

## Token Info & Balance

### Get Token Info (assetId, wrapped address)

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --skip-simulation \
  --sig "getTokenInfo(string,string,address)" \
  $L2A_RPC_URL \
  $L2B_RPC_URL \
  <TOKEN_ADDRESS>
```

### Check Token Balance on Destination

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --skip-simulation \
  --sig "getTokenBalance(string,string,address,address)" \
  $L2A_RPC_URL \
  $L2B_RPC_URL \
  <TOKEN_ADDRESS> \
  <ACCOUNT>
```

### Compute Asset ID

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --skip-simulation \
  --sig "computeAssetId(string,address)" \
  $L2A_RPC_URL \
  <TOKEN_ADDRESS>
```

---

## Send Single Message (ERC-7786)

Send a message to an ERC-7786 compliant contract (implements `receiveMessage`):

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendSingleMessage(string,uint256,address,bytes,address,address)" \
  $L2A_RPC_URL \
  <DEST_CHAIN_ID> \
  <TARGET_CONTRACT> \
  <PAYLOAD_BYTES> \
  0x0000000000000000000000000000000000000000 \
  <UNBUNDLER_ADDRESS>
```

Example: Send "hello" to a Greeting contract:

```bash
# First encode the payload
PAYLOAD=$(cast abi-encode "f(string)" "hello")

forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2A_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendSingleMessage(string,uint256,address,bytes,address,address)" \
  $L2A_RPC_URL \
  6566 \
  0x163CFa0911B9C7166b2608F0E902Fcd341523552 \
  $PAYLOAD \
  0x0000000000000000000000000000000000000000 \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```

---

## ERC-7930 Encoding Helpers

Encode interoperable addresses:

```bash
# Encode chain ID + address
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --sig "encodeERC7930(uint256,address)" \
  6565 \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

# Encode just address
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --sig "encodeERC7930Address(address)" \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

# Encode just chain ID
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --sig "encodeERC7930ChainId(uint256)" \
  6565
```

---

## L2 -> L1 Interop Bundle (Native Token)

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "sendNativeToL1(string,address,address,uint256)" \
  $L2_RPC_URL <L1_RECEIVER> <UNBUNDLER_ADDRESS> 1000000000000000
```

Execute on L1:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L1_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "executeL2ToL1InteropBundle(string,string,bytes32)" \
  $L1_RPC_URL $L2_RPC_URL <L2_TX_HASH>
```

---

## L2 -> L1 Withdrawal (Traditional)

Simple withdrawal using the L2 base token system contract:

```bash
forge script contracts/interop/scripts/dummy-interop/InteropScripts.s.sol \
  --legacy --ffi --rpc-url=$L2_RPC_URL --slow --skip-simulation --broadcast \
  --private-key=$PRIVATE_KEY \
  --sig "withdrawToL1(string,address,uint256)" \
  $L2_RPC_URL <L1_RECEIVER> <AMOUNT>
```

---

## Troubleshooting

### "call to non-contract address 0x8008"
Forge cannot simulate zkSync system contracts. Use `--skip-simulation` flag or execute directly with `cast send`.

### Transaction reverts on executeBundle
- Verify the interop root has propagated to destination chain
- Ensure the message data is extracted correctly from L2ToL1Messenger event (topic `0x3a36e47291f4201faf137fab081d92295bce2d53be2c6ca68ba82c7faa9ce241`)
- Check that sender in proof is InteropCenter (`0x10010`), not L2ToL1Messenger (`0x8008`)

### ERC20InsufficientBalance
Ensure your account has enough tokens. For local testing, use the rich account private key.

### Log proof returns null
The batch containing your transaction hasn't been sealed yet. Wait for batch finalization.
