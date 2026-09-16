-- 30 BEGINNER SQL PRACTICE QUESTIONS
-- 1. List all users.
SELECT * FROM users;

-- SELECT
--     id,
--     name,
--     email,
--     city,
--     country,
--     signup_date,
--     status
-- FROM users;

-- 2. Find users from Bengaluru.
SELECT * FROM users WHERE city = "Bengaluru";

-- SELECT *
-- FROM users
-- WHERE city = 'Bengaluru'
--   AND status = 'active';

-- 3. Find products priced above 5000.
SELECT * FROM products WHERE price > 5000;

-- SELECT
--     id,
--     name,
--     price
-- FROM products
-- WHERE price > 5000
-- ORDER BY price DESC;


-- 4. Find products with stock below 20.
SELECT * FROM products WHERE stock_qty < 20;

-- SELECT
--     id,
--     name,
--     stock_qty
-- FROM products
-- WHERE stock_qty < 20
-- ORDER BY stock_qty ASC;

-- 5. Count users.
SELECT COUNT(*) FROM users;

-- SELECT COUNT(*) AS total_users
-- FROM users;

-- 6. Count products.
SELECT COUNT(*) FROM products;

-- SELECT COUNT(*) AS total_products
-- FROM products;

-- 7. Find the cheapest product.
SELECT * FROM products ORDER BY price ASC LIMIT 1;

-- But here's an important interview concept

-- What if two products have the same cheapest price?

-- Your query returns only one.

-- If the question means "Find all products having the minimum price", use:

-- SELECT
--     id,
--     name,
--     price
-- FROM products
-- WHERE price = (
--     SELECT MIN(price)
--     FROM products
-- );

-- 8. Find the most expensive product.
SELECT * FROM products ORDER BY price DESC LIMIT 1;

-- SELECT
--     id,
--     name,
--     price
-- FROM products
-- WHERE price = (
--     SELECT MAX(price)
--     FROM products
-- );

-- 9. Find average product price.
SELECT AVG(price) as avg_price FROM products;

-- 10. Find orders above 10000.
SELECT * FROM orders WHERE total_amount > 10000;

-- 11. Count orders by status.
SELECT
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- 12. Count products by status.
SELECT
    status,
    COUNT(*) AS product_count
FROM products
GROUP BY status;

-- 13. Find users who signed up after 2025-01-01.
SELECT
    id,
    name,
    email,
    signup_date
FROM users
WHERE signup_date > '2025-01-01'
ORDER BY signup_date ASC;

-- 14. Find products with rating >= 4.5.
SELECT
    id,
    name,
    rating
FROM products
WHERE rating >= 4.5
ORDER BY rating DESC;


-- 15. Find orders from a particular city.
SELECT
    id,
    user_id,
    order_date,
    shipping_city,
    total_amount,
    status
FROM orders
WHERE shipping_city = 'Pune'
ORDER BY order_date DESC;

-- 16. Find distinct payment methods.
SELECT DISTINCT(payment_method) FROM payments;

-- 17. Find total payment amount.
SELECT
    SUM(amount) AS total_payment_amount
FROM payments;

-- 18. Find maximum order amount.
SELECT
    MAX(total_amount) AS maximum_order_amount
FROM orders;

-- 19. Find minimum order amount.
SELECT
    MIN(total_amount) AS minimum_order_amount
FROM orders;

-- 20. Find average review rating.
SELECT
    ROUND(AVG(rating), 2) AS average_review_rating
FROM reviews;

-- 21. Find reviews with rating 5.

-- 22. Sort products by price descending.
-- 23. Return the top 10 most expensive products.
-- 24. Return the 10 cheapest products.
-- 25. Count users by city.
-- 26. Count products by category_id.
-- 27. Count orders by user_id.
-- 28. Find suppliers with rating > 4.5.
-- 29. Find inventory below reorder_level.
-- 30. Find active coupons.
