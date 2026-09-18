-- 30 ADVANCED SQL PRACTICE QUESTIONS
-- 1. Rank customers by total spending.
SELECT
      user_id,
      SUM(total_amount),
      DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rnk
FROM orders
GROUP BY user_id

-- 2. Find top 3 customers per city by spending.
SELECT user_id, shipping_city, total_spending
FROM (
    SELECT
        user_id,
        shipping_city,
        SUM(total_amount) AS total_spending,
        DENSE_RANK() OVER (
            PARTITION BY shipping_city
            ORDER BY SUM(total_amount) DESC
        ) AS rnk
    FROM orders
    GROUP BY user_id, shipping_city
) ranked_users
WHERE rnk <= 3;


-- 3. Find top 3 products per category by revenue.

SELECT
      product_id,
      product_name,
      category,
      category_id,
      revenue
FROM (
      SELECT
            p.id AS product_id,
            p.name AS product_name,
            c.name AS category,
            p.category_id AS category_id,
            SUM(oi.quantity * oi.unit_price) AS revenue,
            DENSE_RANK() OVER(
                  PARTITION BY p.category_id
                  ORDER BY SUM(oi.quantity * oi.unit_price) DESC
            ) AS rnk
      FROM order_items 
            AS oi
      JOIN products 
            AS p
            ON oi.product_id = p.id
      JOIN categories 
            AS c
            ON c.id = p.category_id
      GROUP BY
            p.id,
            p.name,
            c.name,
            p.category_id
) t
WHERE rnk <=3

-- 4. Calculate running monthly revenue.
SELECT
    month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY month
    ) AS running_revenue
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS revenue
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) AS monthly_revenue
ORDER BY month;


-- 5. Calculate month-over-month revenue growth.
-- 6. Find each user's first order.
-- 7. Find each user's second order.
-- 8. Calculate days between first and second order.
-- 9. Find customers with increasing order values over time.
-- 10. Find customers whose latest order is larger than their first order.
-- 11. Find the percentage of orders that were cancelled.
-- 12. Find each product's revenue contribution percentage.
-- 13. Find the Pareto-style top 20% products by revenue.
-- 14. Find users who purchased every product in a category.
-- 15. Find products purchased by users from at least 5 different cities.
-- 16. Find the most popular product for every month.
-- 17. Find the longest gap between orders for every customer.
-- 18. Find customers with orders in 3 consecutive months.
-- 19. Find products whose rating is above their category average.
-- 20. Find suppliers whose product average price is above the global average.
-- 21. Find inventory items that need restocking.
-- 22. Find the percentage of inventory value held by each warehouse.
-- 23. Find the best-selling product in each warehouse.
-- 24. Find users who bought a product and later reviewed it.
-- 25. Find users who reviewed products they never purchased.
-- 26. Find orders where item totals do not approximately match order total.
-- 27. Find duplicate emails or suspicious duplicate customer records.
-- 28. Use a recursive CTE to display category hierarchy.
-- 29. Use window functions to find the first/last product bought in each order.
-- 30. Build a customer cohort table by signup month and first-order month.