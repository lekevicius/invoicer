import { RENDER_SCHEMA_VERSION } from "./constants";
import { toTypstRootPath } from "./paths";
import type { InvoiceInput, InvoiceRenderData, SellerInput } from "./types";
import type { LocaleLabels } from "./locales";

const DEFAULT_SIGNATURE_PLACEMENT = {
  x: 37,
  y: 742,
  width: 248,
};

export function buildRenderData(
  sellerInput: SellerInput,
  invoiceInput: InvoiceInput,
  labels: LocaleLabels,
): InvoiceRenderData {
  const seller = sellerInput.seller;
  const invoice = invoiceInput.invoice;
  const sellerBank = {
    ...seller.bank,
    ...invoiceInput.seller_bank,
  };
  const itemSum = invoiceInput.items.reduce((sum, item) => sum + item.amount, 0);
  const signaturePath = toTypstRootPath(seller.assets?.signature?.svg);

  return {
    render_schema: RENDER_SCHEMA_VERSION,
    assets: {
      background: toTypstRootPath(seller.assets?.background),
      logotype: toTypstRootPath(seller.assets?.logotype),
      signature: signaturePath
        ? {
            svg: signaturePath,
            x: seller.assets?.signature?.x ?? DEFAULT_SIGNATURE_PLACEMENT.x,
            y: seller.assets?.signature?.y ?? DEFAULT_SIGNATURE_PLACEMENT.y,
            width: seller.assets?.signature?.width ?? DEFAULT_SIGNATURE_PLACEMENT.width,
          }
        : null,
    },
    header: {
      invoice_number: invoice.number,
      issue_date: invoice.issue_date,
      currency: invoice.currency,
    },
    labels,
    seller_blocks: [
      { label: labels.seller, lines: [seller.name], first_weight: "regular" },
      {
        label: labels.personal_identification_no,
        lines: [seller.personal_code],
        first_weight: "regular",
      },
      {
        label: labels.activity_certificate_no,
        lines: [seller.activity_number],
        first_weight: "regular",
      },
      { label: labels.address, lines: seller.address, first_weight: "regular" },
      { label: labels.phone_no, lines: [seller.phone], first_weight: "regular" },
      { label: labels.email, lines: [seller.email], first_weight: "regular" },
      { label: labels.website, lines: [seller.website], first_weight: "regular" },
    ],
    billed_to: {
      label: labels.billed_to,
      lines: [
        invoiceInput.buyer.name,
        `${labels.company_no_prefix} ${invoiceInput.buyer.company_code}`,
        ...invoiceInput.buyer.address,
      ],
      first_weight: "medium",
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
    bank_details: [
      { label: labels.recipient, value: sellerBank.beneficiary },
      { label: labels.bank, value: sellerBank.bank_name },
      { label: labels.bank_code, value: sellerBank.bank_code },
      { label: labels.account_no, value: sellerBank.iban },
      { label: labels.memo, value: `${labels.memo_invoice_prefix} ${invoice.number}` },
      { label: labels.due_date, value: invoice.due_date },
    ],
    totals: {
      item_sum: itemSum,
    },
  };
}
