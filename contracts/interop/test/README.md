# Interop Integration Tests

End-to-end tests for L2-to-L2 interoperability functionality.

## Prerequisites

### For Era Setup

Run the interop setup script:

```bash
infrastructure/scripts/interop.sh
```

### For ZKsync OS Setup

Start two local ZKsync nodes with interop enabled:

- **L2A**: Source chain
- **L2B**: Destination chain

The interop watcher service must be running to propagate interop roots between chains.

### Test Token (for token bridging tests)

For `test_sendToken_executedOnDestination`, a test ERC20 token must be deployed on L2A. The test uses a hardcoded token address - update `TEST_TOKEN` in `InteropIntegration.t.sol` if using a different token.

### Funded Test Account

The test account must have ETH on both L2A and L2B for gas fees.

Default rich wallet private key:

```
0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
```

### TestReceiver for Native Token Tests

The `test_sendNativeToken_executedOnDestination` test requires a pre-deployed `TestReceiver` contract on L2B. Deploy it with the correct InteropHandler address for your mode:

```bash
# For Era mode (InteropHandler = 0x1000E):
forge create --zksync --rpc-url $L2B_RPC_URL \
  --private-key $PRIVATE_KEY --broadcast --zk-gas-per-pubdata 800 \
  contracts/interop/test-contracts/TestReceiver.sol:TestReceiver \
  --constructor-args 0x000000000000000000000000000000000001000E

# For ZKsync OS mode (InteropHandler = 0x1000d):
forge create --zksync --rpc-url $L2B_RPC_URL \
  --private-key $PRIVATE_KEY --broadcast --zk-gas-per-pubdata 800 \
  contracts/interop/test-contracts/TestReceiver.sol:TestReceiver \
  --constructor-args 0x000000000000000000000000000000000001000d
```

Update `TEST_RECEIVER_L2B` in `InteropIntegration.t.sol` with the deployed address.

**Note**: Other tests (`test_sendBundle_*`, `test_sendL2ToL2Call_*`) deploy TestReceiver dynamically during the test.

## Running Tests

Run tests individually to avoid nonce conflicts:

```bash
# Set the private key
export PRIVATE_KEY=0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

# Test native ETH bridging (requires pre-deployed TestReceiver on L2B)
forge test --match-test test_sendNativeToken_executedOnDestination -vvv --ffi

# Test ERC20 token bridging
forge test --match-test test_sendToken_executedOnDestination -vvv --ffi

# Test bundle execution with contract call
forge test --match-test test_sendBundle_executedOnDestination -vvv --ffi

# Test message verification
forge test --match-test test_sendMessage_verifiedOnDestination -vvv --ffi

# Test L2-to-L2 contract calls
forge test --match-test test_sendL2ToL2Call_executedOnDestination -vvv --ffi
```

**Note**: Running all tests together may cause nonce conflicts since they use the same account concurrently.

## Test Descriptions

| Test                                          | Description                                                                                                                                      |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `test_sendNativeToken_executedOnDestination`  | Sends native ETH from L2A to L2B via interopCallValue, verifies and executes the bundle. Requires pre-deployed TestReceiver on L2B              |
| `test_sendToken_executedOnDestination`        | Sends ERC20 tokens from L2A to L2B via NativeTokenVault, verifies the bundle, executes it, and checks that the bundle status is `FullyExecuted` |
| `test_sendBundle_executedOnDestination`       | Deploys a TestReceiver contract on L2B, sends a bundle with a contract call from L2A, executes it, and verifies the receiver got the message    |
| `test_sendMessage_verifiedOnDestination`      | Sends a message from L2A and verifies inclusion proof on L2B using `proveL2MessageInclusionShared`                                               |
| `test_sendL2ToL2Call_executedOnDestination`   | Sends an L2-to-L2 call via InteropCenter to a TestReceiver contract and verifies the receiver received the message                               |

## Architecture

The tests use:

- **InteropCenter**: System contract for sending interop messages
- **InteropHandler**: System contract that delivers messages to recipients and tracks bundle status
- **TestReceiver**: A contract implementing `IERC7786Recipient` for receiving test messages
- **InteropScripts**: Foundry script library providing helper functions for sending/verifying/executing interop operations

### System Contract Addresses

The system contract addresses differ between Era and ZKsync OS modes:

| Contract       | Era Mode   | ZKsync OS Mode |
| -------------- | ---------- | -------------- |
| InteropCenter  | `0x1000d`  | `0x10010`      |
| InteropHandler | `0x1000E`  | `0x1000d`      |

Set `USE_ERA_MODE` in `InteropIntegration.t.sol` based on your environment.

## Test Flow

Each test follows a similar pattern:

1. **Send**: Create and send an interop message/bundle from L2A
2. **Get Bundle Hash**: Extract the bundle hash from the transaction logs
3. **Verify**: Wait for the interop root to propagate, then verify the bundle on L2B
4. **Execute**: Execute the bundle on the destination chain (L2B)
5. **Check Status**: Verify the bundle status is `FullyExecuted`
