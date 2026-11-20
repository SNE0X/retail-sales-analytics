-- Q1. Top 10 Customers and Revenue Contribution

-- Identify the top 10 customers by revenue and calculate their percentage
-- contribution to total business revenue.

WITH cus_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
),
top_customers AS (
    SELECT *
    FROM cus_revenue
    ORDER BY revenue DESC
    LIMIT 5
)
SELECT
    tc.customer_name,
	tc.customer_id,
    tc.revenue,
    ROUND(
        100.0 * tc.revenue /
        NULLIF((SELECT SUM(revenue) FROM cus_revenue), 0),
        2
    ) AS contribution_percentage
FROM top_customers AS tc
ORDER BY tc.revenue DESC;




--Q2. Product Category Revenue Contribution and Ranking

-- Analyze revenue by product category, calculate each 
-- category's contribution percentage and rank categories by revenue.

WITH category_sales AS (
    SELECT   p.category,
        sum(oi.quantity * oi.unit_price) AS revenue 
    FROM products p
    INNER JOIN order_items  oi
        ON p.product_id = oi.product_id
		GROUP BY p.category
)
SELECT
    category, revenue,
    ROUND(
        100.0 * revenue
        / NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_percentage,
DENSE_RANK() over(
ORDER BY revenue DESC
) as category_rank 
FROM category_sales 
ORDER BY revenue DESC;

-- Q3. Customer Lifetime Revenue and Purchasing Value

--Identify customers with the highest historical revenue, calculate 
--delivered orders and average order value, and rank customers by revenue.

with customer_revenue as(
 select  customer_name , c.customer_id , 
  COUNT(DISTINCT o.order_id) AS delivered_orders,
SUM(oi.quantity * oi.unit_price *(1 - COALESCE(oi.discount_pct, 0) / 100.0)
 ) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id,c.customer_name
),
customer_metrics AS (
SELECT customer_id,customer_name, delivered_orders, total_revenue,
 ROUND( total_revenue / NULLIF(delivered_orders, 0), 2 ) AS average_order_value
FROM customer_revenue
)
SELECT
    customer_id,customer_name,delivered_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    average_order_value,
    DENSE_RANK() OVER ( ORDER BY total_revenue DESC ) AS revenue_rank
FROM customer_metrics
ORDER BY total_revenue DESC;

-- Q4. Customer Segmentation Using Spending, Frequency and Recency

--Segment customers into high-value, regular, occasional, lapsed and 
--never-purchased groups using their purchasing behaviour.


WITH customer_values AS (
    SELECT c.customer_id, c.customer_name,
           COUNT(DISTINCT o.order_id) AS orders,
           COALESCE(SUM(oi.quantity * oi.unit_price
           * (1 - COALESCE(oi.discount_pct, 0) / 100.0)), 0) AS total_spent,
           MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o
      ON o.customer_id = c.customer_id
     AND o.order_status = 'Delivered'
    LEFT JOIN order_items oi
      ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name,
       orders,
       ROUND(total_spent, 2) AS total_spent,
       last_order_date,
       CASE
           WHEN orders = 0                               THEN 'Never purchased'
           WHEN CURRENT_DATE - last_order_date > 180      THEN 'Lapsed'
           WHEN total_spent >= 75000                    THEN 'High-value'
           WHEN orders >= 2                              THEN 'Regular'
           ELSE 'Occasional'
       END AS segment
FROM customer_values
ORDER BY total_spent DESC;


-- Q5. Top 3 Products by Revenue Within Each Category

--Identify and rank the top three revenue-generating 
--products within each product category.

WITH product_revenue AS ( 
SELECT p.product_id, p.product_name,  p.category,
SUM(oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount_pct, 0) / 100.0)) 
AS revenue
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
inner join orders o on o.order_id =oi.order_id
where o.order_status ='Delivered'
GROUP BY p.product_id,p.product_name, p.category
),
product_ranking AS (
SELECT product_id, product_name, category, revenue,
DENSE_RANK() OVER ( PARTITION BY category ORDER BY revenue DESC) 
AS product_rank
FROM product_revenue
)
SELECT product_id, product_name, category,
ROUND(revenue, 2) AS revenue,
product_rank
FROM product_ranking
WHERE product_rank <= 3
ORDER BY category,product_rank;

-- Q6. Most Profitable Products and Gross Margin Analysis

--Calculate product revenue, cost of goods sold, gross profit 
--and gross margin to identify the most profitable products.


WITH product_profit AS (
SELECT p.product_id, p.product_name, p.category,
SUM( oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount_pct, 0) / 100.0))
AS sales_revenue,
SUM(oi.quantity * oi.unit_cost ) AS product_cost
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON o.order_id = oi.order_id 
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id,p.product_name, p.category
),

profit_gross AS (
SELECT product_id, product_name,category,sales_revenue,product_cost,
sales_revenue - product_cost AS gross_profit,
ROUND( 100.0 * (sales_revenue - product_cost) /NULLIF(sales_revenue, 0), 2)
AS gross_margin_pct
FROM product_profit
)

SELECT product_id, product_name, category,
ROUND(sales_revenue, 2) AS sales_revenue,
ROUND(product_cost, 2) AS product_cost,
ROUND(gross_profit, 2) AS gross_profit,
gross_margin_pct
FROM profit_gross
ORDER BY gross_profit DESC;



--Q7. Discount Effectiveness and Profitability Analysis

--Analyze how different discount ranges affect revenue, 
--units sold, gross profit and gross margin.




WITH discount_analysis AS (
SELECT CASE
WHEN COALESCE(oi.discount_pct, 0) = 0 THEN '0% '
WHEN oi.discount_pct <= 5 THEN '1-5% '
WHEN oi.discount_pct <= 10 THEN '6-10% '
ELSE 'Above 10% '
END AS discount_band,
SUM(oi.quantity * oi.unit_price *(1 - COALESCE(oi.discount_pct, 0) / 100.0))
AS revenue,
SUM(oi.quantity) AS units_sold,
SUM(oi.quantity * oi.unit_cost) AS product_cost
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY 1
),
discount_metrics AS (
SELECT discount_band,revenue,units_sold,product_cost,
revenue - product_cost AS gross_profit,
ROUND(100.0 * (revenue - product_cost)/ NULLIF(revenue, 0), 2) 
AS gross_margin_pct
FROM discount_analysis
)
SELECT discount_band, ROUND(revenue, 2) AS revenue, 
units_sold,
ROUND(product_cost, 2) AS product_cost,
ROUND(gross_profit, 2) AS gross_profit,
gross_margin_pct
FROM discount_metrics
ORDER BY revenue DESC;

-- Q8. Delivery Performance and Late Delivery Analysis by Region

--Evaluate average delivery time and late delivery percentages across
--states to identify regions requiring improvement.

SELECT c.state AS states, COUNT(*) AS deli_orders,
ROUND(AVG(o.delivery_date - o.order_date), 2) AS avg_deli_days,
COUNT(*) FILTER ( WHERE o.delivery_date > o.expected_date ) AS late_orders,
ROUND(100.0 * COUNT(*) FILTER ( WHERE o.delivery_date > o.expected_date ) 
	/ NULLIF(COUNT(*), 0), 2 ) AS late_delivery_pct,

CASE 
WHEN 100.0 * COUNT(*) FILTER (WHERE o.delivery_date > o.expected_date)
	/ NULLIF(COUNT(*), 0) > 30 THEN 'High Priority'
WHEN 100.0 * COUNT(*) FILTER ( WHERE o.delivery_date > o.expected_date) 
	/ NULLIF(COUNT(*), 0) > 10 THEN 'Medium Priority'
ELSE 'Low Priority'
END AS further_investigation
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.state
ORDER BY late_delivery_pct DESC;

-- Q9. Sales Channel Performance and Profitability Comparison

--Compare online and physical-store sales channels based on revenue, 
--delivered orders, unique customers, average order value and gross profit.


SELECT o.sales_channel,
COUNT(DISTINCT o.order_id) AS deli_orders,
ROUND( SUM( oi.quantity * oi.unit_price *(1 - COALESCE(oi.discount_pct, 0)
	/ 100.0) ), 2) AS revenue,
COUNT(DISTINCT o.customer_id) AS uniq_cust,
ROUND( SUM( oi.quantity * oi.unit_price *(1 - COALESCE(oi.discount_pct, 0) 
	/ 100.0) ) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2 ) AS avG_order_value,
ROUND( SUM( oi.quantity * ( oi.unit_price * (1 - COALESCE(oi.discount_pct, 0) 
/ 100.0) - oi.unit_cost ) ), 2) AS gross_profit,
ROUND(100.0 * SUM(oi.quantity * ( oi.unit_price *(1 - COALESCE(oi.discount_pct, 0) 
/ 100.0) - oi.unit_cost ) ) / NULLIF(SUM(oi.quantity * oi.unit_price *
(1 - COALESCE(oi.discount_pct, 0) / 100.0) ), 0 ), 2 ) AS g_m_pct
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.sales_channel
ORDER BY revenue DESC;

-- Q10. Data Quality Audit and Validation

--Identify duplicate records, missing values, orders without 
--items and invalid return quantities to assess database reliability.

SELECT
    customer_name,
    city,
    state,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_name, city, state
HAVING COUNT(*) > 1;

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM orders o
LEFT JOIN order_items oi
    ON oi.order_id = o.order_id
WHERE oi.order_item_id IS NULL
ORDER BY o.order_id;

SELECT order_id,customer_id, order_date,order_status,sales_channel, 
expected_date, delivery_date
FROM orders
WHERE customer_id IS NULL
   OR order_date IS NULL
   OR order_status IS NULL
   OR sales_channel IS NULL
   OR expected_date IS NULL
   OR (order_status = 'Delivered' AND delivery_date IS NULL)
   OR ( delivery_date IS NOT NULL AND delivery_date < order_date )
ORDER BY order_id;

SELECT oi.order_item_id,  oi.product_id,
oi.quantity as purchased,
SUM(r.quantity_returned) as returned
FROM order_items oi
INNER JOIN returns r ON oi.order_item_id = r.order_item_id
GROUP BY oi.order_item_id, oi.product_id
HAVING SUM(r.quantity_returned) > oi.quantity
ORDER BY oi.order_item_id;
