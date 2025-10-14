-- Check row counts
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM order_events;

SELECT 'customers', COUNT(*) FROM customers;

SELECT 'feedback', COUNT(*) FROM feedback;

-- Check event_type distribution in order_events
SELECT event_type, COUNT(*) AS count
FROM order_events
GROUP BY event_type;

-- Verify username derivation in customers
SELECT email, username
FROM customers
WHERE username != COALESCE(SPLIT_PART(email, '@', 1), 'unknown_username')
LIMIT 10;