#!/usr/bin/env ts-node
/**
 * Simple transformation of transaction receipt - just rename "address" to "addr"
 *
 * Usage: ts-node parse-transaction-receipt.ts '<json_string>'
 */

function parseTransactionReceipt(jsonString: string): string {
  // Simple string replacement: "address": -> "addr":
  return jsonString.replace(/"address":/g, '"addr":');
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error('Usage: ts-node parse-transaction-receipt.ts <json_string>');
    console.error('Example: ts-node parse-transaction-receipt.ts \'{"address": "0x123"}\'');
    process.exit(1);
  }

  try {
    const result = parseTransactionReceipt(args[0]);
    console.log(result);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

export { parseTransactionReceipt };
