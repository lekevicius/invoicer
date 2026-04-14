import { $ } from "bun";

import { TYPST_MAIN_PATH, TYPST_ROOT } from "./constants";

export async function compileInvoicePdf(jsonPath: string, outPath: string): Promise<void> {
  await $`typst compile --root ${TYPST_ROOT} --input data=${jsonPath} ${TYPST_MAIN_PATH} ${outPath}`;
}
