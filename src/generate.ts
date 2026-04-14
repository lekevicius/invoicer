#!/usr/bin/env bun

import { parseCliArgs, formatError, USAGE } from "./cli";
import { PROGRAM_NAME, PROGRAM_VERSION } from "./constants";
import { generateInvoice } from "./generator";

async function main(): Promise<void> {
  const command = parseCliArgs(Bun.argv.slice(2));

  if (command.kind === "help") {
    console.log(USAGE);
    return;
  }

  if (command.kind === "version") {
    console.log(`${PROGRAM_NAME} ${PROGRAM_VERSION}`);
    return;
  }

  const result = await generateInvoice(command.options);

  if (command.quiet) return;

  if (result.outPath) {
    console.log(`Generated ${result.outPath} from ${result.invoicePath} and ${result.sellerPath}.`);
  } else {
    console.log(`Generated render data for ${result.invoiceNumber} from ${result.invoicePath} and ${result.sellerPath}.`);
  }

  if (result.jsonPath) {
    console.log(`Render data: ${result.jsonPath}`);
  }
}

try {
  await main();
} catch (error) {
  console.error(`error: ${formatError(error)}`);
  process.exitCode = 1;
}
