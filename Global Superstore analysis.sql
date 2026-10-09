-- Global Superstore analysis | BigQuery
-- Question: Which categories, sub-categories and markets are least profitable,
-- and does discounting explain it?

-- 1. Check the size of the data (51,290 order lines)
SELECT COUNT(*) AS total_rows
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`;

-- 2. Sales and profit by category
SELECT Category,
COUNT(*) AS order_lines,
ROUND(SUM(Sales), 0) AS total_sales,
ROUND(SUM(Profit), 0) AS total_profit
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
GROUP BY Category;

-- 3. Profit margin by sub-category (worst first)
SELECT Category,
`Sub-Category`,
COUNT(*) AS order_lines,
ROUND(SUM(Sales), 0) AS total_sales,
ROUND(SUM(Profit), 0) AS total_profit,
ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS margin_pct
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
GROUP BY Category, `Sub-Category`
ORDER BY total_profit ASC;

-- 4. Profit by discount band
SELECT
  CASE
    WHEN Discount = 0 THEN '0% (no discount)'
    WHEN Discount <= 0.2 THEN '1-20%'
    WHEN Discount <= 0.4 THEN '21-40%'
    ELSE 'Over 40%'
  END AS discount_band,
  COUNT(*) AS order_lines,
  ROUND(SUM(Sales), 0) AS total_sales,
  ROUND(SUM(Profit), 0) AS total_profit,
  ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS margin_pct
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
GROUP BY discount_band
ORDER BY discount_band;

-- 5. Profit by market
SELECT Market,
COUNT(*) AS order_lines,
ROUND(SUM(Sales), 0) AS total_sales,
ROUND(SUM(Profit), 0) AS total_profit,
ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS margin_pct
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
GROUP BY Market
ORDER BY total_profit ASC;

-- 6. Tables: profit by discount band
SELECT
CASE
WHEN Discount = 0 THEN '0% (no discount)'
WHEN Discount <= 0.2 THEN '1-20%'
WHEN Discount <= 0.4 THEN '21-40%'
ELSE 'Over 40%'
END AS discount_band,
COUNT(*) AS order_lines,
ROUND(SUM(Profit), 0) AS total_profit
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
WHERE `Sub-Category` = 'Tables'
GROUP BY discount_band
ORDER BY discount_band;

-- 7. Data quality check
SELECT
COUNT(*) AS total_rows,
COUNTIF(Sales IS NULL) AS blank_sales,
COUNTIF(Profit IS NULL) AS blank_profit,
COUNTIF(Discount IS NULL) AS blank_discount,
(SELECT COUNT(*) FROM (SELECT DISTINCT * FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`)) AS distinct_rows
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`;

-- 8. Duplicate check ignoring the Row ID
SELECT COUNT(*) AS rows_without_row_id_duplicates
FROM (
  SELECT DISTINCT * EXCEPT(`Row ID`)
  FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
);

-- 9. Least profitable countries
SELECT Country,
COUNT(*) AS order_lines,
ROUND(SUM(Profit), 0) AS total_profit,
ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS margin_pct
FROM `project-cc8cddff-8563-49bc-b21.superstore.superstore_raw`
GROUP BY Country
ORDER BY total_profit ASC
LIMIT 10;