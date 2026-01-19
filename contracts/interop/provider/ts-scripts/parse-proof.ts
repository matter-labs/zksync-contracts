#!/usr/bin/env ts-node
/**
 * Parse and extract proof array from RPC response
 * Replaces: parse-proof.sh
 *
 * Usage: ts-node parse-proof.ts '<json_string>'
 */

import { walkAndTransform, padHexStrings } from './utils';

interface RpcResponse {
  result: {
    proof: string[];
  };
}

function parseProof(jsonString: string): { proof: string[]; length: number } {
  const parsed: RpcResponse = JSON.parse(jsonString);

  const proof = parsed.result.proof ?? [];

  // Pad hex strings
  const paddedProof = walkAndTransform(proof, padHexStrings);

  return {
    proof: paddedProof,
    length: paddedProof.length,
  };
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error('Usage: ts-node parse-proof.ts <json_string>');
    console.error('Example: ts-node parse-proof.ts \'{"result": {"proof": ["0x123"]}}\'');
    process.exit(1);
  }

  try {
    const result = parseProof(args[0]);
    console.log(JSON.stringify(result));
  } catch (error) {
    console.error('Error parsing JSON:', error);
    process.exit(1);
  }
}

export { parseProof };
