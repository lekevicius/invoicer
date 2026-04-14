export type LocaleLabels = {
  seller: string;
  personal_identification_no: string;
  activity_certificate_no: string;
  address: string;
  phone_no: string;
  email: string;
  website: string;
  billed_to: string;
  company_no_prefix: string;
  project: string;
  invoice_no: string;
  date: string;
  service: string;
  total: string;
  sum: string;
  seller_bank_details: string;
  recipient: string;
  bank: string;
  bank_code: string;
  account_no: string;
  memo: string;
  memo_invoice_prefix: string;
  due_date: string;
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
      seller: "Seller",
      personal_identification_no: "Personal identification No.",
      activity_certificate_no: "Individual economic Activity Certificate No.",
      address: "Address",
      phone_no: "Phone No.",
      email: "Email",
      website: "Website",
      billed_to: "Billed to",
      company_no_prefix: "Company No.:",
      project: "Project",
      invoice_no: "Invoice No.",
      date: "Date",
      service: "Service",
      total: "Total",
      sum: "Sum",
      seller_bank_details: "Seller Bank Details",
      recipient: "Recipient",
      bank: "Bank",
      bank_code: "Bank code",
      account_no: "Account no.",
      memo: "Memo",
      memo_invoice_prefix: "Invoice",
      due_date: "Due date",
      invoice_issued: "Invoice Issued",
      invoice_received: "Invoice Received",
      signature_helper: "First name, last name, signature",
    },
  },
  "lt-LT": {
    labels: {
      seller: "Pardavėjas",
      personal_identification_no: "Asmens kodas",
      activity_certificate_no: "Individualios veiklos Nr.",
      address: "Adresas",
      phone_no: "Telefonas",
      email: "El. pašto adresas",
      website: "Interneto puslapis",
      billed_to: "Pirkėjas",
      company_no_prefix: "Įm. kodas:",
      project: "Projektas",
      invoice_no: "Sąskaitos Nr.",
      date: "Išrašymo data",
      service: "Paslauga",
      total: "Suma",
      sum: "Iš viso",
      seller_bank_details: "Pardavėjo banko duomenys",
      recipient: "Gavėjas",
      bank: "Bankas",
      bank_code: "Banko kodas",
      account_no: "Sąskaitos Nr.",
      memo: "Paskirtis",
      memo_invoice_prefix: "Sąskaita",
      due_date: "Sumokėti iki",
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
