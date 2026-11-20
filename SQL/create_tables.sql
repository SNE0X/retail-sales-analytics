
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price NUMERIC(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(10, 2)
);

CREATE TABLE returns (
    return_id BIGINT PRIMARY KEY,
    order_item_id INTEGER,
    return_date DATE,
    quantity_returned INTEGER,
    return_reason VARCHAR(100),
    refund_amount NUMERIC(12,2)
);

INSERT INTO returns
(return_id, order_item_id, return_date, quantity_returned, return_reason, refund_amount)
VALUES
(1, 2, '2026-01-15', 1, 'Damaged product', 765.00),
(2, 8, '2026-02-12', 2, 'Wrong item', 1200.00),
(3, 12, '2026-02-28', 1, 'Quality issue', 250.00),
(4, 20, '2026-03-30', 2, 'Customer changed mind', 216.00),
(5, 30, '2026-05-25', 1, 'Damaged product', 450.00);