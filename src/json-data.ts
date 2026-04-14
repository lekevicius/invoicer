import Ajv, { type AnySchema, type ErrorObject } from "ajv";

import { resolvePath } from "./paths";

const ajv = new Ajv({ allErrors: true, strict: false });

async function readJsonFile(path: string): Promise<unknown> {
  try {
    return await Bun.file(path).json();
  } catch (error) {
    throw new Error(`Could not read JSON file: ${path}`, { cause: error });
  }
}

function formatValidationErrors(errors: ErrorObject[] | null | undefined): string {
  if (!errors?.length) return "Unknown validation error.";

  return errors
    .map((error) => {
      const path = error.instancePath || "/";
      return `- ${path} ${error.message ?? "is invalid"}`;
    })
    .join("\n");
}

export async function readValidatedJson<T>(path: string, schemaPath: string): Promise<T> {
  const [data, schema] = await Promise.all([readJsonFile(resolvePath(path)), readJsonFile(schemaPath)]);
  const validate = ajv.compile(schema as AnySchema);

  if (!validate(data)) {
    throw new Error(`${path} does not match ${schemaPath}:\n${formatValidationErrors(validate.errors)}`);
  }

  return data as T;
}
