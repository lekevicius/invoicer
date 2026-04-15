---
name: invoicing
description: Create, edit, validate, and regenerate invoice PDFs with the Invoicer JSON-to-PDF tool. Use when the user asks to draft invoice JSON, determine the next invoice number, configure seller data, or generate invoice PDFs from invoice and seller JSON files.
---

# Invoicing

Use this skill to create invoice JSON files and generate PDFs with an Invoicer project.

Read `references/paths-and-rules.md` when you need the expected file layout, invoice JSON shape, seller configuration shape, or numbering rules.

## Workflow

1. Locate the Invoicer project root. It should contain `package.json`, `schemas/`, `typst/`, and `src/`.
2. Locate the seller file, invoice directory, and PDF output directory. Ask only if they cannot be inferred from the repo, README, scripts, or user request.
3. Collect missing invoice inputs:
   - buyer legal name, company or tax ID, and billing address
   - invoice currency
   - project name
   - line items with titles and amounts
4. Choose `meta.locale`: use `lt-LT` for Lithuanian invoices and `en-US` otherwise.
5. Create a compact draft JSON when helpful, then run `scripts/build_invoice.py` to fill invoice number, dates, and capitalization.
6. Generate the PDF with the project CLI or example script.
7. Verify the command succeeded and return the generated PDF path.

## Compact Draft

Use this draft shape with `scripts/build_invoice.py`:

```json
{
  "meta": {
    "locale": "en-US"
  },
  "invoice": {
    "currency": "USD",
    "project": "Project name"
  },
  "buyer": {
    "name": "Client name",
    "company_code": "123456789",
    "address": ["Street 1", "City"]
  },
  "items": [
    {
      "title": "Service title",
      "amount": 1000
    }
  ]
}
```

## Commands

Build a complete invoice JSON from a compact draft:

```bash
python3 skill/scripts/build_invoice.py /tmp/invoice-draft.json invoices/INV2601.json \
  --invoice-dir invoices \
  --invoice-prefix INV
```

Generate a PDF with the package CLI:

```bash
bun run generate -- invoices/INV2601.json --seller seller/seller.json --out pdfs/INV2601.pdf
```

Generate the bundled example:

```bash
./example/generate.sh all
```

## Notes

- The total is derived from `items`; do not add a manual total field.
- The schema supports `lt-LT` and `en-US`.
- Use reliable registry or buyer-provided details for legal company data. If details are ambiguous, ask instead of guessing.
- Keep seller identity rows, bank detail rows, assets, and theme in `seller.json`.
- Use relative asset and font paths in `seller.json` when possible; they resolve relative to the seller file.
