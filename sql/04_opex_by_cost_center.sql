
-- OpEx actual vs budget by cost center, YTD through latest actual month.
WITH latest AS (
  SELECT MAX(period) AS period FROM fact_opex WHERE actual IS NOT NULL
)
SELECT
  o.cost_center,
  o.cost_center_name,
  ROUND(SUM(o.actual), 0) AS actual_opex,
  ROUND(SUM(o.budget), 0) AS budget_opex,
  ROUND(SUM(o.actual) - SUM(o.budget), 0) AS variance,
  ROUND(100.0 * (SUM(o.actual) - SUM(o.budget)) / SUM(o.budget), 1) AS variance_pct
FROM fact_opex o
JOIN latest l ON o.period <= l.period
WHERE o.actual IS NOT NULL
GROUP BY o.cost_center, o.cost_center_name
ORDER BY variance DESC;
