import { TYPST_MAIN_PATH, TYPST_ROOT } from "./constants";

export async function compileInvoicePdf(jsonPath: string, outPath: string, fontPaths: string[] = []): Promise<void> {
  const args = [
    "compile",
    "--root",
    TYPST_ROOT,
    ...fontPaths.flatMap((path) => ["--font-path", path]),
    "--input",
    `data=${jsonPath}`,
    TYPST_MAIN_PATH,
    outPath,
  ];
  const proc = Bun.spawn(["typst", ...args], {
    stdout: "pipe",
    stderr: "pipe",
  });
  const [exitCode, stdout, stderr] = await Promise.all([
    proc.exited,
    new Response(proc.stdout).text(),
    new Response(proc.stderr).text(),
  ]);

  if (exitCode !== 0) {
    const output = [stdout.trim(), stderr.trim()].filter(Boolean).join("\n");
    throw new Error(output || `typst exited with code ${exitCode}`);
  }
}
