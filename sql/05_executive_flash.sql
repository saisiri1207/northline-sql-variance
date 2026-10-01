
-- One-row executive flash for the latest actual month.
WITH latest AS (
  SELECT MAX(period) AS period FROM fact_sales WHERE actual_units IS NOT NULL
),
rev AS (
  SELECT
    SUM(actual_units * actual_price) AS act,
    SUM(budget_units * budget_price) AS bud,
    SUM(actual_units * (actual_price - std_cogs)) AS gm
  FROM fact_sales s JOIN latest l ON s.period = l.period
),
opex AS (
  SELECT SUM(actual) AS act, SUM(budget) AS bud
  FROM fact_opex o JOIN latest l ON o.period = l.period
)
SELECT
  (SELECT period FROM latest) AS period,
  ROUND(r.act, 0) AS revenue,
  ROUND(r.act - r.bud, 0) AS revenue_var_vs_budget,
  ROUND(100.0 * r.gm / r.act, 1) AS gm_pct,
  ROUND(o.act, 0) AS opex,
  ROUND(o.act - o.bud, 0) AS opex_var_vs_budget,
  ROUND(r.gm - o.act, 0) AS contribution_after_opex
FROM rev r, opex o;
