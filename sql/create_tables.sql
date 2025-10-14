-- Customers DDL
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    address JSON
);

--Orders DDL
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    status VARCHAR
);

--Feedback DDL
CREATE TABLE feedback (
    id INTEGER PRIMARY KEY,
    order_id INTEGER UNIQUE REFERENCES orders(id),
    feedback_comment TEXT,
    rating INTEGER
);