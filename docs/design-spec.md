# JL Invoice Design Spec

Source: Figma file `bEpIVuHTbXTl3CeFVnFnj5`, frame `1:2` (`invoice`), component nodes `1:88`, `1:167`, `1:165`, `1:166`, `1:274`, `1:170`, `1:263`.

## Coordinate System

- Canvas: A4 page, `595pt x 842pt`.
- Unit rule: Figma `1px = 1pt`. Use points for all Typst layout constants.
- Page origin: top-left corner.
- Page background: `#F8F7F7`.
- Main margin: `54pt` (`3/4in`) from top/left/right for primary blocks.
- Header row:
  - Logo: `x 54pt`, `y 54pt`, `200pt x 27pt`.
  - Invoice number block: `x 306pt`, `y 54pt`, `108pt` wide.
  - Date block: `x 432pt`, `y 54pt`, `108pt` wide.
- Content row:
  - Starts at `y 126pt` (`1 3/4in`).
  - Left seller column: `x 54pt`, `width 162pt` (`2 1/4in`), `height 576pt`.
  - Column gap: `36pt` (`1/2in`).
  - Main column: `x 252pt`, `width 288pt` (`4in`), `height 576pt`.
- Signature row:
  - Starts at `y 720pt` (`10in`).
  - Left well: `x 54pt`, `width 216pt` (`3in`), `height 72pt`.
  - Signature gap: `54pt` (`3/4in`).
  - Right well: `x 324pt`, `width 216pt` (`3in`), `height 72pt`.

The decorative top artwork is optional and configured from `seller.assets.background`. When present, it is placed at `x 0pt`, `y 0pt`, `width 595pt`, with proportional height and top gravity; the current source is `1190px x 1040px`, so its proportional height at page width is `520pt`. The logotype is optional and configured from `seller.assets.logotype`; when present, it is placed at `x 54pt`, `y 54pt`, `width 200pt`, `height 27pt`. The seller signature is optional and configured from `seller.assets.signature.svg`; when present, it is placed absolutely at `x 37pt`, `y 742pt`, `width 248pt`.

## Colors

| Token | Hex | Usage |
| --- | --- | --- |
| `color-bg` | `#F8F7F7` | Page fill |
| `color-heading` | `#8C8A7C` | Labels and section headings |
| `color-text` | `#2E3C4B` | Body text, logo fill, totals |
| `color-border` | `#D2D2CC` | Table row rules and signature well line |

## Typography

All text uses `Colfax`.

| Token | Figma style | Typst spec | Usage |
| --- | --- | --- | --- |
| `label` | Colfax Medium, 8px, 12px line, 15% letter spacing | `8pt`, `medium`, `12pt` line box, `1.2pt` tracking, uppercase, `color-heading` | Field labels, table headings, section headings |
| `value` | Colfax Regular, 12px, 18px line | `12pt`, `regular`, `18pt` line box, `0pt` tracking, `color-text` | Normal field values, table body values |
| `value-bold` | Colfax Medium, 12px, 18px line | `12pt`, `medium`, `18pt` line box, `0pt` tracking, `color-text` | Buyer name, total row, key names in text columns |
| `label-small` | Colfax Regular, 10px, 10px line | `10pt`, `regular`, `10pt` line box, `0pt` tracking, `color-text` | Signature well helper text |
| `logotype` | Vector asset | `200pt x 27pt` SVG | Logo mark and seller name lockup |

## Reusable Components

### Field Block

Figma node: `1:88`.

- Default width: `162pt`; main column instances use `288pt`, header instances use `108pt`.
- Auto-layout direction: vertical.
- Internal gap: `6pt`.
- Label:
  - Style: `label`.
  - Height: `12pt` per line; long labels can wrap and increase the field block height.
  - Width: fill parent.
  - Transform: uppercase.
- Value:
  - Style: `value`.
  - Each text line uses an `18pt` line box.
  - Width: fill parent.
  - May use `value-bold` for emphasized first line, as in the buyer block.
- One-line block height: `12 + 6 + 18 = 36pt`.
- Multi-line block height: `12 + 6 + (18 * line count)`.
- If the label wraps, add another `12pt` for each additional label line. In the static seller column, `Individual economic Activity Certificate No.` is a two-line label, making that block `24 + 6 + 18 = 48pt`.
- Header field alignment: right aligned for both label and value.
- Column flow gap between field blocks: `12pt`.

### Table Heading Cell

Figma node: `1:167`.

- Width in component definition: `216pt`; within invoice table, service column is `215pt`, amount column is `71pt`.
- Height: `20pt` (`12pt` label line + `4pt` top padding + `4pt` bottom padding).
- Style: `label`.
- Alignment: left for service column, right for amount column.
- Bottom border: `1pt` `color-border`.

### Table Body Cell

Figma node: `1:165`.

- Width in component definition: `216pt`; within invoice table, service column is `215pt`, amount column is `71pt`.
- Height: `26pt` (`18pt` value line + `4pt` top padding + `4pt` bottom padding).
- Style: `value`.
- Alignment: left for service column, right for amount column.
- Bottom border: `1pt` `color-border`.

### Table Footer Cell

Figma node: `1:166`.

- Width in component definition: `216pt`; within invoice table, service column is `215pt`, amount column is `71pt`.
- Height: `26pt`.
- Style: `value-bold`.
- Alignment: left for `Sum`, right for total amount.
- No bottom border.

### Invoice Table

Figma assembled node: `1:194`.

- Position in main column: `x 0pt`, `y 168pt` relative to main column.
- Width: `288pt`.
- Top padding before heading row: `6pt`.
- Column layout:
  - Service column: `215pt`.
  - Inter-column gap: `2pt`.
  - Total column: `71pt`.
- Row heights:
  - Heading: `20pt`.
  - Body rows: `26pt` each.
  - Footer row: `26pt`.
- Total table height for three rows: `6 + 20 + (3 * 26) + 26 = 130pt`.

### Columns Block

Figma node: `1:274`.

- Default width: `288pt`.
- Auto-layout direction: vertical.
- Heading style: `label`.
- Heading line box: `12pt`.
- Gap between heading and rows slot: `8pt` in Figma auto-layout; Typst uses `12pt` here to compensate for its vertically centered font metrics and preserve the visual gap.
- Slot height in static example: `128pt`.

### Text Columns Row

Figma node: `1:170`.

- Width: `288pt`.
- Height: `18pt`.
- Auto-layout direction: horizontal.
- Label column: `90pt`, style `value-bold`.
- Gap: `18pt`.
- Value column: remaining `180pt`, style `value`.
- Row gap inside the columns block slot: `4pt` (`18pt` row height with row origins every `22pt`).

### Signature Well

Figma node: `1:263`.

- Width: `216pt`.
- Height: `72pt`.
- Heading:
  - Position: `x 0pt`, `y 0pt`.
  - Style: `label`.
- Rule:
  - Position: `x 0pt`, `y 54pt`.
  - Size: `216pt x 1pt`.
  - Fill: `color-border`.
- Helper:
  - Approximate position: `x 0pt`, `y 62pt`.
  - Style: `label-small`.
  - Text: `First name, last name, signature`.

## Static Content Positions

Main column (`x 252pt`, `y 126pt`, width `288pt`) flows vertically with `12pt` between blocks:

- `Billed to`: `y 0pt`, height `108pt`.
- `Project`: `y 120pt`, height `36pt`.
- `Table`: `y 168pt`, height `130pt`.
- `Seller Bank Details`: `y 310pt`, height `148pt`.

Seller column (`x 54pt`, `y 126pt`, width `162pt`) flows vertically with `12pt` between blocks:

- `Seller`: `y 0pt`, height `36pt`.
- `Personal identification No.`: `y 48pt`, height `36pt`.
- `Individual economic Activity Certificate No.`: `y 96pt`, height `48pt`.
- `Address`: `y 156pt`, height `54pt`.
- `Phone No.`: `y 222pt`, height `36pt`.
- `Email`: `y 270pt`, height `36pt`.
- `Website`: `y 318pt`, height `36pt`.
