DROP SCHEMA IF EXISTS ecommerce CASCADE;
CREATE SCHEMA ecommerce;
SET search_path TO ecommerce;

CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(180) UNIQUE NOT NULL,
  gender VARCHAR(20),
  birth_date DATE,
  city VARCHAR(80),
  country VARCHAR(80),
  signup_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL
);

CREATE TABLE addresses (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  address_type VARCHAR(20) NOT NULL,
  line1 VARCHAR(200) NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80),
  postal_code VARCHAR(20),
  country VARCHAR(80),
  is_default BOOLEAN NOT NULL
);

CREATE TABLE categories (
  id BIGINT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  parent_category_id BIGINT REFERENCES categories(id),
  is_active BOOLEAN NOT NULL
);

CREATE TABLE suppliers (
  id BIGINT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  city VARCHAR(80),
  country VARCHAR(80),
  rating NUMERIC(3,2),
  joined_date DATE,
  status VARCHAR(20)
);

CREATE TABLE products (
  id BIGINT PRIMARY KEY,
  category_id BIGINT NOT NULL REFERENCES categories(id),
  supplier_id BIGINT NOT NULL REFERENCES suppliers(id),
  name VARCHAR(180) NOT NULL,
  sku VARCHAR(40) UNIQUE NOT NULL,
  price NUMERIC(12,2) NOT NULL,
  cost_price NUMERIC(12,2) NOT NULL,
  stock_qty INT NOT NULL,
  rating NUMERIC(3,2),
  created_at DATE NOT NULL,
  status VARCHAR(20)
);

CREATE TABLE inventory (
  id BIGINT PRIMARY KEY,
  product_id BIGINT UNIQUE NOT NULL REFERENCES products(id),
  warehouse VARCHAR(80) NOT NULL,
  quantity INT NOT NULL,
  reorder_level INT NOT NULL,
  last_restocked DATE
);

CREATE TABLE orders (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  order_date TIMESTAMP NOT NULL,
  status VARCHAR(30) NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  shipping_city VARCHAR(80),
  coupon_code VARCHAR(30)
);

CREATE TABLE order_items (
  id BIGINT PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES orders(id),
  product_id BIGINT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL,
  unit_price NUMERIC(12,2) NOT NULL,
  discount NUMERIC(5,2) NOT NULL
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY,
  order_id BIGINT UNIQUE NOT NULL REFERENCES orders(id),
  payment_method VARCHAR(30) NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  payment_date TIMESTAMP,
  status VARCHAR(30) NOT NULL
);

CREATE TABLE shipments (
  id BIGINT PRIMARY KEY,
  order_id BIGINT UNIQUE NOT NULL REFERENCES orders(id),
  carrier VARCHAR(50),
  tracking_number VARCHAR(80),
  shipped_date DATE,
  delivered_date DATE,
  status VARCHAR(30)
);

CREATE TABLE reviews (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  product_id BIGINT NOT NULL REFERENCES products(id),
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title VARCHAR(150),
  review_text TEXT,
  created_at DATE NOT NULL
);

CREATE TABLE coupons (
  id BIGINT PRIMARY KEY,
  code VARCHAR(30) UNIQUE NOT NULL,
  discount_percent INT NOT NULL,
  min_order_amount NUMERIC(10,2),
  max_discount NUMERIC(10,2),
  start_date DATE,
  end_date DATE,
  usage_limit INT,
  status VARCHAR(20)
);

CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
