
-- Channel contribution vs budget for the latest actual month.
WITH latest AS (
  SELECT MAX(period) AS period FROM fact_sales WHERE actual_units IS NOT NULL
)
SELECT
  s.channel,
  ROUND(SUM(s.actual_units * s.actual_price), 0) AS actual_revenue,
  ROUND(SUM(s.budget_units * s.budget_price), 0) AS budget_revenue,
  ROUND(SUM(s.actual_units * s.actual_price) - SUM(s.budget_units * s.budget_price), 0) AS revenue_var,
  ROUND(SUM(s.actual_units * (s.actual_price - s.std_cogs)), 0) AS actual_gm,
  ROUND(100.0 * SUM(s.actual_units * (s.actual_price - s.std_cogs))
        / SUM(s.actual_units * s.actual_price), 1) AS actual_gm_pct
FROM fact_sales s
JOIN latest l ON s.period = l.period
GROUP BY s.channel
ORDER BY actual_revenue DESC;
