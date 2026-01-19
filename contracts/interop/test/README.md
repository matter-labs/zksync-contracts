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

For `test_sendToken_executedOnDestination`, deploy a test ERC20 token on L2A (chain 6565) and set the `TEST_TOKEN` environment variable:

```bash
export TEST_TOKEN=<deployed_token_address>
```

The test account must have a balance of this token.

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

# Test token bridging (requires TEST_TOKEN to be set)
forge test --match-test test_sendToken_executedOnDestination -vvv --ffi

# Test bundle execution
forge test --match-test test_sendBundle_executedOnDestination -vvv --ffi

# Test message verification
forge test --match-test test_sendMessage_verifiedOnDestination -vvv --ffi

# Test L2-to-L2 contract calls
forge test --match-test test_sendL2ToL2Call_executedOnDestination -vvv --ffi
```

**Note**: Running all tests together may cause nonce conflicts since they use the same account concurrently.

## Test Descriptions

| Test | Description |
|------|-------------|
| `test_sendToken_executedOnDestination` | Sends ERC20 tokens from L2A to L2B via NativeTokenVault and verifies receipt |
| `test_sendBundle_executedOnDestination` | Sends a bundle with a contract call from L2A to L2B and verifies execution |
| `test_sendMessage_verifiedOnDestination` | Sends a message from L2A and verifies inclusion proof on L2B |
| `test_sendL2ToL2Call_executedOnDestination` | Sends an L2-to-L2 call via InteropCenter and verifies the receiver contract got the message |

## Architecture

The tests use:
- **InteropCenter** (`0x10010`): System contract for sending interop messages
- **InteropHandler** (`0x1000d`): System contract that delivers messages to recipients
- **TestReceiver**: A simple contract implementing `IERC7786Recipient` for receiving test messages
