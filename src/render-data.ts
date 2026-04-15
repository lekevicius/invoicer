import { RENDER_SCHEMA_VERSION } from "./constants";
import { toTypstRootPath } from "./paths";
import type { BankDetailRow, InvoiceInput, InvoiceRenderData, RenderBlock, SellerInput } from "./types";
import type { LocaleLabels } from "./locales";

const DEFAULT_SIGNATURE_PLACEMENT = {
  x: 37,
  y: 742,
};

const DEFAULT_THEME = {
  colors: {
    background: "#F8F7F7",
    heading: "#8C8A7C",
    text: "#2E3C4B",
    border: "#D2D2CC",
  },
  font: {
    family: "Colfax",
    paths: [] as string[],
  },
};

function buildSellerBlocks(seller: SellerInput["seller"]): RenderBlock[] {
  return seller.details.map((block) => ({
    label: block.label,
    lines: block.lines,
    first_weight: block.first_weight ?? "regular",
  }));
}

function formatBankDetailValue(value: string, invoice: InvoiceInput["invoice"]): string {
  return value
    .replaceAll("{invoice_number}", invoice.number)
    .replaceAll("{issue_date}", invoice.issue_date)
    .replaceAll("{due_date}", invoice.due_date)
    .replaceAll("{currency}", invoice.currency)
    .replaceAll("{project}", invoice.project);
}

function buildBankDetails(seller: SellerInput["seller"], invoiceInput: InvoiceInput): BankDetailRow[] {
  return seller.bank_details.map((row) => ({
    label: row.label,
    value: formatBankDetailValue(row.value, invoiceInput.invoice),
  }));
}

export function buildRenderData(
  sellerInput: SellerInput,
  invoiceInput: InvoiceInput,
  labels: LocaleLabels,
  sellerDir?: string,
): InvoiceRenderData {
  const seller = sellerInput.seller;
  const invoice = invoiceInput.invoice;
  const itemSum = invoiceInput.items.reduce((sum, item) => sum + item.amount, 0);
  const signaturePath = toTypstRootPath(seller.assets?.signature?.svg, sellerDir);
  const sellerTheme = seller.theme ?? {};
  const theme = {
    colors: {
      ...DEFAULT_THEME.colors,
      ...sellerTheme.colors,
    },
    font: {
      family: sellerTheme.font?.family ?? DEFAULT_THEME.font.family,
      paths: (sellerTheme.font?.paths ?? DEFAULT_THEME.font.paths).map((path) => toTypstRootPath(path, sellerDir) ?? path),
    },
  };

  return {
    render_schema: RENDER_SCHEMA_VERSION,
    theme,
    assets: {
      background: toTypstRootPath(seller.assets?.background, sellerDir),
      logotype: toTypstRootPath(seller.assets?.logotype, sellerDir),
      signature: signaturePath
        ? {
            svg: signaturePath,
            x: seller.assets?.signature?.x ?? DEFAULT_SIGNATURE_PLACEMENT.x,
            y: seller.assets?.signature?.y ?? DEFAULT_SIGNATURE_PLACEMENT.y,
            width: seller.assets?.signature?.width,
          }
        : null,
    },
    header: {
      invoice_number: invoice.number,
      issue_date: invoice.issue_date,
      currency: invoice.currency,
    },
    labels,
    seller_blocks: buildSellerBlocks(seller),
    billed_to: {
      label: labels.billed_to,
      lines: [
        invoiceInput.buyer.name,
        `${labels.company_no_prefix} ${invoiceInput.buyer.company_code}`,
        ...invoiceInput.buyer.address,
      ],
      first_weight: "semibold",
    },
    project: {
      label: labels.project,
      lines: [invoice.project],
      first_weight: "regular",
    },
    items: invoiceInput.items.map((item) => ({
      title: item.title,
      amount: item.amount,
    })),
    bank_details: buildBankDetails(seller, invoiceInput),
    totals: {
      item_sum: itemSum,
    },
  };
}
