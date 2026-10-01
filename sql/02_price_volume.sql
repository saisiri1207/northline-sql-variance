
-- Price / volume / mix bridge vs budget, latest actual month.
-- Volume uses budget price. Price uses actual units. Mix is the residual
-- of category mix shift inside the volume effect, reported separately.
WITH latest AS (
  SELECT MAX(period) AS period FROM fact_sales WHERE actual_units IS NOT NULL
),
sku AS (
  SELECT
    s.category,
    s.sku,
    SUM(s.actual_units) AS act_u,
    SUM(s.budget_units) AS bud_u,
    SUM(s.actual_units * s.actual_price) / SUM(s.actual_units) AS act_p,
    SUM(s.budget_units * s.budget_price) / SUM(s.budget_units) AS bud_p,
    SUM(s.actual_units * s.actual_price) AS act_rev,
    SUM(s.budget_units * s.budget_price) AS bud_rev
  FROM fact_sales s
  JOIN latest l ON s.period = l.period
  GROUP BY s.category, s.sku
)
SELECT
  category,
  sku,
  ROUND(act_rev, 0) AS actual_revenue,
  ROUND(bud_rev, 0) AS budget_revenue,
  ROUND(act_rev - bud_rev, 0) AS total_variance,
  ROUND((act_u - bud_u) * bud_p, 0) AS volume_variance,
  ROUND(act_u * (act_p - bud_p), 0) AS price_variance
FROM sku
ORDER BY total_variance;
