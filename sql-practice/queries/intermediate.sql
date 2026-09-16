-- 30 INTERMEDIATE SQL PRACTICE QUESTIONS
-- 1. Join products with categories and show category names.
SELECT categories.name FROM categories
INNER JOIN products on categories.id = products.category_id;

-- 2. Join products with suppliers.
SELECT products.id, suppliers.name, products.name FROM suppliers
INNER JOIN products on suppliers.id = products.supplier_id;

-- 3. Show each user and number of orders.
SELECT u.id, u.name, COUNT(o.user_id) as total_order FROM users AS u
JOIN orders AS o ON u.id = o.user_id GROUP BY u.id;


-- 4. Show users with more than 5 orders.
SELECT u.id, u.name, COUNT(o.user_id) AS total_order FROM users AS u
JOIN orders AS o ON u.id = o.user_id GROUP BY u.id
HAVING COUNT(o.user_id) > 5;


-- 5. Find total revenue by order status.
SELECT SUM(o.total_amount), status FROM orders AS o
GROUP BY status;


-- 6. Find total revenue by city.
SELECT SUM(o.total_amount), shipping_city FROM orders AS o
GROUP BY shipping_city;

-- 7. Find average order value by city.
SELECT AVG(o.total_amount), shipping_city FROM orders AS o
GROUP BY shipping_city;

-- 8. Find top 10 users by spending.
SELECT user_id, u.name, SUM(total_amount) as amount FROM orders
JOIN users AS u ON u.id = user_id
GROUP BY user_id
ORDER BY amount DESC LIMIT 10;

-- 9. Find top 10 products by units sold.
SELECT 
      oi.product_id as product_id, 
      p.name, 
      SUM(oi.quantity) as units 
FROM order_items AS oi
JOIN products AS p ON p.id = oi.product_id
GROUP BY product_id
ORDER BY units DESC
LIMIT 10;

-- 10. Find categories with average product price > 2000.
SELECT 
      c.name as category, 
      AVG(p.price) as avgPrice 
FROM products AS p
JOIN categories AS c ON category_id = c.id
GROUP BY category
HAVING avgPrice > 2000
ORDER BY avgPrice ASC;

-- 11. Find suppliers with more than 5 products.
SELECT
      p.supplier_id,
      su.name AS supplier_name,
      COUNT(p.supplier_id) AS product
FROM products AS p
JOIN suppliers AS su ON p.supplier_id = su.id
GROUP BY supplier_id
HAVING product > 5
ORDER BY product ASC;


-- 12. Find products never ordered.
SELECT
      p.id,
      p.name,
      oi.product_id
FROM products AS p
LEFT JOIN order_items AS oi ON p.id = oi.product_id
WHERE oi.product_id IS NULL;

-- 13. Find users who never placed an order.
SELECT
      u.id,
      u.name
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.user_id
WHERE o.user_id IS NULL;

-- 14. Find products with no reviews.
SELECT
      p.id,
      p.name,
      rw.product_id
FROM products AS p
LEFT JOIN reviews AS rw ON p.id = rw.product_id
WHERE rw.product_id IS NULL;

-- 15. Find average rating per product.
SELECT
      rw.product_id AS product_id,
      p.name AS product_name,
      AVG(rw.rating) AS avg
FROM reviews AS rw
JOIN products AS p on p.id = rw.product_id
GROUP BY product_id;

-- 16. Find products whose average review rating > 4.
SELECT
      rw.product_id AS product_id,
      p.name AS product_name,
      ROUND(AVG(rw.rating), 2) AS avg
FROM reviews AS rw
JOIN products AS p on p.id = rw.product_id
GROUP BY product_id
HAVING avg > 4
ORDER BY avg ASC;

-- 17. Find the most used payment method.
SELECT
      pym.payment_method,
      COUNT(pym.payment_method) AS method_count
FROM payments AS pym
GROUP BY pym.payment_method
ORDER BY method_count DESC
LIMIT 1;

-- 18. Find monthly order counts.
SELECT
      DATE_FORMAT(order_date, '%Y-%m') AS month,
      COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month ASC;

-- 19. Find monthly revenue.
SELECT
      DATE_FORMAT(o.order_date, '%Y-%m') AS month,
      SUM(o.total_amount) AS revenue
FROM orders AS o
GROUP BY month
ORDER BY month ASC;

-- 20. Find customers who ordered in both 2024 and 2025.
SELECT user_id, u.name
FROM orders
JOIN users AS u ON u.id = user_id
WHERE EXTRACT(YEAR FROM order_date) IN (2024, 2025)
GROUP BY user_id, u.name;

-- 21. Find users with at least one cancelled order.
SELECT o.user_id, u.name, COUNT(*) AS total_orders
FROM orders AS o
JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'cancelled'
GROUP BY o.user_id
HAVING total_orders >= 1

-- 22. Find users whose every order was delivered.

SELECT DISTINCT user_id
FROM orders
WHERE user_id NOT IN (
    SELECT user_id 
    FROM orders 
    WHERE status <> 'delivered' OR status IS NULL
);


-- 23. Find duplicate review combinations (user_id, product_id).
SELECT user_id, product_id
FROM reviews
GROUP BY user_id, product_id
HAVING COUNT(*) > 1;

WITH Duplicates AS (
    SELECT user_id, product_id
    FROM reviews
    GROUP BY user_id, product_id
    HAVING COUNT(*) > 1
)
SELECT r.*
FROM reviews r
JOIN Duplicates d 
  ON r.user_id = d.user_id 
 AND r.product_id = d.product_id;


-- 24. Find the second highest product price.
SELECT * FROM products
ORDER BY price DESC
LIMIT 1
OFFSET 1;

SELECT MAX(price) AS sh
FROM products
WHERE price < (SELECT MAX(price) FROM products);

SELECT price
FROM (
    SELECT
        price,
        DENSE_RANK() OVER (ORDER BY price DESC) AS rnk
    FROM products
) t
WHERE rnk = 2;

-- 25. Find the third highest order amount.
SELECT total_amount
FROM (
    SELECT
        total_amount,
        DENSE_RANK() OVER (ORDER BY total_amount DESC) AS rnk
    FROM orders
) t
WHERE rnk = 3;

-- 26. Find each supplier's most expensive product.
SELECT supplier_id, s.name, MAX(price)
FROM products
JOIN suppliers AS s ON s.id = supplier_id
GROUP BY supplier_id;

-- 27. Find each category's cheapest product.
SELECT category_id, c.name, MIN(price)
FROM products
JOIN categories AS c ON c.id = category_id
GROUP BY category_id;

-- 28. Find products with stock below average stock.
SELECT id, name, stock_qty
FROM products
WHERE stock_qty < (SELECT ROUND(AVG(stock_qty), 0) AS avg
FROM products);

-- 29. Find orders containing more than 3 different products.
SELECT order_id, COUNT(DISTINCT product_id) as count
FROM order_items
GROUP BY order_id
HAVING count > 3;

-- 30. Find customers whose spending is above the average customer spending.

SELECT user_id, u.name
FROM orders
JOIN users AS u ON u.id = user_id
WHERE total_amount > (SELECT ROUND(AVG(total_amount), 0) AS avg
FROM orders);
