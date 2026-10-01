
-- Monthly revenue and gross margin: Actual vs Budget vs Forecast.
-- Actual months only. Dollars in units. Fictional Northline data.
WITH sales AS (
  SELECT
    period,
    SUM(actual_units * actual_price) AS actual_revenue,
    SUM(budget_units * budget_price) AS budget_revenue,
    SUM(forecast_units * forecast_price) AS forecast_revenue,
    SUM(actual_units * (actual_price - std_cogs)) AS actual_gm,
    SUM(budget_units * (budget_price - std_cogs)) AS budget_gm,
    SUM(forecast_units * (forecast_price - std_cogs)) AS forecast_gm
  FROM fact_sales
  WHERE actual_units IS NOT NULL
  GROUP BY period
)
SELECT
  period,
  ROUND(actual_revenue, 0) AS actual_revenue,
  ROUND(budget_revenue, 0) AS budget_revenue,
  ROUND(forecast_revenue, 0) AS forecast_revenue,
  ROUND(actual_revenue - budget_revenue, 0) AS var_vs_budget,
  ROUND(100.0 * (actual_revenue - budget_revenue) / budget_revenue, 1) AS var_vs_budget_pct,
  ROUND(actual_revenue - forecast_revenue, 0) AS var_vs_forecast,
  ROUND(100.0 * actual_gm / actual_revenue, 1) AS actual_gm_pct,
  ROUND(100.0 * budget_gm / budget_revenue, 1) AS budget_gm_pct
FROM sales
ORDER BY period;
