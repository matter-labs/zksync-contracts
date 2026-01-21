# Interop Integration Tests

End-to-end tests for L2-to-L2 interoperability functionality.

## Prerequisites

### 1. Two Local L2 Nodes Running

Start two local ZKsync nodes with interop enabled:

- **L2A (Chain ID: 6565)**: `http://localhost:3050`
- **L2B (Chain ID: 6566)**: `http://localhost:3051`

### 2. Interop Watcher

The interop watcher service must be running to propagate interop roots between chains.

### 3. Test Token (for token bridging tests)

For `test_sendToken_executedOnDestination`, a test ERC20 token must be deployed on L2A (chain 6565). The test uses a hardcoded token address:

```solidity
address constant TEST_TOKEN = 0xe441CF0795aF14DdB9f7984Da85CD36DB1B8790d;
```

Update this address in `InteropIntegration.t.sol` if using a different token.

### 4. Funded Test Account

The test account must have ETH on both L2A and L2B for gas fees.

Default rich wallet private key:

```
0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
```

## Running Tests

Run tests individually to avoid nonce conflicts:

```bash
# Set the private key
export PRIVATE_KEY=0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

# Test token bridging
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

| Test                                        | Description                                                                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `test_sendToken_executedOnDestination`      | Sends ERC20 tokens from L2A to L2B via NativeTokenVault, verifies the bundle, executes it, and checks that the bundle status is `FullyExecuted` |
| `test_sendBundle_executedOnDestination`     | Deploys a TestReceiver contract on L2B, sends a bundle with a contract call from L2A, executes it, and verifies the receiver got the message    |
| `test_sendMessage_verifiedOnDestination`    | Sends a message from L2A and verifies inclusion proof on L2B using `proveL2MessageInclusionShared`                                               |
| `test_sendL2ToL2Call_executedOnDestination` | Sends an L2-to-L2 call via InteropCenter to a TestReceiver contract and verifies the receiver received the message                               |

## Architecture

The tests use:

- **InteropCenter** (`0x10010`): System contract for sending interop messages
- **InteropHandler** (`0x1000d`): System contract that delivers messages to recipients and tracks bundle status
- **TestReceiver**: A contract implementing `IERC7786Recipient` for receiving test messages
- **InteropScripts**: Foundry script library providing helper functions for sending/verifying/executing interop operations

## Test Flow

Each test follows a similar pattern:

1. **Send**: Create and send an interop message/bundle from L2A
2. **Get Bundle Hash**: Extract the bundle hash from the transaction logs
3. **Verify**: Wait for the interop root to propagate, then verify the bundle on L2B
4. **Execute**: Execute the bundle on the destination chain (L2B)
5. **Check Status**: Verify the bundle status is `FullyExecuted`
