# Invoicer Paths and Rules

## Expected Project Layout

- Project root: directory containing `package.json`, `schemas/`, `src/`, and `typst/`.
- Seller file: commonly `seller/seller.json` or `example/seller/seller.json`.
- Invoice JSONs: commonly `invoices/*.json` or `example/invoices/*.json`.
- Generated PDFs: commonly `pdfs/*.pdf` or `example/pdfs/*.pdf`.
- Package CLI: `bun run generate -- <invoice.json> --seller <seller.json> --out <output.pdf>`.
- Example generator: `./example/generate.sh all` or `./example/generate.sh <invoice-number>`.

## Invoice Numbering

Default helper format: `<prefix><YY><XX>`.

- `prefix` is supplied with `--invoice-prefix` and defaults to `INV`.
- `YY` is the issue date year suffix.
- `XX` is the next 2-digit sequence for that prefix and year.
- Determine the next sequence from existing invoice JSON files in the invoice directory.
- If a user has an established numbering convention, preserve it.

## Dates

- Issue date is the requested invoice date, or today's date if the user asks for a current invoice.
- Due date defaults to issue date plus 14 days unless the user or seller convention says otherwise.
- Use `--issue-date`, `--due-date`, or `--payment-terms-days` with `scripts/build_invoice.py` when defaults do not apply.

## Locale

- Use `lt-LT` for Lithuanian invoices.
- Use `en-US` for other invoices unless the user requests a supported locale.
- The current schema supports only `lt-LT` and `en-US`.

## Buyer Details

- Prefer legal company name, company or tax ID, and billing address from the user or an official registry.
- If reliable data is unavailable or ambiguous, ask for the missing fields.
- Do not invent company codes, tax IDs, or billing addresses.

## Seller Config

Seller left-column details, bank detail rows, assets, signature placement, colors, and fonts live in `seller.json`.

Asset and font paths should usually be relative to the seller file:

```json
{
  "seller": {
    "details": [
      {
        "label": "Seller",
        "lines": ["Vertex Labs"],
        "first_weight": "semibold"
      },
      {
        "label": "Company code",
        "lines": ["305998412"]
      },
      {
        "label": "VAT number",
        "lines": ["LT100015842617"]
      }
    ],
    "bank_details": [
      { "label": "Recipient", "value": "Vertex Labs" },
      { "label": "Bank", "value": "SEB Bankas" },
      { "label": "SWIFT/BIC", "value": "CBVILT2X" },
      { "label": "Account no.", "value": "LT12 7044 0600 1234 5678" },
      { "label": "Memo", "value": "Invoice {invoice_number}" },
      { "label": "Due date", "value": "{due_date}" }
    ],
    "assets": {
      "background": "assets/artwork.png",
      "logotype": "assets/logotype.svg",
      "signature": {
        "svg": "assets/signature.svg",
        "x": 54,
        "y": 720,
        "width": 200
      }
    },
    "theme": {
      "colors": {
        "background": "#FFFFFF",
        "heading": "#8195A5",
        "text": "#353A3F",
        "border": "#D9E0E7"
      },
      "font": {
        "family": "Inter",
        "paths": ["assets/fonts"]
      }
    }
  }
}
```

The default layout renders the logo at `152x27`. Set `assets.signature.width` when the signature must be pinned to a specific size; the bundled example uses `width: 200` at `x: 54`, `y: 720`.

`details` controls the seller column exactly as written. `bank_details.value` supports `{invoice_number}`, `{issue_date}`, `{due_date}`, `{currency}`, and `{project}` placeholders.

## Invoice JSON Shape

Required final invoice shape:

```json
{
  "meta": {
    "schema": 1,
    "locale": "en-US"
  },
  "invoice": {
    "number": "INV2601",
    "issue_date": "2026-04-15",
    "due_date": "2026-04-29",
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

The invoice total is always derived from `items`.
