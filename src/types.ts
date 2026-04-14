import type { LocaleLabels } from "./locales";

export type SellerInput = {
  $schema?: string;
  seller: {
    name: string;
    personal_code: string;
    activity_number: string;
    address: string[];
    phone: string;
    email: string;
    website: string;
    bank: BankDetails;
    assets?: {
      background?: string | null;
      logotype?: string | null;
      signature?: {
        svg?: string | null;
        x?: number;
        y?: number;
        width?: number;
      } | null;
    };
  };
};

export type InvoiceInput = {
  $schema?: string;
  meta: {
    schema: 1;
    locale: string;
  };
  invoice: {
    number: string;
    issue_date: string;
    due_date: string;
    currency: string;
    project: string;
  };
  buyer: {
    name: string;
    company_code: string;
    address: string[];
  };
  seller_bank?: Partial<BankDetails>;
  items: Array<{
    title: string;
    amount: number;
  }>;
};

export type BankDetails = {
  beneficiary: string;
  bank_name: string;
  bank_code: string;
  iban: string;
};

export type RenderBlock = {
  label: string;
  lines: string[];
  first_weight: "regular" | "medium";
};

export type InvoiceRenderData = {
  render_schema: 1;
  assets: {
    background: string | null;
    logotype: string | null;
    signature: {
      svg: string;
      x: number;
      y: number;
      width: number;
    } | null;
  };
  header: {
    invoice_number: string;
    issue_date: string;
    currency: string;
  };
  labels: LocaleLabels;
  seller_blocks: RenderBlock[];
  billed_to: RenderBlock;
  project: RenderBlock;
  items: Array<{
    title: string;
    amount: number;
  }>;
  bank_details: Array<{
    label: string;
    value: string;
  }>;
  totals: {
    item_sum: number;
  };
};

export type GenerateOptions = {
  invoicePath: string;
  sellerPath: string;
  outPath?: string;
  jsonPath?: string;
  renderOnly: boolean;
};

export type GenerateResult = {
  invoicePath: string;
  sellerPath: string;
  jsonPath: string | null;
  outPath: string | null;
  invoiceNumber: string;
};
