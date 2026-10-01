
-- Northline Consumer Products — sample FP&A star schema (fictional).
-- Load with: sqlite3 northline_fpa.db < sql/00_schema.sql
-- then the Python loader, or run: python load_and_run.py

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS fact_opex;

CREATE TABLE fact_sales (
  period TEXT NOT NULL,
  sku TEXT NOT NULL,
  product_name TEXT NOT NULL,
  category TEXT NOT NULL,
  channel TEXT NOT NULL,
  region TEXT NOT NULL,
  list_price REAL NOT NULL,
  std_cogs REAL NOT NULL,
  budget_units INTEGER NOT NULL,
  budget_price REAL NOT NULL,
  actual_units INTEGER,
  actual_price REAL,
  forecast_units INTEGER NOT NULL,
  forecast_price REAL NOT NULL
);

CREATE TABLE fact_opex (
  period TEXT NOT NULL,
  cost_center TEXT NOT NULL,
  cost_center_name TEXT NOT NULL,
  gl_account TEXT NOT NULL,
  budget REAL NOT NULL,
  actual REAL,
  forecast REAL NOT NULL
);
