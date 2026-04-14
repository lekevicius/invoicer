#import "theme.typ": *
#import "components.typ": *

// Flow-first renderer. It keeps absolute placement only for decorative/overlay
// assets, while the invoice body flows through grids/stacks.

#let header-row-height = 36pt
#let header-logo-gap = invoice-number-x - seller-x - logo-width
#let header-field-gap = date-x - invoice-number-x - header-field-width
#let content-column-gap = main-x - seller-x - seller-width
#let header-to-content-gap = content-y - header-y - header-row-height
#let content-region-height = signature-y - content-y

#let place-at(x, y, body) = place(top + left, dx: x, dy: y)[#body]

#let header-row(data) = grid(
  columns: (logo-width, header-logo-gap, header-field-width, header-field-gap, header-field-width),
  column-gutter: 0pt,
  if data.assets.logotype != none {
    image(data.assets.logotype, width: logo-width, height: logo-height)
  } else {
    box(width: logo-width, height: logo-height)[]
  },
  [],
  field-block(data.labels.invoice_no, (data.header.invoice_number,), width: header-field-width, align_to: right),
  [],
  field-block(data.labels.date, (data.header.issue_date,), width: header-field-width, align_to: right),
)

#let seller-column(data) = stack(
  dir: ttb,
  spacing: block-gap,
  ..data.seller_blocks.map(block => field-block(
    block.label,
    block.lines,
    width: seller-width,
    first_weight: block.first_weight,
  )),
)

#let main-column(data) = stack(
  dir: ttb,
  spacing: block-gap,
  field-block(
    data.billed_to.label,
    data.billed_to.lines,
    width: main-width,
    first_weight: data.billed_to.first_weight,
  ),
  field-block(
    data.project.label,
    data.project.lines,
    width: main-width,
    first_weight: data.project.first_weight,
  ),
  invoice-table(
    data.items,
    data.totals.item_sum,
    currency: lower(data.header.currency),
    labels: data.labels,
  ),
  columns-block(data.labels.seller_bank_details, data.bank_details, width: main-width),
)

#let content-row(data) = grid(
  columns: (seller-width, content-column-gap, main-width),
  column-gutter: 0pt,
  seller-column(data),
  [],
  main-column(data),
)

#let signature-row(data) = grid(
  columns: (signature-well-width, signature-gap, signature-well-width),
  column-gutter: 0pt,
  signature-well(data.labels.invoice_issued, helper: data.labels.signature_helper),
  [],
  signature-well(data.labels.invoice_received, helper: data.labels.signature_helper),
)

#let invoice-flow(data) = stack(
  dir: ttb,
  spacing: 0pt,
  header-row(data),
  box(height: header-to-content-gap)[],
  box(height: content-region-height)[#content-row(data)],
  signature-row(data),
)

#let render-invoice(data) = {
  set page(width: page-width, height: page-height, margin: 0pt, fill: color-bg)
  set text(font: font-family, size: value-size, fill: color-text)

  if data.assets.background != none {
    place-at(background-x, background-y, image(data.assets.background, width: page-width))
  }

  box(width: page-width, height: page-height)[
    #pad(left: seller-x, right: margin, top: header-y)[
      #invoice-flow(data)
    ]
  ]

  if data.assets.signature != none {
    let signature = data.assets.signature
    place-at(signature.x * 1pt, signature.y * 1pt, image(signature.svg, width: signature.width * 1pt))
  }
}
