import type { LocaleLabels } from "./locales";

export type SellerInput = {
  $schema?: string;
  seller: {
    details: SellerDetailBlock[];
    bank_details: BankDetailRow[];
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
    theme?: {
      colors?: {
        background?: string;
        heading?: string;
        text?: string;
        border?: string;
      };
      font?: {
        family?: string;
        paths?: string[];
      };
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
  items: Array<{
    title: string;
    amount: number;
  }>;
};

export type SellerDetailBlock = {
  label: string;
  lines: string[];
  first_weight?: "regular" | "semibold";
};

export type BankDetailRow = {
  label: string;
  value: string;
};

export type RenderBlock = {
  label: string;
  lines: string[];
  first_weight: "regular" | "semibold";
};

export type InvoiceRenderData = {
  render_schema: 1;
  theme: {
    colors: {
      background: string;
      heading: string;
      text: string;
      border: string;
    };
    font: {
      family: string;
      paths: string[];
    };
  };
  assets: {
    background: string | null;
    logotype: string | null;
    signature: {
      svg: string;
      x: number;
      y: number;
      width?: number;
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
