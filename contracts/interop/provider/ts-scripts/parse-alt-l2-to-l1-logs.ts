#!/usr/bin/env ts-node
/**
 * Parse and transform L2 to L1 logs from RPC response
 * Replaces: parse-alt-l2-to-l1-logs.sh
 *
 * Usage: ts-node parse-alt-l2-to-l1-logs.ts '<json_string>'
 */

import { walkAndTransform, padHexStrings, sortObjectKeys } from "./utils";

interface L2ToL1Log {
  address?: string;
  addr?: string;
  blockHash?: string;
  blockNumber?: string;
  key?: string;
  l1BatchNumber?: string | number;
  logIndex?: string;
  logType?: string;
  removed?: boolean;
  topics?: string[];
  data?: string;
  isService?: boolean;
  is_service?: boolean;
  l2_shard_id?: string;
  sender?: string;
  shardId?: string;
  transactionHash?: string;
  transactionIndex?: string;
  transactionLogIndex?: string;
  txIndexInL1Batch?: string;
  value?: string;
  type?: string;
  txType?: string;
}

interface RpcResponse {
  result: {
    l2ToL1Logs: L2ToL1Log[];
  };
}

const ZERO_HASH = "0x0000000000000000000000000000000000000000000000000000000000000000";

function parseAltL2ToL1Logs(jsonString: string): { l2ToL1Logs: L2ToL1Log[] } {
  const parsed: RpcResponse = JSON.parse(jsonString);

  // Transform logs
  const l2ToL1Logs = parsed.result.l2ToL1Logs.map((log) => {
    // Remove unwanted fields
    const { logType, removed, topics, data, isService, is_service, l2_shard_id, ...rest } = log;

    const transformed: Record<string, unknown> = { ...rest };

    // Ensure l1BatchNumber is padded if it's 0 or missing
    if (
      !("l1BatchNumber" in transformed) ||
      transformed.l1BatchNumber === 0 ||
      transformed.l1BatchNumber === "0x0" ||
      transformed.l1BatchNumber === "0"
    ) {
      transformed.l1BatchNumber = ZERO_HASH;
    }

    // Ensure required fields exist with zero values
    const fieldsToEnsure = [
      "transactionLogIndex",
      "transactionIndex",
      "transactionHash",
      "shardId",
      "logIndex",
      "blockNumber",
      "blockHash",
    ];

    for (const field of fieldsToEnsure) {
      if (!(field in transformed)) {
        transformed[field] = ZERO_HASH;
      }
    }

    // Rename address to addr
    if ("address" in transformed) {
      transformed.addr = transformed.address;
      delete transformed.address;
    }

    // Rename type to txType
    if ("type" in transformed) {
      transformed.txType = transformed.type;
      delete transformed.type;
    }

    // Sort keys and return
    return sortObjectKeys(transformed as Record<string, unknown>);
  });

  // Pad all hex strings and wrap in l2ToL1Logs object
  const result = walkAndTransform({ l2ToL1Logs }, padHexStrings);

  return result;
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error("Usage: ts-node parse-alt-l2-to-l1-logs.ts <json_string>");
    console.error('Example: ts-node parse-alt-l2-to-l1-logs.ts \'{"result": {"l2ToL1Logs": []}}\'');
    process.exit(1);
  }

  try {
    const result = parseAltL2ToL1Logs(args[0]);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error("Error parsing JSON:", error);
    process.exit(1);
  }
}

export { parseAltL2ToL1Logs };
