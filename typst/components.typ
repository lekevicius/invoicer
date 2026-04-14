#import "theme.typ": *

#let label-text(body) = text(
  font: font-family,
  size: label-size,
  weight: "medium",
  fill: color-heading,
  tracking: label-tracking,
)[#upper(body)]

#let value-text(body, weight: "regular") = text(
  font: font-family,
  size: value-size,
  weight: weight,
  fill: color-text,
)[#body]

#let aligned-line(body, width: 100%, height: value-line, align_to: left) = box(width: width, height: height)[
  #align(align_to + horizon)[#body]
]

#let label-line-box(body, width: 100%, align_to: left) = context {
  let measured-width = measure(text(
    font: font-family,
    size: label-size,
    weight: "medium",
    tracking: label-tracking,
  )[#upper(body)]).width
  let lines = calc.max(1, calc.ceil(measured-width / width))

  aligned-line(label-text(body), width: width, height: label-line * lines, align_to: align_to)
}

#let value-line-box(body, width: 100%, align_to: left, weight: "regular") = aligned-line(
  value-text(body, weight: weight),
  width: width,
  height: value-line,
  align_to: align_to,
)

#let small-label-line-box(body, width: 100%, align_to: left) = aligned-line(
  text(font: font-family, size: label-small-size, weight: "regular", fill: color-text)[#body],
  width: width,
  height: label-small-line,
  align_to: align_to,
)

#let value-lines(lines, width: 100%, align_to: left, first_weight: "regular") = stack(
  dir: ttb,
  spacing: 0pt,
  ..lines.enumerate().map(((index, line)) => value-line-box(
    line,
    width: width,
    align_to: align_to,
    weight: if index == 0 { first_weight } else { "regular" },
  )),
)

#let field-block(title, lines, width: seller-width, align_to: left, first_weight: "regular") = box(width: width)[
  #stack(
    dir: ttb,
    spacing: field-gap,
    label-line-box(title, width: width, align_to: align_to),
    value-lines(lines, width: width, align_to: align_to, first_weight: first_weight),
  )
]

#let table-cell-body(body, align_to: left, kind: "body") = {
  if kind == "heading" {
    label-text(body)
  } else if kind == "footer" {
    value-text(body, weight: "medium")
  } else {
    value-text(body)
  }
}

#let table-cell-box(body, width: table-service-width, align_to: left, kind: "body") = {
  let height = if kind == "heading" { table-heading-height } else { table-row-height }
  let stroke = if kind == "footer" { none } else { (bottom: 1pt + color-border) }

  table.cell(
    inset: 0pt,
    stroke: none,
  )[
    #rect(
    width: width,
    height: height,
    stroke: stroke,
    inset: 0pt,
    )[
      #aligned-line(table-cell-body(body, kind: kind), width: width, height: height, align_to: align_to)
    ]
  ]
}

#let table-gap-cell(kind: "body") = {
  let height = if kind == "heading" { table-heading-height } else { table-row-height }

  table.cell(inset: 0pt, stroke: none)[
    #box(width: table-gap, height: height)[]
  ]
}

#let table-row-cells(left_body, right_body, kind: "body") = (
  table-cell-box(left_body, width: table-service-width, kind: kind),
  table-gap-cell(kind: kind),
  table-cell-box(right_body, width: table-total-width, align_to: right, kind: kind),
)

#let invoice-table(items, total, currency: "usd", labels: none) = {
  let service-label = if labels == none { "Service" } else { labels.service }
  let total-label = if labels == none { "Total" } else { labels.total }
  let sum-label = if labels == none { "Sum" } else { labels.sum }
  let body-cells = items.map(item => table-row-cells(item.title, str(item.amount), kind: "body")).flatten()

  box(width: table-width)[
    #stack(
      dir: ttb,
      spacing: 0pt,
      box(height: table-top-pad)[],
      table(
        columns: (table-service-width, table-gap, table-total-width),
        column-gutter: 0pt,
        row-gutter: 0pt,
        inset: 0pt,
        stroke: none,
        table.header(repeat: false, ..table-row-cells(service-label, total-label + ", " + currency, kind: "heading")),
        ..body-cells,
        table.footer(repeat: false, ..table-row-cells(sum-label, str(total), kind: "footer")),
      ),
    )
  ]
}

#let text-columns-row(label, value) = grid(
  columns: (text-columns-label-width, text-columns-gap, 1fr),
  column-gutter: 0pt,
  box(height: value-line)[#value-text(label, weight: "medium")],
  [],
  box(height: value-line)[#value-text(value)],
)

#let columns-block(title, rows, width: main-width) = box(width: width)[
  #stack(
    dir: ttb,
    spacing: columns-block-gap,
    label-line-box(title, width: width),
    stack(
      dir: ttb,
      spacing: text-columns-row-gap,
      ..rows.map(row => text-columns-row(row.label, row.value)),
    ),
  )
]

#let signature-well(title, helper: "First name, last name, signature") = box(width: signature-well-width, height: signature-well-height)[
  #place(top + left, dx: 0pt, dy: 0pt)[#label-line-box(title, width: signature-well-width)]
  #place(top + left, dx: 0pt, dy: signature-line-y)[#line(length: signature-well-width, stroke: 1pt + color-border)]
  #place(top + left, dx: 0pt, dy: signature-helper-y)[#small-label-line-box(helper, width: signature-well-width)]
]
