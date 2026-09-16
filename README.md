# SQL + MongoDB Practice Database

## Scale

SQL:
- users: 10,000
- addresses: 15,000
- categories: 10,000
- suppliers: 10,000
- products: 10,000
- inventory: 10,000
- orders: 12,000
- order_items: 36,000
- payments: 12,000
- shipments: 12,000
- reviews: 20,000
- coupons: 10,000

MongoDB has the same collection sizes and logical relationships.

## SQL

Recommended: PostgreSQL.

1. Create a database, e.g. `practice_db`.
2. Run `schema.sql`.
3. Run `seed.sql`.

Example:

    psql -d practice_db -f sql-practice/schema.sql
    psql -d practice_db -f sql-practice/seed.sql

## MongoDB

Start MongoDB, then:

    mongosh mongodb://localhost:27017/mongo_practice mongodb-practice/seed.js

## Practice order

1. beginner
2. intermediate
3. advanced
4. Solve the same problem in SQL and MongoDB.
5. Add indexes and compare EXPLAIN / explain("executionStats").

## Important note

The generated seed data intentionally contains independent/randomized business values, so order totals and item totals are not guaranteed to match. That gives you useful data for data-quality queries too.
