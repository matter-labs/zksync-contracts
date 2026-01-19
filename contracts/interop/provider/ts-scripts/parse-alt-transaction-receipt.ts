#!/usr/bin/env ts-node
/**
 * Parse and transform transaction receipt from RPC response
 * Removes logs fields and transforms field names
 * Replaces: parse-alt-transaction-receipt.sh
 *
 * Usage: ts-node parse-alt-transaction-receipt.ts '<json_string>'
 */

import { walkAndTransform, padHexStrings, sortObjectKeys } from './utils';

interface TransactionReceipt {
  blockHash?: string;
  blockNumber?: string;
  contractAddress?: string | null;
  cumulativeGasUsed?: string;
  effectiveGasPrice?: string;
  from?: string;
  gasUsed?: string;
  logs?: unknown[];
  l2ToL1Logs?: unknown[];
  logsBloom?: string;
  l1BatchNumber?: string | number | null;
  l1BatchTxIndex?: string | number | null;
  status?: string;
  to?: string;
  transactionHash?: string;
  transactionIndex?: string;
  type?: string;
  txType?: string;
}

interface RpcResponse {
  result: TransactionReceipt;
}

function parseAltTransactionReceipt(jsonString: string): RpcResponse {
  const parsed: RpcResponse = JSON.parse(jsonString);

  // Remove unwanted fields
  const { logs, l2ToL1Logs, logsBloom, contractAddress, ...rest } = parsed.result;

  // Ensure l1BatchNumber and l1BatchTxIndex have default values
  const transformed: Record<string, unknown> = { ...rest };
  if (transformed.l1BatchNumber == null) {
    transformed.l1BatchNumber = 0;
  }
  if (transformed.l1BatchTxIndex == null) {
    transformed.l1BatchTxIndex = 0;
  }

  // Rename address to addr (if present)
  if ('address' in transformed) {
    transformed.addr = transformed.address;
    delete transformed.address;
  }

  // Rename type to txType
  if ('type' in transformed) {
    transformed.txType = transformed.type;
    delete transformed.type;
  }

  // Sort keys
  const sortedResult = sortObjectKeys(transformed as Record<string, unknown>);

  // Pad all hex strings
  const result = walkAndTransform({ result: sortedResult }, padHexStrings);

  return result as RpcResponse;
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error('Usage: ts-node parse-alt-transaction-receipt.ts <json_string>');
    console.error('Example: ts-node parse-alt-transaction-receipt.ts \'{"result": {...}}\'');
    process.exit(1);
  }

  try {
    const result = parseAltTransactionReceipt(args[0]);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error('Error parsing JSON:', error);
    process.exit(1);
  }
}

export { parseAltTransactionReceipt };
