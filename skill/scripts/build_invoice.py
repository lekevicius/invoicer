#!/usr/bin/env python3
import argparse
import datetime as dt
import json
import re
from pathlib import Path


def capitalize_leading_letter(value: str) -> str:
    if not value:
        return value

    first = value[0]
    return first.upper() + value[1:]


def next_invoice_number(invoice_dir: Path, issue_date: dt.date, prefix: str) -> str:
    year_suffix = f"{issue_date.year % 100:02d}"
    pattern = re.compile(rf"^{re.escape(prefix)}{year_suffix}(\d{{2}})$")
    max_seq = 0

    for path in invoice_dir.glob("*.json"):
        try:
            data = json.loads(path.read_text())
            number = str(data.get("invoice", {}).get("number", ""))
        except Exception:
            continue
        match = pattern.match(number)
        if match:
            max_seq = max(max_seq, int(match.group(1)))

    return f"{prefix}{year_suffix}{max_seq + 1:02d}"


def main() -> None:
    parser = argparse.ArgumentParser(description="Build a complete invoice JSON from a compact draft")
    parser.add_argument("input", help="Path to a compact invoice draft JSON")
    parser.add_argument("output", help="Path to write the completed invoice JSON")
    parser.add_argument("--invoice-dir", help="Directory of existing invoice JSON files. Defaults to the output directory.")
    parser.add_argument("--invoice-prefix", default="INV", help="Invoice number prefix used before YYXX. Defaults to INV.")
    parser.add_argument("--issue-date", help="Override issue date (YYYY-MM-DD)")
    parser.add_argument("--due-date", help="Override due date (YYYY-MM-DD)")
    parser.add_argument("--payment-terms-days", type=int, default=14, help="Days after issue date when due date is omitted.")
    parser.add_argument("--number", help="Override invoice number")
    args = parser.parse_args()

    draft = json.loads(Path(args.input).read_text())
    issue_date = dt.date.fromisoformat(args.issue_date) if args.issue_date else dt.date.today()
    due_date = dt.date.fromisoformat(args.due_date) if args.due_date else issue_date + dt.timedelta(days=args.payment_terms_days)
    output = Path(args.output)
    invoice_dir = Path(args.invoice_dir) if args.invoice_dir else output.parent
    number = args.number or next_invoice_number(invoice_dir, issue_date, args.invoice_prefix)

    meta = draft["meta"]
    invoice = draft["invoice"]
    items = [
        {
            **item,
            "title": capitalize_leading_letter(item["title"]),
        }
        for item in draft["items"]
    ]

    completed = {
        "meta": {
            "schema": 1,
            "locale": meta["locale"],
        },
        "invoice": {
            "number": number,
            "issue_date": issue_date.isoformat(),
            "due_date": due_date.isoformat(),
            "currency": invoice["currency"],
            "project": capitalize_leading_letter(invoice["project"]),
        },
        "buyer": draft["buyer"],
        "items": items,
    }

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(completed, ensure_ascii=False, indent=2) + "\n")
    print(output)


if __name__ == "__main__":
    main()
