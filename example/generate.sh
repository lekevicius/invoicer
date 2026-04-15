#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SELLER_PATH="$SCRIPT_DIR/seller/seller.json"
INVOICE_DIR="$SCRIPT_DIR/invoices"
PDF_DIR="$SCRIPT_DIR/pdfs"

mkdir -p "$PDF_DIR"

if [[ -f "$PACKAGE_DIR/package.json" ]]; then
  INVOICER=(bun run --cwd "$PACKAGE_DIR" generate --)
else
  INVOICER=(invoicer)
fi

invoice_path_for() {
  local input="$1"

  if [[ -f "$input" ]]; then
    printf '%s\n' "$(cd -- "$(dirname -- "$input")" && pwd)/$(basename -- "$input")"
    return
  fi

  if [[ "$input" == *.json ]]; then
    printf '%s\n' "$INVOICE_DIR/$input"
  else
    printf '%s\n' "$INVOICE_DIR/$input.json"
  fi
}

generate_one() {
  local invoice_path="$1"
  local invoice_name
  invoice_name="$(basename -- "$invoice_path" .json)"

  "${INVOICER[@]}" "$invoice_path" \
    --seller "$SELLER_PATH" \
    --out "$PDF_DIR/$invoice_name.pdf"
}

if [[ "$#" -eq 0 || "${1:-}" == "all" ]]; then
  shopt -s nullglob
  invoice_paths=("$INVOICE_DIR"/*.json)
  if [[ "${#invoice_paths[@]}" -eq 0 ]]; then
    echo "No invoice JSON files found in $INVOICE_DIR" >&2
    exit 1
  fi

  for invoice_path in "${invoice_paths[@]}"; do
    generate_one "$invoice_path"
  done
else
  for invoice_arg in "$@"; do
    invoice_path="$(invoice_path_for "$invoice_arg")"
    if [[ ! -f "$invoice_path" ]]; then
      echo "Invoice not found: $invoice_path" >&2
      exit 1
    fi
    generate_one "$invoice_path"
  done
fi
