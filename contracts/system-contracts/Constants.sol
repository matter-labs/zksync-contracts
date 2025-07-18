// SPDX-License-Identifier: MIT
// We use a floating point pragma here so it can be used within other projects that interact with the ZKsync ecosystem without using our exact pragma version.
pragma solidity ^0.8.0;

import { IAccountCodeStorage } from "./interfaces/IAccountCodeStorage.sol";

import { IBaseToken } from "./interfaces/IBaseToken.sol";

import { IBootloaderUtilities } from "./interfaces/IBootloaderUtilities.sol";
import { IBridgehub } from "./interfaces/IBridgehub.sol";
import { IComplexUpgrader } from "./interfaces/IComplexUpgrader.sol";
import { ICompressor } from "./interfaces/ICompressor.sol";
import { IContractDeployer } from "./interfaces/IContractDeployer.sol";

import { ICreate2Factory } from "./interfaces/ICreate2Factory.sol";
import { IEvmHashesStorage } from "./interfaces/IEvmHashesStorage.sol";
import { IImmutableSimulator } from "./interfaces/IImmutableSimulator.sol";
import { IKnownCodesStorage } from "./interfaces/IKnownCodesStorage.sol";

import { IL1Messenger } from "./interfaces/IL1Messenger.sol";
import { IMessageRoot } from "./interfaces/IMessageRoot.sol";
import { INonceHolder } from "./interfaces/INonceHolder.sol";
import { IPubdataChunkPublisher } from "./interfaces/IPubdataChunkPublisher.sol";
import { ISystemContext } from "./interfaces/ISystemContext.sol";

/// @dev All the system contracts introduced by ZKsync have their addresses
/// started from 2^15 in order to avoid collision with Ethereum precompiles.
uint160 constant SYSTEM_CONTRACTS_OFFSET = 0x8000; // 2^15

/// @dev Unlike the value above, it is not overridden for the purpose of testing and
/// is identical to the constant value actually used as the system contracts offset on
/// mainnet.
uint160 constant REAL_SYSTEM_CONTRACTS_OFFSET = 0x8000;

/// @dev All the system contracts must be located in the kernel space,
/// i.e. their addresses must be below 2^16.
uint160 constant MAX_SYSTEM_CONTRACT_ADDRESS = 0xffff; // 2^16 - 1

/// @dev The offset from which the built-in, but user space contracts are located.
uint160 constant USER_CONTRACTS_OFFSET = MAX_SYSTEM_CONTRACT_ADDRESS + 1;

address constant ECRECOVER_SYSTEM_CONTRACT = address(0x01);
address constant SHA256_SYSTEM_CONTRACT = address(0x02);
address constant IDENTITY_SYSTEM_CONTRACT = address(0x04);
address constant MODEXP_SYSTEM_CONTRACT = address(0x05);
address constant ECADD_SYSTEM_CONTRACT = address(0x06);
address constant ECMUL_SYSTEM_CONTRACT = address(0x07);
address constant ECPAIRING_SYSTEM_CONTRACT = address(0x08);

/// @dev The number of gas that need to be spent for a single byte of pubdata regardless of the pubdata price.
/// This variable is used to ensure the following:
/// - That the long-term storage of the operator is compensated properly.
/// - That it is not possible that the pubdata counter grows too high without spending proportional amount of computation.
uint256 constant COMPUTATIONAL_PRICE_FOR_PUBDATA = 80;

/// @dev The maximal possible address of an L1-like precompie. These precompiles maintain the following properties:
/// - Their extcodehash is EMPTY_STRING_KECCAK
/// - Their extcodesize is 0 despite having a bytecode formally deployed there.
uint256 constant CURRENT_MAX_PRECOMPILE_ADDRESS = 0xff;

address payable constant BOOTLOADER_FORMAL_ADDRESS =
  payable(address(SYSTEM_CONTRACTS_OFFSET + 0x01));
IAccountCodeStorage constant ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT =
  IAccountCodeStorage(address(SYSTEM_CONTRACTS_OFFSET + 0x02));
INonceHolder constant NONCE_HOLDER_SYSTEM_CONTRACT =
  INonceHolder(address(SYSTEM_CONTRACTS_OFFSET + 0x03));
IKnownCodesStorage constant KNOWN_CODE_STORAGE_CONTRACT =
  IKnownCodesStorage(address(SYSTEM_CONTRACTS_OFFSET + 0x04));
IImmutableSimulator constant IMMUTABLE_SIMULATOR_SYSTEM_CONTRACT =
  IImmutableSimulator(address(SYSTEM_CONTRACTS_OFFSET + 0x05));
IContractDeployer constant DEPLOYER_SYSTEM_CONTRACT =
  IContractDeployer(address(SYSTEM_CONTRACTS_OFFSET + 0x06));
IContractDeployer constant REAL_DEPLOYER_SYSTEM_CONTRACT =
  IContractDeployer(address(REAL_SYSTEM_CONTRACTS_OFFSET + 0x06));

// A contract that is allowed to deploy any codehash
// on any address. To be used only during an upgrade.
address constant FORCE_DEPLOYER = address(SYSTEM_CONTRACTS_OFFSET + 0x07);
IL1Messenger constant L1_MESSENGER_CONTRACT =
  IL1Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));
address constant MSG_VALUE_SYSTEM_CONTRACT =
  address(SYSTEM_CONTRACTS_OFFSET + 0x09);

IBaseToken constant BASE_TOKEN_SYSTEM_CONTRACT =
  IBaseToken(address(SYSTEM_CONTRACTS_OFFSET + 0x0a));
IBaseToken constant REAL_BASE_TOKEN_SYSTEM_CONTRACT =
  IBaseToken(address(REAL_SYSTEM_CONTRACTS_OFFSET + 0x0a));

ISystemContext constant SYSTEM_CONTEXT_CONTRACT =
  ISystemContext(payable(address(SYSTEM_CONTRACTS_OFFSET + 0x0b)));
ISystemContext constant REAL_SYSTEM_CONTEXT_CONTRACT =
  ISystemContext(payable(address(REAL_SYSTEM_CONTRACTS_OFFSET + 0x0b)));

IBootloaderUtilities constant BOOTLOADER_UTILITIES =
  IBootloaderUtilities(address(SYSTEM_CONTRACTS_OFFSET + 0x0c));

// It will be a different value for tests, while shouldn't. But for now, this constant is not used by other contracts, so that's fine.
address constant EVENT_WRITER_CONTRACT = address(SYSTEM_CONTRACTS_OFFSET + 0x0d);

ICompressor constant COMPRESSOR_CONTRACT =
  ICompressor(address(SYSTEM_CONTRACTS_OFFSET + 0x0e));

IComplexUpgrader constant COMPLEX_UPGRADER_CONTRACT =
  IComplexUpgrader(address(SYSTEM_CONTRACTS_OFFSET + 0x0f));

// Hardcoded because even for tests we should keep the address. (Instead `SYSTEM_CONTRACTS_OFFSET + 0x10`)
// Precompile call depends on it.
// And we don't want to mock this contract.
address constant KECCAK256_SYSTEM_CONTRACT = address(0x8010);

IPubdataChunkPublisher constant PUBDATA_CHUNK_PUBLISHER =
  IPubdataChunkPublisher(address(SYSTEM_CONTRACTS_OFFSET + 0x11));

address constant CODE_ORACLE_SYSTEM_CONTRACT =
  address(SYSTEM_CONTRACTS_OFFSET + 0x12);

address constant EVM_GAS_MANAGER = address(SYSTEM_CONTRACTS_OFFSET + 0x13);
address constant EVM_PREDEPLOYS_MANAGER =
  address(SYSTEM_CONTRACTS_OFFSET + 0x14);
IEvmHashesStorage constant EVM_HASHES_STORAGE =
  IEvmHashesStorage(address(SYSTEM_CONTRACTS_OFFSET + 0x15));

ICreate2Factory constant L2_CREATE2_FACTORY =
  ICreate2Factory(address(USER_CONTRACTS_OFFSET));
address constant L2_ASSET_ROUTER = address(USER_CONTRACTS_OFFSET + 0x03);
IBridgehub constant L2_BRIDGE_HUB =
  IBridgehub(address(USER_CONTRACTS_OFFSET + 0x02));
address constant L2_NATIVE_TOKEN_VAULT_ADDR =
  address(USER_CONTRACTS_OFFSET + 0x04);
IMessageRoot constant L2_MESSAGE_ROOT =
  IMessageRoot(address(USER_CONTRACTS_OFFSET + 0x05));
// Note, that on its own this contract does not provide much functionality, but having it on a constant address
// serves as a convenient storage for its bytecode to be accessible via `extcodehash`.
address constant SLOAD_CONTRACT_ADDRESS = address(USER_CONTRACTS_OFFSET + 0x06);

address constant WRAPPED_BASE_TOKEN_IMPL_ADDRESS =
  address(USER_CONTRACTS_OFFSET + 0x07);

/// @dev If the bitwise AND of the extraAbi[2] param when calling the MSG_VALUE_SIMULATOR
/// is non-zero, the call will be assumed to be a system one.
uint256 constant MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT = 1;

/// @dev The maximal msg.value that context can have
uint256 constant MAX_MSG_VALUE = type(uint128).max;

/// @dev Prefix used during derivation of account addresses using CREATE2
/// @dev keccak256("zksyncCreate2")
bytes32 constant CREATE2_PREFIX =
  0x2020dba91b30cc0006188af794c2fb30dd8520db7e2c088b7fc7c103c00ca494;
/// @dev Prefix used during derivation of account addresses using CREATE
/// @dev keccak256("zksyncCreate")
bytes32 constant CREATE_PREFIX =
  0x63bae3a9951d38e8a3fbb7b70909afc1200610fc5bc55ade242f815974674f23;

/// @dev Prefix used during derivation of account addresses using CREATE2 within the EVM
bytes1 constant CREATE2_EVM_PREFIX = 0xff;

/// @dev Each state diff consists of 156 bytes of actual data and 116 bytes of unused padding, needed for circuit efficiency.
uint256 constant STATE_DIFF_ENTRY_SIZE = 272;

enum SystemLogKey {
  L2_TO_L1_LOGS_TREE_ROOT_KEY,
  PACKED_BATCH_AND_L2_BLOCK_TIMESTAMP_KEY,
  CHAINED_PRIORITY_TXN_HASH_KEY,
  NUMBER_OF_LAYER_1_TXS_KEY,
  // Note, that it is important that `PREV_BATCH_HASH_KEY` has position
  // `4` since it is the same as it was in the previous protocol version and
  // it is the only one that is emitted before the system contracts are upgraded.
  PREV_BATCH_HASH_KEY,
  L2_DA_VALIDATOR_OUTPUT_HASH_KEY,
  USED_L2_DA_VALIDATOR_ADDRESS_KEY,
  EXPECTED_SYSTEM_CONTRACT_UPGRADE_TX_HASH_KEY
}

/// @dev The number of leaves in the L2->L1 log Merkle tree.
/// While formally a tree of any length is acceptable, the node supports only a constant length of 16384 leaves.
uint256 constant L2_TO_L1_LOGS_MERKLE_TREE_LEAVES = 16_384;

/// @dev The length of the derived key in bytes inside compressed state diffs.
uint256 constant DERIVED_KEY_LENGTH = 32;
/// @dev The length of the enum index in bytes inside compressed state diffs.
uint256 constant ENUM_INDEX_LENGTH = 8;
/// @dev The length of value in bytes inside compressed state diffs.
uint256 constant VALUE_LENGTH = 32;

/// @dev The length of the compressed initial storage write in bytes.
uint256 constant COMPRESSED_INITIAL_WRITE_SIZE =
  DERIVED_KEY_LENGTH + VALUE_LENGTH;
/// @dev The length of the compressed repeated storage write in bytes.
uint256 constant COMPRESSED_REPEATED_WRITE_SIZE =
  ENUM_INDEX_LENGTH + VALUE_LENGTH;

/// @dev The position from which the initial writes start in the compressed state diffs.
uint256 constant INITIAL_WRITE_STARTING_POSITION = 4;

/// @dev Each storage diffs consists of the following elements:
/// [20bytes address][32bytes key][32bytes derived key][8bytes enum index][32bytes initial value][32bytes final value]
/// @dev The offset of the derived key in a storage diff.
uint256 constant STATE_DIFF_DERIVED_KEY_OFFSET = 52;
/// @dev The offset of the enum index in a storage diff.
uint256 constant STATE_DIFF_ENUM_INDEX_OFFSET = 84;
/// @dev The offset of the final value in a storage diff.
uint256 constant STATE_DIFF_FINAL_VALUE_OFFSET = 124;

/// @dev Total number of bytes in a blob. Blob = 4096 field elements * 31 bytes per field element
/// @dev EIP-4844 defines it as 131_072 but we use 4096 * 31 within our circuits to always fit within a field element
/// @dev Our circuits will prove that a EIP-4844 blob and our internal blob are the same.
uint256 constant BLOB_SIZE_BYTES = 126_976;

/// @dev Max number of blobs currently supported
uint256 constant MAX_NUMBER_OF_BLOBS = 6;

/// @dev Marker of EraVM bytecode
uint8 constant ERA_VM_BYTECODE_FLAG = 1;
/// @dev Marker of EVM bytecode
uint8 constant EVM_BYTECODE_FLAG = 2;

address constant SERVICE_CALL_PSEUDO_CALLER =
  0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
