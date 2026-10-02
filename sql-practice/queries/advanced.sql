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
SELECT
    month,
    revenue,
    prv_rev,
    ROUND(((revenue - prv_rev) / prv_rev) * 100, 2) AS per
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS revenue,
        LAG(SUM(total_amount)) OVER (
            ORDER BY DATE_FORMAT(order_date, '%Y-%m')
        ) AS prv_rev
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) AS monthly_revenue
ORDER BY month;

-- 6. Find each user's first order.
SELECT 
      user_id,
      u.name AS name,
      min(order_date) AS first_order
FROM orders
JOIN users u ON u.id = user_id
GROUP BY user_id, name

-- 7. Find each user's second order.
SELECT
      user_id,
      u.name,
      order_date
FROM (
      SELECT
            user_id,
            order_date,
        DENSE_RANK() OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS rnk
    FROM orders
) t
JOIN users u ON u.id = user_id
WHERE rnk = 1;

-- 8. Calculate days between first and second order.
SELECT 
    user_id,
    u.name,
    MAX(CASE WHEN row_num = 1 THEN order_date END) AS first_order,
    MAX(CASE WHEN row_num = 2 THEN order_date END) AS second_order,
    DATEDIFF(MAX(CASE WHEN row_num = 2 THEN order_date END), MAX(CASE WHEN row_num = 1 THEN order_date END)) AS diff
FROM (
    SELECT
        user_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS row_num
    FROM orders
    WHERE status = 'delivered'
) t
JOIN users u ON user_id = u.id
GROUP BY user_id
HAVING diff IS NOT NULL

-- 9. Find customers with increasing order values over time.
SELECT
    user_id,
    u.name
FROM (
    SELECT 
        user_id,
        total_amount,
        order_date,
        LAG(total_amount) OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS previous_amount
    FROM orders
) t
JOIN users u ON u.id = user_id
GROUP BY user_id
HAVING SUM(
    CASE
        WHEN previous_amount IS NOT NULL
             AND total_amount <= previous_amount
        THEN 1
        ELSE 0
    END
) = 0

-- 10. Find customers whose latest order is larger than their first order.
SELECT 
    user_id,
    u.name,
    MAX(CASE WHEN row_num = 1 THEN total_amount END) AS first_order,
    MAX(CASE WHEN row_num = total_orders THEN total_amount END) AS latest_order
FROM (
    SELECT
        user_id,
        total_amount,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS row_num,
        COUNT(*) OVER (
            PARTITION BY user_id
        ) AS total_orders
    FROM orders
)t
JOIN users u ON u.id = user_id
GROUP BY user_id
HAVING first_order < latest_order

-- 11. Find the percentage of orders that were cancelled.
SELECT 
    COUNT(CASE 
        WHEN status = 'cancelled' THEN 1 END) AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(CASE 
        WHEN status = 'cancelled' THEN 1 END) * 100 / COUNT(*)
        ,2) AS cancelled_order_percentage
FROM
orders

-- 12. Find each product's revenue contribution percentage.
SELECT
    product_id,
    product_revenue,
    ROUND(product_revenue * 100 / total_revenue, 2) AS revenue_contribution_percentage
FROM (
    SELECT
        product_id,
        SUM(quantity*unit_price) AS product_revenue,
        SUM(SUM(quantity*unit_price)) OVER() AS total_revenue
    FROM order_items
    GROUP BY product_id
)t

-- 13. Find the Pareto-style top 20% products by revenue.
WITH ProductRevenue AS (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS product_revenue,
        PERCENT_RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS revenue_rank_percent
    FROM order_items
    GROUP BY product_id
)
SELECT 
    product_id,
    product_revenue,
    revenue_rank_percent
FROM ProductRevenue
WHERE revenue_rank_percent <= 0.20;

WITH product_revenue AS (
    SELECT
        product_id,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM order_items
    GROUP BY product_id
),
ranked_products AS (
    SELECT
        product_id,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC, product_id
        ) AS rn,
        COUNT(*) OVER () AS total_products
    FROM product_revenue
)
SELECT
    product_id,
    ROUND(revenue, 2) AS revenue
FROM ranked_products
WHERE rn <= CEIL(total_products * 0.20)
ORDER BY revenue DESC;

-- 14. Find users who purchased every product in a category.
SELECT
    DISTINCT(u.id) AS user_id,
    u.name
FROM users u
CROSS JOIN (
    SELECT DISTINCT category_id
    FROM products
) c
JOIN orders o
    ON o.user_id = u.id
JOIN order_items oi
    ON oi.order_id = o.id
JOIN products p
    ON p.id = oi.product_id
   AND p.category_id = c.category_id
GROUP BY u.id, u.name, c.category_id
HAVING COUNT(DISTINCT p.id) = (
    SELECT COUNT(*)
    FROM products p2
    WHERE p2.category_id = c.category_id
);


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