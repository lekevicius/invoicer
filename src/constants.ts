import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

export const PROGRAM_NAME = "invoicer";
export const PROGRAM_VERSION = "0.1.0";

export const DEFAULT_INVOICE_PATH = "JL2301.json";
export const DEFAULT_SELLER_PATH = "seller.json";
export const DEFAULT_OUTPUT_DIR = "pdfs";

export const PACKAGE_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");

export const INVOICE_SCHEMA_PATH = join(PACKAGE_ROOT, "schemas", "invoice.schema.json");
export const SELLER_SCHEMA_PATH = join(PACKAGE_ROOT, "schemas", "seller.schema.json");

export const TYPST_ROOT = "/";
export const TYPST_MAIN_PATH = join(PACKAGE_ROOT, "typst", "main.typ");

export const RENDER_SCHEMA_VERSION = 1;
