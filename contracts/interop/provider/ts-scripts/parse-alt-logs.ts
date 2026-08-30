#!/usr/bin/env ts-node
/**
 * Parse and transform logs from RPC response
 *
 * Usage: ts-node parse-alt-logs.ts '<json_string>'
 */

import { walkAndTransform, padHexStrings, sortObjectKeys } from './utils';

interface Log {
  address?: string;
  addr?: string;
  blockHash?: string;
  blockNumber?: string;
  blockTimestamp?: string;
  l1BatchNumber?: string;
  logIndex?: string;
  logType?: string;
  removed?: boolean;
  topics?: string[];
  data?: string;
  transactionHash?: string;
  transactionIndex?: string;
  transactionLogIndex?: string;
  type?: string;
  txType?: string;
}

interface RpcResponse {
  result: {
    l1BatchNumber?: string;
    blockNumber?: string;
    logs: Log[];
  };
}

function parseAltLogs(jsonString: string): { logs: Log[] } {
  const parsed: RpcResponse = JSON.parse(jsonString);

  // If l1BatchNumber is null, use blockNumber
  if (parsed.result.l1BatchNumber == null) {
    parsed.result.l1BatchNumber = parsed.result.blockNumber;
  }

  // Transform logs
  const logs = parsed.result.logs.map(log => {
    // Remove unwanted fields
    const { logType: _logType, removed: _removed, topics: _topics, data: _data, ...rest } = log;

    // Ensure transactionLogIndex exists
    const transformed: Record<string, unknown> = { ...rest };
    if (!('transactionLogIndex' in transformed)) {
      transformed.transactionLogIndex = '0x0000000000000000000000000000000000000000000000000000000000000000';
    }

    // Ensure l1BatchNumber exists
    if (!('l1BatchNumber' in transformed)) {
      transformed.l1BatchNumber = transformed.blockNumber;
    }

    // Rename address to addr
    if ('address' in transformed) {
      transformed.addr = transformed.address;
      delete transformed.address;
    }

    // Rename type to txType
    if ('type' in transformed) {
      transformed.txType = transformed.type;
      delete transformed.type;
    }

    // Sort keys and return
    return sortObjectKeys(transformed as Record<string, unknown>);
  });

  // Pad all hex strings and wrap in logs object
  const result = walkAndTransform({ logs }, padHexStrings);

  return result;
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error('Usage: ts-node parse-alt-logs.ts <json_string>');
    console.error('Example: ts-node parse-alt-logs.ts \'{"result": {"logs": []}}\'');
    process.exit(1);
  }

  try {
    const result = parseAltLogs(args[0]);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error('Error parsing JSON:', error);
    process.exit(1);
  }
}

export { parseAltLogs };
