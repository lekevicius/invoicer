export type LocaleLabels = {
  billed_to: string;
  company_no_prefix: string;
  project: string;
  invoice_no: string;
  date: string;
  service: string;
  total: string;
  sum: string;
  seller_bank_details: string;
  invoice_issued: string;
  invoice_received: string;
  signature_helper: string;
};

export type Locale = {
  labels: LocaleLabels;
};

export const DEFAULT_LOCALE = "en-US";

export const locales = {
  "en-US": {
    labels: {
      billed_to: "Billed to",
      company_no_prefix: "Company No.:",
      project: "Project",
      invoice_no: "Invoice No.",
      date: "Date",
      service: "Service",
      total: "Total",
      sum: "Sum",
      seller_bank_details: "Seller Bank Details",
      invoice_issued: "Invoice Issued",
      invoice_received: "Invoice Received",
      signature_helper: "First name, last name, signature",
    },
  },
  "lt-LT": {
    labels: {
      billed_to: "Pirkėjas",
      company_no_prefix: "Įm. kodas:",
      project: "Projektas",
      invoice_no: "Sąskaitos Nr.",
      date: "Išrašymo data",
      service: "Paslauga",
      total: "Suma",
      sum: "Iš viso",
      seller_bank_details: "Pardavėjo banko duomenys",
      invoice_issued: "Sąskaitą išrašė",
      invoice_received: "Sąskaitą priėmė",
      signature_helper: "Vardas, pavardė, parašas",
    },
  },
} satisfies Record<string, Locale>;

export type LocaleCode = keyof typeof locales;

export function getLocale(localeCode: string | undefined): Locale {
  const resolvedCode = localeCode ?? DEFAULT_LOCALE;

  if (resolvedCode in locales) {
    return locales[resolvedCode as LocaleCode];
  }

  const supportedLocales = Object.keys(locales).join(", ");
  throw new Error(`Unsupported locale "${resolvedCode}". Supported locales: ${supportedLocales}.`);
}
