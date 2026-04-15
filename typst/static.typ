#import "theme.typ": *
#import "components.typ": *

#set page(width: page-width, height: page-height, margin: 0pt, fill: color-bg)
#set text(font: font-family, size: value-size, fill: color-text)

#let invoice-items = (
  (title: "Product discovery workshop", amount: 1800),
  (title: "Dashboard interface design", amount: 3200),
)

#let bank-details = (
  (label: "Recipient", value: "Vertex Labs"),
  (label: "Bank", value: "SEB Bankas"),
  (label: "Bank code", value: "CBVILT2X"),
  (label: "Account no.", value: "LT12 7044 0600 1234 5678"),
  (label: "Memo", value: "Invoice VX2601"),
  (label: "Due date", value: "2026-04-30"),
)

#place(top + left, dx: seller-x, dy: header-y)[
  #box(width: logo-width, height: logo-height)[
    #align(left + horizon)[
      #text(font: font-family, size: 20pt, weight: "semibold", fill: color-text)[Vertex Labs]
    ]
  ]
]

#place(top + left, dx: invoice-number-x, dy: header-y)[
  #field-block("Invoice No.", ("VX2601",), width: header-field-width, align_to: right)
]

#place(top + left, dx: date-x, dy: header-y)[
  #field-block("Date", ("2026-04-14",), width: header-field-width, align_to: right)
]

#place(top + left, dx: seller-x, dy: content-y)[
  #stack(
    dir: ttb,
    spacing: block-gap,
    field-block("Seller", ("Vertex Labs",), width: seller-width),
    field-block("Company code", ("305998412",), width: seller-width),
    field-block("VAT number", ("LT100015842617",), width: seller-width),
    field-block("Address", ("A. Gostauto g. 8", "LT-01108 Vilnius, Lithuania"), width: seller-width),
    field-block("Phone No.", ("+370 5 214 0148",), width: seller-width),
    field-block("Email", ("billing@vertexlabs.example",), width: seller-width),
    field-block("Website", ("vertexlabs.example",), width: seller-width),
  )
]

#place(top + left, dx: main-x, dy: content-y)[
  #stack(
    dir: ttb,
    spacing: block-gap,
    field-block(
      "Billed to",
      (
        "Brightfield Systems, Inc.",
        "Company No.: 84-5629107",
        "318 Maple Avenue",
        "Burlington, VT 05401",
        "United States",
      ),
      width: main-width,
      first_weight: "semibold",
    ),
    field-block("Project", ("Analytics portal refresh",), width: main-width),
    invoice-table(invoice-items, 5000, currency: "usd"),
    columns-block("Seller Bank Details", bank-details, width: main-width),
  )
]

#place(top + left, dx: signature-issued-x, dy: signature-y)[
  #signature-well("Invoice Issued")
]

#place(top + left, dx: signature-received-x, dy: signature-y)[
  #signature-well("Invoice Received")
]
