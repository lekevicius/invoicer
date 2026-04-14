import { basename, join } from "node:path";
import { tmpdir } from "node:os";
import { mkdtemp, rm } from "node:fs/promises";

import {
  DEFAULT_OUTPUT_DIR,
  INVOICE_SCHEMA_PATH,
  SELLER_SCHEMA_PATH,
} from "./constants";
import { getLocale } from "./locales";
import { readValidatedJson } from "./json-data";
import { buildRenderData } from "./render-data";
import { compileInvoicePdf } from "./typst";
import { ensureParentDir } from "./paths";
import { resolvePath } from "./paths";
import type { GenerateOptions, GenerateResult, InvoiceInput, SellerInput } from "./types";

export async function generateInvoice(options: GenerateOptions): Promise<GenerateResult> {
  const sellerPath = resolvePath(options.sellerPath);
  const invoicePath = resolvePath(options.invoicePath);
  const sellerInput = await readValidatedJson<SellerInput>(sellerPath, SELLER_SCHEMA_PATH);
  const invoiceInput = await readValidatedJson<InvoiceInput>(invoicePath, INVOICE_SCHEMA_PATH);
  const locale = getLocale(invoiceInput.meta.locale);
  const renderData = buildRenderData(sellerInput, invoiceInput, locale.labels);

  const invoiceNumber = renderData.header.invoice_number;
  const outPath = resolvePath(options.outPath ?? join(DEFAULT_OUTPUT_DIR, `${invoiceNumber}.pdf`));
  const tempDir = options.jsonPath ? null : await mkdtemp(join(tmpdir(), "invoicer-"));
  const jsonPath = resolvePath(options.jsonPath ?? join(tempDir ?? DEFAULT_OUTPUT_DIR, `${invoiceNumber}.render.json`));

  try {
    await ensureParentDir(jsonPath);
    await Bun.write(jsonPath, `${JSON.stringify(renderData, null, 2)}\n`);

    if (!options.renderOnly) {
      await ensureParentDir(outPath);
      await compileInvoicePdf(jsonPath, outPath);
    }
  } finally {
    if (tempDir) {
      await rm(tempDir, { recursive: true, force: true });
    }
  }

  return {
    invoicePath: basename(invoicePath),
    sellerPath: basename(sellerPath),
    jsonPath: options.jsonPath ? jsonPath : null,
    outPath: options.renderOnly ? null : outPath,
    invoiceNumber,
  };
}
