#import "theme.typ": *
#import "components.typ": *

#set page(width: page-width, height: page-height, margin: 0pt, fill: color-bg)
#set text(font: font-family, size: value-size, fill: color-text)

#let invoice-items = (
  (title: "Example service - January 2026", amount: 1200),
  (title: "Example service - February 2026", amount: 1500),
  (title: "Example workshop - March 2026", amount: 900),
)

#let bank-details = (
  (label: "Recipient", value: "John Smith"),
  (label: "Bank", value: "Example Bank"),
  (label: "Bank code", value: "00000 EXAMPLE"),
  (label: "Account no.", value: "EX00 0000 0000 0000 0000"),
  (label: "Memo", value: "Invoice EX2601"),
  (label: "Due date", value: "2026-04-30"),
)

#place(top + left, dx: seller-x, dy: header-y)[
  #box(width: logo-width, height: logo-height)[
    #align(left + horizon)[
      #text(font: font-family, size: 20pt, weight: "medium", fill: color-text)[John Smith]
    ]
  ]
]

#place(top + left, dx: invoice-number-x, dy: header-y)[
  #field-block("Invoice No.", ("EX2601",), width: header-field-width, align_to: right)
]

#place(top + left, dx: date-x, dy: header-y)[
  #field-block("Date", ("2026-04-14",), width: header-field-width, align_to: right)
]

#place(top + left, dx: seller-x, dy: content-y)[
  #stack(
    dir: ttb,
    spacing: block-gap,
    field-block("Seller", ("John Smith",), width: seller-width),
    field-block("Personal identification No.", ("00000000000",), width: seller-width),
    field-block("Individual economic Activity Certificate No.", ("EX-000000",), width: seller-width),
    field-block("Address", ("123 Example Street", "Example City 00000"), width: seller-width),
    field-block("Phone No.", ("+1 555 0100",), width: seller-width),
    field-block("Email", ("john.smith@example.com",), width: seller-width),
    field-block("Website", ("example.com",), width: seller-width),
  )
]

#place(top + left, dx: main-x, dy: content-y)[
  #stack(
    dir: ttb,
    spacing: block-gap,
    field-block(
      "Billed to",
      (
        "Example Client, Inc.",
        "Company No.: 0000000",
        "456 Sample Avenue",
        "Example City 11111",
        "United States",
      ),
      width: main-width,
      first_weight: "medium",
    ),
    field-block("Project", ("Example Project",), width: main-width),
    invoice-table(invoice-items, 3600, currency: "usd"),
    columns-block("Seller Bank Details", bank-details, width: main-width),
  )
]

#place(top + left, dx: signature-issued-x, dy: signature-y)[
  #signature-well("Invoice Issued")
]

#place(top + left, dx: signature-received-x, dy: signature-y)[
  #signature-well("Invoice Received")
]
