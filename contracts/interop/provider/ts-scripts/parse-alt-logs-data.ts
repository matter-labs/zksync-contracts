#!/usr/bin/env ts-node
/**
 * Parse and extract log data at specific index from RPC response
 *
 * Usage: ts-node parse-alt-logs-data.ts '<json_string>' <index>
 */

import { walkAndTransform, padHexStrings } from './utils';

interface Log {
  data?: string;
}

interface RpcResponse {
  result: {
    logs: Log[];
  };
}

const ZERO_HASH = '0x0000000000000000000000000000000000000000000000000000000000000000';

function parseAltLogsData(jsonString: string, index: number): { data: string } {
  const parsed: RpcResponse = JSON.parse(jsonString);

  // Extract data from logs array at index
  const logData = parsed.result.logs.map(log => log.data);
  let data = logData[index] ?? ZERO_HASH;

  // Handle empty hex string
  if (data === '0x') {
    data = ZERO_HASH;
  }

  // Pad hex strings
  const result = walkAndTransform({ data }, padHexStrings);

  return result;
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length < 2) {
    console.error('Usage: ts-node parse-alt-logs-data.ts <json_string> <index>');
    console.error('Example: ts-node parse-alt-logs-data.ts \'{"result": {"logs": [{"data": "0x123"}]}}\' 0');
    process.exit(1);
  }

  try {
    const index = parseInt(args[1], 10);
    const result = parseAltLogsData(args[0], index);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error('Error parsing JSON:', error);
    process.exit(1);
  }
}

export { parseAltLogsData };
