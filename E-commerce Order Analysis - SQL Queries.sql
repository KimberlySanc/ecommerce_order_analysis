
-- 1. Analyze total product revenue contribution by customer gender.
 
SELECT customer_gender, SUM(gross_sales_amount) as total_gross_revenue
FROM order_info
GROUP BY customer_gender
ORDER BY total_gross_revenue DESC;

-- 2. Evaluate the impact of membership status by comparing average order value, total revenue
-- and number of transactions between different membership tiers.

SELECT membership_status, ROUND(AVG(gross_sales_amount),2) as average_revenue, 
SUM(gross_sales_amount) as total_revenue, COUNT (DISTINCT order_id) as number_of_orders
FROM order_info
GROUP BY membership_status
ORDER BY average_revenue DESC, total_revenue DESC, number_of_orders DESC;

-- 3. Identify the top three best-selling product subcategories within each product category.
WITH product_rank AS (
SELECT product_category, product_subcategory, SUM(gross_sales_amount) AS total_revenue,
ROW_NUMBER() OVER(PARTITION BY product_category ORDER BY SUM(gross_sales_amount)DESC) AS row_num
FROM order_info
GROUP BY product_category, product_subcategory)

SELECT product_category, product_subcategory, total_revenue
FROM product_rank
WHERE row_num <= 3;

-- 4. Assess revenue and profit performance across customer age segments.
SELECT age_group, SUM(gross_sales_amount) as total_revenue, ROUND(SUM(profit_amount)::numeric, 2) as total_profit
FROM order_info
GROUP BY age_group;

-- 5. Determine which marketing traffic sources generate the highest revenue by age group
WITH traffic_revenue_rank as (
SELECT age_group, traffic_source, SUM(gross_sales_amount) as total_revenue, 
ROW_NUMBER() OVER(PARTITION BY age_group ORDER BY SUM(gross_sales_amount)DESC) as revenue_rank
FROM order_info
GROUP BY age_group, traffic_source)

SELECT age_group, traffic_source, total_revenue
FROM traffic_revenue_rank
WHERE revenue_rank = 1;


-- 6. Identify customers who utilized discounts while maintaining above-average purchase amounts.
SELECT customer_id, order_amount, discount_amount
FROM order_info
WHERE LOWER(coupon_used) = 'yes' AND order_amount >= (SELECT AVG(order_amount) FROM order_info);
										

-- 7. Identify the top five products with the highest average customer review ratings.
SELECT product_id, ROUND(AVG(review_rating)::numeric, 2) as avg_rating
FROM order_info
GROUP BY product_id
ORDER BY avg_rating DESC
LIMIT 5;

-- 8. Compare average order values across shipping methods to evaluate purchasing behavior.
SELECT shipping_method, ROUND(AVG(gross_sales_amount),2) as gross_revenue, COUNT(order_id) as total_orders
FROM order_info
GROUP BY shipping_method;

-- 9. Identify product subcategories with the highest dependency on discounts by calculating the percentage of discounted purchases.
SELECT product_subcategory, ROUND(100 * SUM(CASE WHEN coupon_used = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as coupon_rate
FROM order_info
GROUP BY product_subcategory
ORDER BY coupon_rate DESC;

-- 10. Analyze the relationship between customer lifetime value tiers and average order value.
SELECT customer_lifetime_value_tier, ROUND(AVG (gross_sales_amount),2) as average_order_value
FROM order_info
GROUP BY customer_lifetime_value_tier;






