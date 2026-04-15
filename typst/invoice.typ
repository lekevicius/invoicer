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
#let signature-column-gap = signature-received-x - signature-issued-x - signature-well-width

#let place-at(x, y, body) = place(top + left, dx: x, dy: y)[#body]
#let natural-or-sized-image(path, width: none) = if width == none {
  image(path)
} else {
  image(path, width: width * 1pt)
}

#let header-row(data, theme: default-theme) = grid(
  columns: (logo-width, header-logo-gap, header-field-width, header-field-gap, header-field-width),
  column-gutter: 0pt,
  if data.assets.logotype != none {
    image(data.assets.logotype, width: logo-width, height: logo-height)
  } else {
    box(width: logo-width, height: logo-height)[]
  },
  [],
  field-block(data.labels.invoice_no, (data.header.invoice_number,), width: header-field-width, align_to: right, theme: theme),
  [],
  field-block(data.labels.date, (data.header.issue_date,), width: header-field-width, align_to: right, theme: theme),
)

#let seller-column(data, theme: default-theme) = stack(
  dir: ttb,
  spacing: block-gap,
  ..data.seller_blocks.map(block => field-block(
    block.label,
    block.lines,
    width: seller-width,
    first_weight: block.first_weight,
    theme: theme,
  )),
)

#let main-column(data, theme: default-theme) = stack(
  dir: ttb,
  spacing: block-gap,
  field-block(
    data.billed_to.label,
    data.billed_to.lines,
    width: main-width,
    first_weight: data.billed_to.first_weight,
    theme: theme,
  ),
  field-block(
    data.project.label,
    data.project.lines,
    width: main-width,
    first_weight: data.project.first_weight,
    theme: theme,
  ),
  invoice-table(
    data.items,
    data.totals.item_sum,
    currency: lower(data.header.currency),
    labels: data.labels,
    theme: theme,
  ),
  columns-block(data.labels.seller_bank_details, data.bank_details, width: main-width, theme: theme),
)

#let content-row(data, theme: default-theme) = grid(
  columns: (seller-width, content-column-gap, main-width),
  column-gutter: 0pt,
  seller-column(data, theme: theme),
  [],
  main-column(data, theme: theme),
)

#let signature-row(data, theme: default-theme) = grid(
  columns: (signature-well-width, signature-column-gap, signature-well-width),
  column-gutter: 0pt,
  signature-well(data.labels.invoice_issued, helper: data.labels.signature_helper, theme: theme),
  [],
  signature-well(data.labels.invoice_received, helper: data.labels.signature_helper, theme: theme),
)

#let invoice-flow(data, theme: default-theme) = stack(
  dir: ttb,
  spacing: 0pt,
  header-row(data, theme: theme),
  box(height: header-to-content-gap)[],
  box(height: content-region-height)[#content-row(data, theme: theme)],
  signature-row(data, theme: theme),
)

#let render-invoice(data) = {
  let invoice-theme = data.at("theme", default: default-theme)

  set page(width: page-width, height: page-height, margin: 0pt, fill: theme-color(invoice-theme, "background"))
  set text(font: theme-font-family(invoice-theme), size: value-size, fill: theme-color(invoice-theme, "text"))

  if data.assets.background != none {
    place-at(background-x, background-y, image(data.assets.background, width: page-width))
  }

  box(width: page-width, height: page-height)[
    #pad(left: seller-x, right: margin, top: header-y)[
      #invoice-flow(data, theme: invoice-theme)
    ]
  ]

  if data.assets.signature != none {
    let signature = data.assets.signature
    place-at(signature.x * 1pt, signature.y * 1pt, natural-or-sized-image(signature.svg, width: signature.at("width", default: none)))
  }
}
