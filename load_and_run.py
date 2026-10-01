#!/usr/bin/env python3
"""Load sample CSVs into SQLite and run the FP&A query pack."""
import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parent
DB = ROOT / "northline_fpa.db"
OUT = ROOT / "output"
OUT.mkdir(exist_ok=True)

schema = (ROOT / "sql" / "00_schema.sql").read_text()
con = sqlite3.connect(DB)
con.executescript(schema)
sales = pd.read_csv(ROOT / "data" / "fact_sales.csv")
opex = pd.read_csv(ROOT / "data" / "fact_opex.csv")
sales.to_sql("fact_sales", con, if_exists="append", index=False)
opex.to_sql("fact_opex", con, if_exists="append", index=False)

for path in sorted((ROOT / "sql").glob("[0-9][0-9]_*.sql")):
    if path.name.startswith("00_"):
        continue
    df = pd.read_sql_query(path.read_text(), con)
    dest = OUT / (path.stem + ".csv")
    df.to_csv(dest, index=False)
    print(f"\n== {path.name} ==")
    print(df.to_string(index=False))
con.close()
print(f"\nWrote query outputs to {OUT}")
