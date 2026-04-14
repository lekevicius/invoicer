import { dirname, isAbsolute, resolve } from "node:path";
import { mkdir } from "node:fs/promises";

export function resolvePath(path: string): string {
  return isAbsolute(path) ? path : resolve(process.cwd(), path);
}

export function toTypstRootPath(path: string | null | undefined): string | null {
  if (!path) return null;
  return resolvePath(path);
}

export async function ensureParentDir(path: string): Promise<void> {
  const parent = dirname(resolvePath(path));
  if (parent === ".") return;

  await mkdir(parent, { recursive: true });
}
