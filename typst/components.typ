#import "theme.typ": *

#let label-text(body, theme: default-theme) = text(
  font: theme-font-family(theme),
  size: label-size,
  weight: "semibold",
  fill: theme-color(theme, "heading"),
  tracking: label-tracking,
)[#upper(body)]

#let value-text(body, weight: "regular", theme: default-theme) = text(
  font: theme-font-family(theme),
  size: value-size,
  weight: weight,
  fill: theme-color(theme, "text"),
)[#body]

#let aligned-line(body, width: 100%, height: value-line, align_to: left) = box(width: width, height: height)[
  #align(align_to + horizon)[#body]
]

#let label-line-box(body, width: 100%, align_to: left, theme: default-theme) = context {
  let measured-width = measure(text(
    font: theme-font-family(theme),
    size: label-size,
    weight: "semibold",
    tracking: label-tracking,
  )[#upper(body)]).width
  let lines = calc.max(1, calc.ceil(measured-width / width))

  aligned-line(label-text(body, theme: theme), width: width, height: label-line * lines, align_to: align_to)
}

#let value-line-box(body, width: 100%, align_to: left, weight: "regular", theme: default-theme) = aligned-line(
  value-text(body, weight: weight, theme: theme),
  width: width,
  height: value-line,
  align_to: align_to,
)

#let small-label-line-box(body, width: 100%, align_to: left, theme: default-theme) = aligned-line(
  text(font: theme-font-family(theme), size: label-small-size, weight: "regular", fill: theme-color(theme, "heading"))[#body],
  width: width,
  height: label-small-line,
  align_to: align_to,
)

#let value-lines(lines, width: 100%, align_to: left, first_weight: "regular", theme: default-theme) = stack(
  dir: ttb,
  spacing: 0pt,
  ..lines.enumerate().map(((index, line)) => value-line-box(
    line,
    width: width,
    align_to: align_to,
    weight: if index == 0 { first_weight } else { "regular" },
    theme: theme,
  )),
)

#let field-block(title, lines, width: seller-width, align_to: left, first_weight: "regular", theme: default-theme) = box(width: width)[
  #stack(
    dir: ttb,
    spacing: field-gap,
    label-line-box(title, width: width, align_to: align_to, theme: theme),
    value-lines(lines, width: width, align_to: align_to, first_weight: first_weight, theme: theme),
  )
]

#let table-cell-body(body, align_to: left, kind: "body", theme: default-theme) = {
  if kind == "heading" {
    label-text(body, theme: theme)
  } else if kind == "footer" {
    value-text(body, weight: "semibold", theme: theme)
  } else {
    value-text(body, theme: theme)
  }
}

#let table-cell-box(body, align_to: left, kind: "body", theme: default-theme) = {
  let height = if kind == "heading" { table-heading-height } else { table-row-height }
  let stroke = if kind == "footer" { none } else { (bottom: 1pt + theme-color(theme, "border")) }

  table.cell(
    inset: 0pt,
    stroke: none,
  )[
    #rect(
      width: 100%,
      height: height,
      stroke: stroke,
      inset: 0pt,
    )[
      #aligned-line(table-cell-body(body, kind: kind, theme: theme), height: height, align_to: align_to)
    ]
  ]
}

#let table-gap-cell(kind: "body") = {
  let height = if kind == "heading" { table-heading-height } else { table-row-height }

  table.cell(inset: 0pt, stroke: none)[
    #box(width: 100%, height: height)[]
  ]
}

#let table-row-cells(left_body, right_body, kind: "body", theme: default-theme) = (
  table-cell-box(left_body, kind: kind, theme: theme),
  table-gap-cell(kind: kind),
  table-cell-box(right_body, align_to: right, kind: kind, theme: theme),
)

#let invoice-table(items, total, currency: "usd", labels: none, width: 100%, theme: default-theme) = {
  let service-label = if labels == none { "Service" } else { labels.service }
  let total-label = if labels == none { "Total" } else { labels.total }
  let sum-label = if labels == none { "Sum" } else { labels.sum }
  let body-cells = items.map(item => table-row-cells(item.title, str(item.amount), kind: "body", theme: theme)).flatten()

  box(width: width)[
    #stack(
      dir: ttb,
      spacing: 0pt,
      box(height: table-top-pad)[],
      table(
        columns: (1fr, table-gap, table-total-width),
        column-gutter: 0pt,
        row-gutter: 0pt,
        inset: 0pt,
        stroke: none,
        table.header(repeat: false, ..table-row-cells(service-label, total-label + ", " + currency, kind: "heading", theme: theme)),
        ..body-cells,
        table.footer(repeat: false, ..table-row-cells(sum-label, str(total), kind: "footer", theme: theme)),
      ),
    )
  ]
}

#let text-columns-row(label, value, theme: default-theme) = grid(
  columns: (text-columns-label-width, text-columns-gap, 1fr),
  column-gutter: 0pt,
  box(height: value-line)[#value-text(label, weight: "semibold", theme: theme)],
  [],
  box(height: value-line)[#value-text(value, theme: theme)],
)

#let columns-block(title, rows, width: main-width, theme: default-theme) = box(width: width)[
  #stack(
    dir: ttb,
    spacing: columns-block-gap,
    label-line-box(title, width: width, theme: theme),
    stack(
      dir: ttb,
      spacing: text-columns-row-gap,
      ..rows.map(row => text-columns-row(row.label, row.value, theme: theme)),
    ),
  )
]

#let signature-well(title, helper: "First name, last name, signature", theme: default-theme) = box(width: signature-well-width, height: signature-well-height)[
  #place(top + left, dx: 0pt, dy: 0pt)[#label-line-box(title, width: signature-well-width, theme: theme)]
  #place(top + left, dx: 0pt, dy: signature-line-y)[#line(length: signature-well-width, stroke: 1pt + theme-color(theme, "border"))]
  #place(top + left, dx: 0pt, dy: signature-helper-y)[#small-label-line-box(helper, width: signature-well-width, theme: theme)]
]
