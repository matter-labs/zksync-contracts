#!/usr/bin/env ts-node
/**
 * Parse and extract log topics at specific index from RPC response
 * Replaces: parse-alt-logs-topics.sh
 *
 * Usage: ts-node parse-alt-logs-topics.ts '<json_string>' <index>
 */

import { walkAndTransform, padHexStrings } from "./utils";

interface Log {
  topics?: string[];
}

interface RpcResponse {
  result: {
    logs: Log[];
  };
}

function parseAltLogsTopics(jsonString: string, index: number): { topics: string[] } {
  const parsed: RpcResponse = JSON.parse(jsonString);

  // Extract topics from logs array at index
  const logTopics = parsed.result.logs.map((log) => log.topics);
  const topics = logTopics[index] ?? [];

  // Pad hex strings
  const result = walkAndTransform({ topics }, padHexStrings);

  return result;
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length < 2) {
    console.error("Usage: ts-node parse-alt-logs-topics.ts <json_string> <index>");
    console.error('Example: ts-node parse-alt-logs-topics.ts \'{"result": {"logs": [{"topics": ["0x123"]}]}}\' 0');
    process.exit(1);
  }

  try {
    const index = parseInt(args[1], 10);
    const result = parseAltLogsTopics(args[0], index);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error("Error parsing JSON:", error);
    process.exit(1);
  }
}

export { parseAltLogsTopics };
