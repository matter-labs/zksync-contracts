#!/usr/bin/env ts-node
/**
 * Parse and transform broadcast file
 *
 * Usage: ts-node parse-broadcast.ts <broadcast_file_path>
 */

import * as fs from 'fs';

interface ZksyncTransaction {
  paymasterData?: unknown;
  [key: string]: unknown;
}

interface Transaction {
  function?: string;
  functionKey?: string;
  contractName?: string;
  transaction?: {
    zksync?: ZksyncTransaction;
    [key: string]: unknown;
  };
  [key: string]: unknown;
}

interface BroadcastFile {
  transactions?: Transaction[];
  returns?: unknown;
  returnValues?: unknown;
  [key: string]: unknown;
}

function parseBroadcast(filePath: string): void {
  // Check if file exists
  if (!fs.existsSync(filePath)) {
    console.error(`Error: File '${filePath}' not found`);
    process.exit(1);
  }

  // Read and parse file
  const content = fs.readFileSync(filePath, 'utf-8');
  const data: BroadcastFile = JSON.parse(content);

  // Transform transactions
  if (data.transactions) {
    data.transactions = data.transactions.map(tx => {
      // Rename "function" to "functionKey"
      if ('function' in tx) {
        tx.functionKey = tx.function;
        delete tx.function;
      }

      // Remove paymasterData from zksync
      if (tx.transaction?.zksync?.paymasterData !== undefined) {
        delete tx.transaction.zksync.paymasterData;
      }

      // Remove contractName
      delete tx.contractName;

      return tx;
    });
  }

  // Rename "returns" to "returnValues" at root level
  if ('returns' in data) {
    data.returnValues = data.returns;
    delete data.returns;
  }

  // Generate output filename
  const outputFile = filePath.replace(/\.json$/, '.parsed.json');

  // Write output
  fs.writeFileSync(outputFile, JSON.stringify(data, null, 2));

  console.log(`Successfully created ${outputFile}`);
  console.log('Changes made:');
  console.log("  - 'function' -> 'functionKey' in transactions");
  console.log("  - 'returns' -> 'returnValues' at root level");
  console.log("  - Removed 'paymasterData' from transactions.transaction.zksync");
  console.log("  - Removed 'contractName' from transactions");
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.error('Usage: ts-node parse-broadcast.ts <broadcast_file_path>');
    process.exit(1);
  }

  try {
    parseBroadcast(args[0]);
  } catch (error) {
    console.error('Error processing file:', error);
    process.exit(1);
  }
}

export { parseBroadcast };
