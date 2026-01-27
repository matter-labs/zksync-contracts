// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// solhint-disable no-console, gas-custom-errors, reason-string

import { Script, console2 as console } from "forge-std/Script.sol";

import { stdJson } from "forge-std/StdJson.sol";

import { ProofData } from "../../l1-contracts/common/Messaging.sol";
import {
  AltL2ToL1Log,
  AltLog,
  AltTransactionReceipt,
  L2ToL1Log,
  L2ToL1LogProof,
  Log,
  TransactionReceipt
} from "./ReceipTypes.sol";

import {
  IL1AssetRouter
} from "../../l1-contracts/bridge/asset-router/IL1AssetRouter.sol";
import {
  FinalizeL1DepositParams,
  IL1Nullifier
} from "../../l1-contracts/bridge/interfaces/IL1Nullifier.sol";
import { IBridgehub } from "../../l1-contracts/bridgehub/IBridgehub.sol";
import { IMessageRoot } from "../../l1-contracts/bridgehub/IMessageRoot.sol";
import {
  IGetters
} from "../../l1-contracts/state-transition/chain-interfaces/IGetters.sol";

contract ZKSProvider is Script {
  function finalizeWithdrawal(
    uint256 chainId,
    address l1Bridgehub,
    string memory l2RpcUrl,
    bytes32 withdrawalHash,
    uint256 index
  ) public {
    FinalizeL1DepositParams memory params =
      getFinalizeWithdrawalParams(chainId, l2RpcUrl, withdrawalHash, index);

    IBridgehub bridgehub = IBridgehub(l1Bridgehub);
    IL1AssetRouter assetRouter = IL1AssetRouter(bridgehub.assetRouter());
    IL1Nullifier nullifier = IL1Nullifier(assetRouter.L1_NULLIFIER());

    waitForBatchToBeExecuted(l1Bridgehub, chainId, params);

    // Send the transaction
    vm.startBroadcast();
    nullifier.finalizeDeposit(params);
    vm.stopBroadcast();
  }

  function waitForWithdrawalToBeFinalized(
    uint256 chainId,
    address l1Bridgehub,
    string memory l2RpcUrl,
    bytes32 withdrawalHash,
    uint256 index
  ) public {
    FinalizeL1DepositParams memory params =
      getFinalizeWithdrawalParams(chainId, l2RpcUrl, withdrawalHash, index);
    waitForBatchToBeExecuted(l1Bridgehub, chainId, params);
  }

  /// we might not need this.
  /// nullifier.finalizeDeposit simulation probably happens at an earlier blocknumber.
  /// It might be enough to wait for the merkle proof from the server.
  function waitForBatchToBeExecuted(
    address l1Bridgehub,
    uint256 chainId,
    FinalizeL1DepositParams memory params
  ) public {
    IBridgehub bridgehub = IBridgehub(l1Bridgehub);
    // IL1AssetRouter assetRouter = IL1AssetRouter(bridgehub.assetRouter());
    // IL1Nullifier nullifier = IL1Nullifier(assetRouter.L1_NULLIFIER());
    IMessageRoot messageRoot = IMessageRoot(bridgehub.messageRoot());
    ProofData memory proofData = messageRoot.getProofData(
      params.chainId,
      params.l2BatchNumber,
      params.l2MessageIndex,
      bytes32(0),
      params.merkleProof
    );

    // console.log("proofData");
    uint256 actualChainId = chainId;
    uint256 actualBatchNumber = params.l2BatchNumber;
    if (
      proofData.settlementLayerChainId != chainId
        && proofData.settlementLayerChainId != 0
    ) {
      actualChainId = proofData.settlementLayerChainId;
      actualBatchNumber = proofData.settlementLayerBatchNumber;
    }

    IGetters getters = IGetters(bridgehub.getZKChain(actualChainId));
    uint256 totalBatchesExecuted;
    uint256 loopCount = 0;
    // _initCreate2FactoryParams(address(0), bytes32(0));
    // instantiateCreate2Factory();

    // IteratedReader reader = IteratedReader(deployViaCreate2(abi.encodePacked(type(IteratedReader).creationCode)));
    // console.log("Reader deployed at", address(reader));

    while (totalBatchesExecuted < actualBatchNumber && loopCount < 30) {
      loopCount++;
      // totalBatchesExecuted = getters.getTotalBatchesExecuted();
      totalBatchesExecuted = getTotalBatchesExecuted(address(getters));
      uint256 secondsToWait = 5;
      vm.sleep(secondsToWait * 1000);
      console.log(
        "Waiting for batch to be executed",
        totalBatchesExecuted,
        actualBatchNumber
      );
      console.log("Waited", loopCount * secondsToWait, "seconds");
    }
    // require(totalBatchesExecuted >= actualBatchNumber, "Batch not executed");
  }

  /// we use this as forge caches the result
  function getTotalBatchesExecuted(address chainAddress)
    public
    returns (uint256)
  {
    string[] memory args = new string[](5);
    args[0] = "cast";
    args[1] = "call";
    args[2] = vm.toString(chainAddress);
    args[3] = "getTotalBatchesExecuted()(uint256)";
    args[4] = "--json";

    bytes memory modifiedJsonBytes = vm.ffi(args);
    string memory modifiedJson = vm.toString(modifiedJsonBytes);
    string memory json2 = string(modifiedJsonBytes);
    // console.log("Total batches executed", modifiedJson);
    // console.log("json2", json2);
    bytes memory res = vm.parseJson(json2, "$[0]");
    string memory resString = abi.decode(res, (string));
    uint256 val = vm.parseUint(resString);
    return val;
  }

  function getWithdrawalLog(
    string memory l2RpcUrl,
    bytes32 withdrawalHash,
    uint256 index
  ) public returns (Log memory log, uint64 l1BatchTxId) {
    require(bytes(l2RpcUrl).length > 0, "L2 RPC URL not set");

    // Get transaction receipt
    TransactionReceipt memory receipt =
      getTransactionReceipt(l2RpcUrl, withdrawalHash);

    // Find withdrawal logs (logs from L1_MESSENGER_ADDRESS)
    address L1_MESSENGER_ADDRESS = 0x0000000000000000000000000000000000008008;
    bytes32 L1_MESSAGE_SENT_TOPIC =
      0x3a36e47291f4201faf137fab081d92295bce2d53be2c6ca68ba82c7faa9ce241;
    uint256 withdrawalLogCount = 0;

    for (uint256 i = 0; i < receipt.logs.length; i++) {
      if (
        receipt.logs[i].addr == L1_MESSENGER_ADDRESS
          && receipt.logs[i].topics[0] == L1_MESSAGE_SENT_TOPIC
      ) {
        // console.log(receipt.logs[i].addr);
        // console.log()
        if (withdrawalLogCount == index) {
          log = receipt.logs[i];
          l1BatchTxId = uint64(receipt.transactionIndex);
          return (log, l1BatchTxId);
        }
        withdrawalLogCount++;
      }
    }

    console.log("Withdrawal log not found at specified index", index);
  }

  function getWithdrawalL2ToL1Log(
    string memory l2RpcUrl,
    bytes32 withdrawalHash,
    uint256 index
  ) public returns (uint64 logIndex, L2ToL1Log memory log) {
    require(bytes(l2RpcUrl).length > 0, "L2 RPC URL not set");

    // Get transaction receipt
    TransactionReceipt memory receipt =
      getTransactionReceipt(l2RpcUrl, withdrawalHash);

    // Find L2ToL1 logs from L1_MESSENGER_ADDRESS
    address L1_MESSENGER_ADDRESS = 0x0000000000000000000000000000000000008008;
    uint256 withdrawalLogCount = 0;

    for (uint256 i = 0; i < receipt.l2ToL1Logs.length; i++) {
      // console.log("l2ToL1Logs");
      // console.log(i, receipt.l2ToL1Logs[i].logIndex);
      if (receipt.l2ToL1Logs[i].sender == L1_MESSENGER_ADDRESS) {
        if (withdrawalLogCount == index) {
          log = receipt.l2ToL1Logs[i];
          logIndex = uint64(i);
          return (logIndex, log);
        }
        withdrawalLogCount++;
      }
    }

    console.log("L2ToL1 log not found at specified index", index);
  }

  function getFinalizeWithdrawalParams(
    uint256 chainId,
    string memory l2RpcUrl,
    bytes32 withdrawalHash,
    uint256 index
  ) public returns (FinalizeL1DepositParams memory params) {
    require(bytes(l2RpcUrl).length > 0, "L2 RPC URL not set");

    // Get withdrawal log and L2ToL1 log
    (Log memory log, uint64 l1BatchTxId) =
      getWithdrawalLog(l2RpcUrl, withdrawalHash, index);
    (uint64 l2ToL1LogIndex, L2ToL1Log memory l2ToL1Log) =
      getWithdrawalL2ToL1Log(l2RpcUrl, withdrawalHash, index);
    if (l2ToL1Log.key == bytes32(0)) {
      return params;
    }

    // Get L2ToL1 log proof
    L2ToL1LogProof memory proof =
      getL2ToL1LogProof(l2RpcUrl, withdrawalHash, l2ToL1LogIndex);
    // console.log("withdrawalHash");
    // console.logBytes32(withdrawalHash);

    // Extract sender and message from log
    (address sender, bytes memory message) = getMessageFromLog(log);

    params = FinalizeL1DepositParams({
      chainId: chainId,
      l2BatchNumber: proof.batchNumber,
      l2MessageIndex: proof.id,
      l2TxNumberInBatch: uint16(l2ToL1Log.txIndexInL1Batch),
      message: message,
      l2Sender: sender,
      merkleProof: proof.proof
    });
  }

  function getMessageFromLog(Log memory log)
    public
    pure
    returns (address sender, bytes memory message)
  {
    // Extract sender from topic[1] (last 20 bytes)
    // console.log("log.topics[1]");
    // console.log(log.topics.length);
    // console.logBytes32(log.topics[0]);
    sender = address(uint160(uint256(log.topics[1])));

    // Decode message from log data
    // Assuming the data contains the message directly
    message = abi.decode(abi.decode(log.data, (bytes)), (bytes));
  }

  function getTransactionReceipt(string memory l2RpcUrl, bytes32 txHash)
    internal
    returns (TransactionReceipt memory receipt)
  {
    string[] memory args = new string[](10);
    args[0] = "curl";
    args[1] = "-s";
    args[2] = "--request";
    args[3] = "POST";
    args[4] = "--url";
    args[5] = l2RpcUrl;
    args[6] = "--header";
    args[7] = "Content-Type: application/json";
    args[8] = "--data";
    args[9] = string.concat(
      '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["',
      vm.toString(txHash),
      '"],"id":1}'
    );

    bytes memory result = vm.ffi(args);
    receipt = parseTransactionReceipt(result);
  }

  function getL2ToL1LogProof(
    string memory l2RpcUrl,
    bytes32 txHash,
    uint64 logIndex
  ) internal returns (L2ToL1LogProof memory proof) {
    // Use "proof_based_gw" for interop proofs that go through Gateway
    return
      _getL2ToL1LogProofWithMode(l2RpcUrl, txHash, logIndex, "proof_based_gw");
  }

  function _getL2ToL1LogProofWithMode(
    string memory l2RpcUrl,
    bytes32 txHash,
    uint64 logIndex,
    string memory mode
  ) internal returns (L2ToL1LogProof memory proof) {
    string[] memory args = new string[](10);
    args[0] = "curl";
    args[1] = "-s";
    args[2] = "--request";
    args[3] = "POST";
    args[4] = "--url";
    args[5] = l2RpcUrl;
    args[6] = "--header";
    args[7] = "Content-Type: application/json";
    args[8] = "--data";
    args[9] = string.concat(
      '{"jsonrpc":"2.0","id":1,"method":"zks_getL2ToL1LogProof","params":["',
      vm.toString(txHash),
      '",',
      vm.toString(logIndex),
      ',"',
      mode,
      '"]}'
    );
    // Execute RPC call

    bytes memory nullProofBytes =
      "0x7b226a736f6e727063223a22322e30222c226964223a312c22726573756c74223a6e756c6c7d";
    string memory nullProofString2 = '{"jsonrpc":"2.0","id":1,"result":null}';
    string memory nullProofString3 =
      "0x7b226a736f6e727063223a22322e30222c226964223a312c226572726f72223a7b22636f6465223a2d33323630332c226d657373616765223a224c3120626174636820636f6e7461696e696e6720746865207472616e73616374696f6e20686173206e6f74206265656e20657865637574656420796574227d7d";
    string memory nullProofString4 =
      '{"jsonrpc":"2.0","id":1,"error":{"code":-32603,"message":"L1 batch containing the transaction has not been executed yet"}}';
    string memory nullProofString5 = "0x4261642047617465776179";
    bytes memory result = nullProofBytes;
    while (
      compareStrings(string(result), string(nullProofBytes))
        || compareStrings(string(result), string(nullProofString2))
        || compareStrings(string(result), string(nullProofString3))
        || compareStrings(string(result), string(nullProofString4))
        || compareStrings(string(result), string(nullProofString5))
    ) {
      result = vm.ffi(args);
      console.log(string(result));
      vm.sleep(4000);
    }

    proof = parseL2ToL1LogProof(result);
  }

  function parseTransactionReceipt(bytes memory jsonResponse)
    internal
    returns (TransactionReceipt memory receipt)
  {
    string memory responseStr = string(jsonResponse);

    string memory modifiedJson =
      callParseAltLog(responseStr, "parse-transaction-receipt.sh");
    string memory altTransactionReceiptJson =
      callParseAltLog(responseStr, "parse-alt-transaction-receipt.sh");

    bytes memory resultBytes =
      vm.parseJson(altTransactionReceiptJson, "$.result");
    AltTransactionReceipt memory result =
      abi.decode(resultBytes, (AltTransactionReceipt));

    // console.log("successful result");
    // console.log("Block Number:", result.blockNumber);
    // console.log("Block Hash:", vm.toString(result.blockHash));
    // // console.log("Contract Address:", result.contractAddress);
    // console.log("Cumulative Gas Used:", result.cumulativeGasUsed);
    // console.log("Effective Gas Price:", result.effectiveGasPrice);
    // console.log("From:", result.from);
    // console.log("Gas Used:", result.gasUsed);
    // console.log("L1 Batch Number:", result.l1BatchNumber);
    // console.log("L1 Batch Tx Index:", result.l1BatchTxIndex);
    // console.log("Status:", result.status);
    // console.log("To:", result.to);
    // console.log("Transaction Hash:", vm.toString(result.transactionHash));
    // console.log("Transaction Index:", result.transactionIndex);
    // console.log("Transaction Type:", result.txType);

    AltLog[] memory altLogs;
    {
      string memory altLogsJson =
        callParseAltLog(responseStr, "parse-alt-logs.sh");
      bytes memory logBytes = vm.parseJson(altLogsJson, "$.logs");
      altLogs = abi.decode(logBytes, (AltLog[]));
      // console.log("altLogs");
      // console.log("length", altLogs.length);
      // console.log("addr", altLogs[0].addr);
      // console.log("blockHash", vm.toString(altLogs[0].blockHash));
      // console.log("blockNumber", altLogs[0].blockNumber);
      // console.log("blockTimestamp", altLogs[0].blockTimestamp);
      // console.log("logIndex", altLogs[0].logIndex);
      // console.log("l1BatchNumber", altLogs[0].l1BatchNumber);
      // console.log("transactionHash", vm.toString(altLogs[0].transactionHash));
      // console.log("transactionIndex", altLogs[0].transactionIndex);
      // console.log("transactionLogIndex", altLogs[0].transactionLogIndex);
    }

    bytes[] memory altLogsData = new bytes[](altLogs.length);
    bytes32[][] memory altLogsTopics = new bytes32[][](altLogs.length);
    {
      for (uint256 i = 0; i < altLogs.length; i++) {
        string memory altLogsDataJson =
          callParseAltLog(responseStr, "parse-alt-logs-data.sh", i);
        string memory altLogsTopicsJson =
          callParseAltLog(responseStr, "parse-alt-logs-topics.sh", i);

        // vm.parseJson returns ABI-encoded bytes for hex string values
        bytes memory altLogsDataBytes = vm.parseJson(altLogsDataJson, "$.data");
        altLogsData[i] = altLogsDataBytes;

        // For topics array, vm.parseJson returns ABI-encoded bytes32[]
        bytes memory altLogsTopicsBytes =
          vm.parseJson(altLogsTopicsJson, "$.topics");
        altLogsTopics[i] = abi.decode(altLogsTopicsBytes, (bytes32[]));
      }
    }

    // console.log("successful logs");
    // console.log(altLogs.length);
    // console.log(altLogs[0].addr);
    // console.log(vm.toString(altLogs[0].blockHash));
    // console.log(vm.toString(altLogs[0].blockNumber));
    // console.log(vm.toString(altLogs[0].blockTimestamp));
    // console.log(vm.toString(altLogs[0].logIndex));
    // console.log(vm.toString(altLogs[0].l1BatchNumber));
    // console.log(vm.toString(altLogs[0].transactionHash));
    // console.log(vm.toString(altLogs[0].transactionIndex));

    string memory altL2ToL1LogsJson =
      callParseAltLog(responseStr, "parse-alt-l2-to-l1-logs.sh");
    // console.log(altL2ToL1LogsJson);

    bytes memory l2ToL1LogsBytes =
      vm.parseJson(altL2ToL1LogsJson, "$.l2ToL1Logs");
    AltL2ToL1Log[] memory l2ToL1Logs =
      abi.decode(l2ToL1LogsBytes, (AltL2ToL1Log[]));

    // console.log("l2ToL1Logs");
    // console.log(l2ToL1Logs.length);
    // console.log(l2ToL1Logs[0].logIndex);
    // console.log(l2ToL1Logs[0].txIndexInL1Batch);
    // for (uint256 i = 0; i < l2ToL1Logs.length; i++) {
    //     console.log("L2ToL1Log", i);
    //     console.log("  blockNumber:", l2ToL1Logs[i].blockNumber);
    //     console.log("  blockHash:", vm.toString(l2ToL1Logs[i].blockHash));
    //     // console.log("  isService:", l2ToL1Logs[i].isService);
    //     console.log("  key:", vm.toString(l2ToL1Logs[i].key));
    //     console.log("  logIndex:", l2ToL1Logs[i].logIndex);
    //     console.log("  l1BatchNumber:", l2ToL1Logs[i].l1BatchNumber);
    //     console.log("  sender:", vm.toString(l2ToL1Logs[i].sender));
    //     console.log("  shardId:", l2ToL1Logs[i].shardId);
    //     console.log("  transactionHash:", vm.toString(l2ToL1Logs[i].transactionHash));
    //     console.log("  transactionIndex:", l2ToL1Logs[i].transactionIndex);
    //     console.log("  transactionLogIndex:", l2ToL1Logs[i].transactionLogIndex);
    //     console.log("  txIndexInL1Batch:", l2ToL1Logs[i].txIndexInL1Batch);
    //     console.log("  value:", vm.toString(l2ToL1Logs[i].value));
    // }

    bool status;
    if (result.status == 1) {
      status = true;
    } else {
      status = false;
    }

    Log[] memory logs = new Log[](altLogs.length);
    for (uint256 i = 0; i < altLogs.length; i++) {
      bool removed;
      string memory trueString = "true";
      logs[i] = Log({
        addr: address(uint160(altLogs[i].addr)),
        // addr: address(0),
        blockHash: altLogs[i].blockHash,
        blockNumber: uint64(altLogs[i].blockNumber),
        blockTimestamp: uint64(altLogs[i].blockTimestamp),
        data: altLogsData[i],
        logIndex: uint64(altLogs[i].logIndex),
        // logType: altLogs[i].logType,
        l1BatchNumber: uint64(altLogs[i].l1BatchNumber),
        // removed: compareStrings(altLogs[i].removed, trueString) ? true : false,
        // topics: altLogs[i].topics,
        topics: altLogsTopics[i],
        transactionIndex: uint64(altLogs[i].transactionIndex),
        transactionHash: altLogs[i].transactionHash,
        transactionLogIndex: uint64(altLogs[i].transactionLogIndex)
      });
    }

    L2ToL1Log[] memory realL2ToL1Logs = new L2ToL1Log[](l2ToL1Logs.length);

    for (uint256 i = 0; i < l2ToL1Logs.length; i++) {
      realL2ToL1Logs[i] = L2ToL1Log({
        blockNumber: uint64(l2ToL1Logs[i].blockNumber),
        blockHash: l2ToL1Logs[i].blockHash,
        // isService: l2ToL1Logs[i].isService == 1 ? true : false,
        key: l2ToL1Logs[i].key,
        logIndex: uint64(l2ToL1Logs[i].logIndex),
        l1BatchNumber: uint64(l2ToL1Logs[i].l1BatchNumber),
        sender: l2ToL1Logs[i].sender,
        shardId: uint64(l2ToL1Logs[i].shardId),
        transactionHash: l2ToL1Logs[i].transactionHash,
        transactionIndex: uint64(l2ToL1Logs[i].transactionIndex),
        transactionLogIndex: uint64(l2ToL1Logs[i].transactionLogIndex),
        txIndexInL1Batch: uint64(l2ToL1Logs[i].txIndexInL1Batch),
        value: l2ToL1Logs[i].value
      });
    }

    receipt = TransactionReceipt({
      blockNumber: uint64(result.blockNumber),
      blockHash: result.blockHash,
      // contractAddress: result.contractAddress,
      cumulativeGasUsed: uint64(result.cumulativeGasUsed),
      gasUsed: uint64(result.gasUsed),
      logs: logs,
      l2ToL1Logs: realL2ToL1Logs,
      status: status,
      transactionIndex: uint64(result.transactionIndex),
      transactionHash: result.transactionHash
    });
  }

  // todo import from Utils
  function compareStrings(string memory a, string memory b)
    internal
    pure
    returns (bool)
  {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }

  /// @notice Extract the raw L2ToL1 message data from a transaction receipt.
  /// @dev The L2ToL1Messenger emits an event with topic 0x3a36e47291f4201faf137fab081d92295bce2d53be2c6ca68ba82c7faa9ce241
  ///      The data contains: offset (32 bytes) + length (32 bytes) + message bytes
  /// @param receipt The transaction receipt
  /// @param index The index of the L2ToL1 message (if multiple messages in one tx)
  /// @return messageData The raw message bytes sent to L1
  function getL2ToL1MessageData(
    TransactionReceipt memory receipt,
    uint256 index
  ) internal pure returns (bytes memory messageData) {
    address L1_MESSENGER_ADDRESS = 0x0000000000000000000000000000000000008008;
    bytes32 L1_MESSAGE_SENT_TOPIC =
      0x3a36e47291f4201faf137fab081d92295bce2d53be2c6ca68ba82c7faa9ce241;
    uint256 messageCount = 0;

    for (uint256 i = 0; i < receipt.logs.length; i++) {
      if (
        receipt.logs[i].addr == L1_MESSENGER_ADDRESS
          && receipt.logs[i].topics.length > 0
          && receipt.logs[i].topics[0] == L1_MESSAGE_SENT_TOPIC
      ) {
        if (messageCount == index) {
          // The log data stored by vm.parseJson is ABI-encoded bytes.
          // First decode gets us the raw event data from RPC.
          bytes memory rawEventData = abi.decode(receipt.logs[i].data, (bytes));

          // The raw event data itself contains ABI-encoded bytes (the message).
          // Second decode extracts the actual message.
          messageData = abi.decode(rawEventData, (bytes));
          return messageData;
        }
        messageCount++;
      }
    }
    revert("L2ToL1 message not found at specified index");
  }

  /// @notice Wait until the batch containing the block is executed on the Gateway
  /// @dev This is required because interop roots are only available after Gateway execution
  /// @param sourceRpcUrl RPC URL for the source chain
  /// @param gatewayRpcUrl RPC URL for the Gateway chain
  /// @param sourceChainId Chain ID of the source chain (to look up ZKChain on Gateway)
  /// @param blockNumber Block number on source chain to wait for
  /// @param maxWaitSeconds Maximum seconds to wait
  function waitUntilBlockExecutedOnGateway(
    string memory sourceRpcUrl,
    string memory gatewayRpcUrl,
    uint256 sourceChainId,
    uint256 blockNumber,
    uint256 maxWaitSeconds
  ) internal {
    // First get the L1 batch number for this block from source chain
    uint256 batchNumber = _getL1BatchNumberForBlock(sourceRpcUrl, blockNumber);
    console.log("Block", blockNumber, "is in batch", batchNumber);

    // Get the ZKChain address on Gateway for this source chain
    address zkChainAddr = _getZKChainAddress(gatewayRpcUrl, sourceChainId);
    console.log("ZKChain address on Gateway:", zkChainAddr);

    // Wait until the batch is executed on Gateway
    uint256 waited = 0;
    uint256 interval = 5;

    while (waited < maxWaitSeconds) {
      uint256 executedBatches =
        _getTotalBatchesExecuted(gatewayRpcUrl, zkChainAddr);
      console.log(
        "Executed batches on Gateway:",
        executedBatches,
        "/ waiting for:",
        batchNumber
      );

      if (executedBatches >= batchNumber) {
        console.log("Batch executed on Gateway!");
        return;
      }

      vm.sleep(interval * 1000);
      waited += interval;
    }
    revert("Timeout waiting for batch execution on Gateway");
  }

  /// @dev Get the L1 batch number for a given block using zks_getBlockDetails
  function _getL1BatchNumberForBlock(string memory rpcUrl, uint256 blockNumber)
    internal
    returns (uint256)
  {
    string[] memory args = new string[](10);
    args[0] = "curl";
    args[1] = "-s";
    args[2] = "--request";
    args[3] = "POST";
    args[4] = "--url";
    args[5] = rpcUrl;
    args[6] = "--header";
    args[7] = "Content-Type: application/json";
    args[8] = "--data";
    args[9] = string.concat(
      '{"jsonrpc":"2.0","method":"zks_getBlockDetails","params":[',
      vm.toString(blockNumber),
      '],"id":1}'
    );

    bytes memory result = vm.ffi(args);
    string memory json = string(result);

    bytes memory batchBytes = vm.parseJson(json, "$.result.l1BatchNumber");
    return abi.decode(batchBytes, (uint256));
  }

  /// @dev Get the ZKChain address for a given chain ID from the Gateway's Bridgehub
  function _getZKChainAddress(string memory gatewayRpcUrl, uint256 chainId)
    internal
    returns (address)
  {
    address L2_BRIDGEHUB = 0x0000000000000000000000000000000000010002;

    // Build the calldata: selector(getZKChain) + chainId
    // selector = 0xe680c4c1
    bytes memory callData = abi.encodeWithSelector(0xe680c4c1, chainId);

    string[] memory args = new string[](10);
    args[0] = "curl";
    args[1] = "-s";
    args[2] = "--request";
    args[3] = "POST";
    args[4] = "--url";
    args[5] = gatewayRpcUrl;
    args[6] = "--header";
    args[7] = "Content-Type: application/json";
    args[8] = "--data";
    args[9] = string.concat(
      '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"',
      vm.toString(L2_BRIDGEHUB),
      '","data":"',
      vm.toString(callData),
      '"},"latest"],"id":1}'
    );

    bytes memory result = vm.ffi(args);
    string memory json = string(result);

    // Parse the result from JSON response
    bytes memory resultBytes = vm.parseJson(json, "$.result");
    bytes32 resultData = abi.decode(resultBytes, (bytes32));
    return address(uint160(uint256(resultData)));
  }

  /// @dev Trim trailing newline from bytes
  function _trimNewline(bytes memory input)
    internal
    pure
    returns (string memory)
  {
    uint256 len = input.length;
    while (len > 0 && (input[len - 1] == 0x0a || input[len - 1] == 0x0d)) {
      len--;
    }
    bytes memory trimmed = new bytes(len);
    for (uint256 i = 0; i < len; i++) {
      trimmed[i] = input[i];
    }
    return string(trimmed);
  }

  /// @dev Get total batches executed from ZKChain contract (GettersFacet)
  function _getTotalBatchesExecuted(string memory rpcUrl, address zkChainAddr)
    internal
    returns (uint256)
  {
    // Build the calldata: selector(getTotalBatchesExecuted)
    // selector = 0xb8c2f66f
    bytes memory callData = abi.encodeWithSelector(0xb8c2f66f);

    string[] memory args = new string[](10);
    args[0] = "curl";
    args[1] = "-s";
    args[2] = "--request";
    args[3] = "POST";
    args[4] = "--url";
    args[5] = rpcUrl;
    args[6] = "--header";
    args[7] = "Content-Type: application/json";
    args[8] = "--data";
    args[9] = string.concat(
      '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"',
      vm.toString(zkChainAddr),
      '","data":"',
      vm.toString(callData),
      '"},"latest"],"id":1}'
    );

    bytes memory result = vm.ffi(args);
    string memory json = string(result);

    // Parse the result from JSON response
    bytes memory resultBytes = vm.parseJson(json, "$.result");
    bytes32 resultData = abi.decode(resultBytes, (bytes32));
    return uint256(resultData);
  }

  /// @notice Extract Gateway block number from the proof array
  /// @dev See hashProof in MessageHashing.sol for this logic.
  ///      The proof encodes indices in the first element:
  ///      - proof[0] format: 0x[byte0][byte1][byte2][byte3]...
  ///      - TypeScript: proof[0].slice(4,6) = hex chars 4-6 = byte1, proof[0].slice(6,8) = byte2
  ///      - gwProofIndex = 1 + byte1 + 1 + byte2
  ///      The Gateway block number is at proof[gwProofIndex].slice(2,34) = first 16 bytes as uint128
  /// @param proof The proof array from L2ToL1LogProof
  /// @return gwBlockNumber The Gateway block number
  function getGWBlockNumber(bytes32[] memory proof)
    internal
    pure
    returns (uint256 gwBlockNumber)
  {
    if (proof.length == 0) return 0;

    // Parse the indices from proof[0]
    // proof[0] format: 0x010f0800... where byte1=0x0f (15), byte2=0x08 (8)
    // gwProofIndex = 1 + byte1 + 1 + byte2 = 1 + 15 + 1 + 8 = 25
    bytes32 first = proof[0];
    // Shift by 8 bits to get byte1 in the highest position, then cast to uint8
    uint8 offset1 = uint8(uint256(first) >> 240); // byte1: shift right by 30 bytes (240 bits)
    uint8 offset2 = uint8(uint256(first) >> 232); // byte2: shift right by 29 bytes (232 bits)
    uint256 gwProofIndex = 1 + uint256(offset1) + 1 + uint256(offset2);

    if (gwProofIndex >= proof.length) return 0;

    // The Gateway block number is in the first 16 bytes of proof[gwProofIndex]
    // TypeScript: proof[gwProofIndex].slice(2, 34) = first 16 bytes interpreted as number
    bytes32 gwProofElement = proof[gwProofIndex];
    // Shift right by 128 bits to get the upper 16 bytes as the value
    gwBlockNumber = uint256(gwProofElement) >> 128;
  }

  /// @notice Wait for interop root to become available on destination chain.
  /// @dev For zksync-era mode, uses GATEWAY_CHAIN_ID and Gateway block number.
  ///      For zksync-os mode, uses source chain ID and batch number directly.
  /// @param destRpcUrl The RPC URL for the destination chain
  /// @param chainIdForQuery The chain ID to query (Gateway chain ID for era, source chain for os)
  /// @param batchNumber The batch/block number to check
  /// @param expectedRoot The expected interop root (optional, pass bytes32(0) to skip verification)
  /// @param maxWaitSeconds Maximum seconds to wait (default 300)
  function waitForInteropRoot(
    string memory destRpcUrl,
    uint256 chainIdForQuery,
    uint256 batchNumber,
    bytes32 expectedRoot,
    uint256 maxWaitSeconds
  ) internal returns (bytes32 root) {
    address INTEROP_ROOT_STORAGE = 0x0000000000000000000000000000000000010008;
    uint256 waited = 0;
    uint256 interval = 5;
    string memory privateKey = vm.envString("PRIVATE_KEY");

    console.log(
      "Waiting for interop root for chain",
      chainIdForQuery,
      "block",
      batchNumber
    );

    while (waited < maxWaitSeconds) {
      // Send a dummy self-transfer transaction to force the L2 to update interop root storage
      // This is required because the interop root is lazily updated during transaction processing
      console.log("Sending dummy transaction to trigger interop root update...");
      _sendDummyTransaction(destRpcUrl, privateKey);

      // Query the exact block number
      root = _queryInteropRoot(
        destRpcUrl, INTEROP_ROOT_STORAGE, chainIdForQuery, batchNumber
      );

      if (root != bytes32(0)) {
        if (expectedRoot == bytes32(0) || root == expectedRoot) {
          console.log("Interop root available for block", batchNumber);
          return root;
        }
      }

      // On first iteration, print available roots around the requested block for debugging
      if (waited == 0) {
        console.log("Checking nearby blocks for available interop roots...");
        _printNearbyInteropRoots(
          destRpcUrl, INTEROP_ROOT_STORAGE, chainIdForQuery, batchNumber
        );
      }

      console.log("Waiting for interop root... (", waited, "s)");
      vm.sleep(interval * 1000);
      waited += interval;
    }
    revert("Timeout waiting for interop root");
  }

  /// @dev Query interop root for a specific chain and block
  function _queryInteropRoot(
    string memory rpcUrl,
    address storage_,
    uint256 chainId,
    uint256 blockNum
  ) internal returns (bytes32) {
    string[] memory args = new string[](7);
    args[0] = "cast";
    args[1] = "call";
    args[2] = vm.toString(storage_);
    args[3] = "interopRoots(uint256,uint256)(bytes32)";
    args[4] = vm.toString(chainId);
    args[5] = vm.toString(blockNum);
    args[6] = string.concat("--rpc-url=", rpcUrl);

    bytes memory result = vm.ffi(args);
    return bytes32(result);
  }

  /// @dev Print nearby interop roots for debugging
  function _printNearbyInteropRoots(
    string memory rpcUrl,
    address storage_,
    uint256 chainId,
    uint256 targetBlock
  ) internal {
    // Check blocks around the target block (target-5 to target+10)
    uint256 start = targetBlock > 5 ? targetBlock - 5 : 0;
    uint256 end = targetBlock + 10;

    for (uint256 i = start; i <= end; i++) {
      bytes32 r = _queryInteropRoot(rpcUrl, storage_, chainId, i);
      if (r != bytes32(0)) {
        console.log("  Block", i, "has interop root");
      }
    }
  }

  /// @dev Send a dummy self-transfer to trigger interop root update on the chain
  function _sendDummyTransaction(string memory rpcUrl, string memory privateKey)
    internal
  {
    // Get the sender address from private key
    address sender = vm.addr(vm.parseUint(privateKey));

    // Send 1 wei to self using cast send
    string[] memory args = new string[](8);
    args[0] = "cast";
    args[1] = "send";
    args[2] = "--rpc-url";
    args[3] = rpcUrl;
    args[4] = "--private-key";
    args[5] = privateKey;
    args[6] = vm.toString(sender);
    args[7] = "--value=1wei";

    vm.ffi(args);
  }

  function parseL2ToL1LogProof(bytes memory jsonResponse)
    internal
    returns (L2ToL1LogProof memory proof)
  {
    string memory json = string(jsonResponse);

    bytes memory proofIdBytes = vm.parseJson(json, "$.result.id");
    proof.id = abi.decode(proofIdBytes, (uint64));

    // Parse batchNumber from the proof json (camelCase in JSON response)
    bytes memory batchNumberBytes = vm.parseJson(json, "$.result.batchNumber");
    proof.batchNumber = abi.decode(batchNumberBytes, (uint256));

    string memory proofJson = callParseAltLog(json, "parse-proof.sh");
    bytes memory lengthBytes = vm.parseJson(proofJson, "$.length");
    uint256 length = abi.decode(lengthBytes, (uint256));
    proof.proof = new bytes32[](length);
    for (uint256 i = 0; i < length; i++) {
      bytes memory proofBytes =
        vm.parseJson(proofJson, string.concat("$.proof[", vm.toString(i), "]"));
      proof.proof[i] = bytes32(proofBytes);
    }
  }

  /// @dev Maps bash script names to yarn script names
  /// @param scriptName The original bash script name (e.g., "parse-alt-logs.sh")
  /// @return yarnScript The yarn script name (e.g., "interop:parse:logs")
  function getYarnScriptName(string memory scriptName)
    internal
    pure
    returns (string memory yarnScript)
  {
    bytes32 nameHash = keccak256(bytes(scriptName));

    if (nameHash == keccak256("parse-alt-logs.sh")) {
      return "interop:parse:logs";
    } else if (nameHash == keccak256("parse-alt-l2-to-l1-logs.sh")) {
      return "interop:parse:l2-to-l1-logs";
    } else if (nameHash == keccak256("parse-alt-logs-data.sh")) {
      return "interop:parse:logs-data";
    } else if (nameHash == keccak256("parse-alt-logs-topics.sh")) {
      return "interop:parse:logs-topics";
    } else if (nameHash == keccak256("parse-alt-transaction-receipt.sh")) {
      return "interop:parse:receipt";
    } else if (nameHash == keccak256("parse-transaction-receipt.sh")) {
      return "interop:parse:receipt-simple";
    } else if (nameHash == keccak256("parse-proof.sh")) {
      return "interop:parse:proof";
    } else if (nameHash == keccak256("parse-broadcast.sh")) {
      return "interop:parse:broadcast";
    }
    revert(string.concat("Unknown script: ", scriptName));
  }

  function callParseAltLog(string memory jsonStr, string memory scriptName)
    internal
    returns (string memory modifiedJson)
  {
    string memory yarnScript = getYarnScriptName(scriptName);
    string[] memory args = new string[](4);
    args[0] = "yarn";
    args[1] = "--silent";
    args[2] = yarnScript;
    args[3] = jsonStr;

    bytes memory modifiedJsonBytes = vm.ffi(args);
    modifiedJson = string(modifiedJsonBytes);
  }

  function callParseAltLog(
    string memory jsonStr,
    string memory scriptName,
    uint256 index
  ) internal returns (string memory modifiedJson) {
    string memory yarnScript = getYarnScriptName(scriptName);
    string[] memory args = new string[](5);
    args[0] = "yarn";
    args[1] = "--silent";
    args[2] = yarnScript;
    args[3] = jsonStr;
    args[4] = vm.toString(index);

    bytes memory modifiedJsonBytes = vm.ffi(args);
    modifiedJson = string(modifiedJsonBytes);
  }
}
