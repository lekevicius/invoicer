// Design tokens and default theme for the invoice layout.

#let page-width = 210mm
#let page-height = 297mm

#let default-theme = (
  colors: (
    background: "#F8F7F7",
    heading: "#8C8A7C",
    text: "#2E3C4B",
    border: "#D2D2CC",
  ),
  font: (
    family: "Colfax",
  ),
)

#let theme-colors(theme) = theme.at("colors", default: default-theme.colors)
#let theme-font(theme) = theme.at("font", default: default-theme.font)
#let theme-color(theme, name) = rgb(theme-colors(theme).at(name, default: default-theme.colors.at(name)))
#let theme-font-family(theme) = theme-font(theme).at("family", default: default-theme.font.family)

#let color-bg = theme-color(default-theme, "background")
#let color-heading = theme-color(default-theme, "heading")
#let color-text = theme-color(default-theme, "text")
#let color-border = theme-color(default-theme, "border")

#let font-family = theme-font-family(default-theme)

#let margin = 54pt
#let header-y = 54pt
#let content-y = 126pt
#let signature-y = 720pt

#let background-x = 0pt
#let background-y = 0pt

#let seller-x = 54pt
#let seller-width = 162pt
#let main-x = 252pt
#let main-width = 288pt

#let invoice-number-x = 306pt
#let date-x = 432pt
#let header-field-width = 108pt

#let logo-width = 152pt
#let logo-height = 27pt

#let block-gap = 12pt
#let field-gap = 6pt

#let label-size = 8pt
#let label-line = 12pt
#let label-tracking = 0.666pt

#let value-size = 12pt
#let value-line = 18pt

#let label-small-size = 10pt
#let label-small-line = 10pt

#let table-gap = 2pt
#let table-total-width = 71pt
#let table-top-pad = 6pt
#let table-heading-height = 20pt
#let table-row-height = 26pt

#let text-columns-label-width = 90pt
#let text-columns-gap = 18pt
#let text-columns-row-gap = 4pt
#let columns-block-gap = 12pt

#let signature-well-width = 216pt
#let signature-well-height = 72pt
#let signature-issued-x = 54pt
#let signature-received-x = 324pt
#let signature-line-y = 54pt
#let signature-helper-y = 62pt
