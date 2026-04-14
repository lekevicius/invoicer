import { parseArgs } from "node:util";

import {
  DEFAULT_INVOICE_PATH,
  DEFAULT_SELLER_PATH,
  PROGRAM_NAME,
  PROGRAM_VERSION,
} from "./constants";
import type { GenerateOptions } from "./types";

export type CliCommand =
  | { kind: "generate"; options: GenerateOptions }
  | { kind: "help" }
  | { kind: "version" };

export const USAGE = `${PROGRAM_NAME} ${PROGRAM_VERSION}

Usage:
  bun run generate -- [invoice.json] [options]

Arguments:
  invoice.json           Invoice data file. Defaults to ${DEFAULT_INVOICE_PATH}.

Options:
  --seller <path>        Seller data file. Defaults to ${DEFAULT_SELLER_PATH}.
  --out <path>           PDF output path. Defaults to pdfs/<invoice-number>.pdf.
  --json <path>          Also write render JSON to this path for debugging.
  --render-only          Write render JSON but skip Typst PDF compilation.
  --quiet                Only print errors.
  -h, --help             Show this help text.
  -v, --version          Show the CLI version.
`;

export type ParsedCli = CliCommand & {
  quiet: boolean;
};

export function parseCliArgs(args: string[]): ParsedCli {
  const { positionals, values } = parseArgs({
    args,
    allowPositionals: true,
    options: {
      help: { type: "boolean", short: "h" },
      version: { type: "boolean", short: "v" },
      seller: { type: "string", default: DEFAULT_SELLER_PATH },
      out: { type: "string" },
      json: { type: "string" },
      "render-only": { type: "boolean", default: false },
      quiet: { type: "boolean", default: false },
    },
  });

  const quiet = Boolean(values.quiet);

  if (values.help) {
    return { kind: "help", quiet };
  }

  if (values.version) {
    return { kind: "version", quiet };
  }

  if (positionals.length > 1) {
    throw new Error(`Expected one invoice JSON path, received ${positionals.length}: ${positionals.join(", ")}`);
  }

  return {
    kind: "generate",
    quiet,
    options: {
      invoicePath: positionals[0] ?? DEFAULT_INVOICE_PATH,
      sellerPath: values.seller ?? DEFAULT_SELLER_PATH,
      outPath: values.out,
      jsonPath: values.json,
      renderOnly: Boolean(values["render-only"]),
    },
  };
}

export function formatError(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
