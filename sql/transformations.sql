-- order_events transformation (Used to create another Table named order_events)
SELECT 
    id AS order_id,
    customer_id,
    CASE 
        WHEN status = 'placed' THEN 'order_placed'
        WHEN status = 'shipped' THEN 'order_shipped'
        WHEN status = 'delivered' THEN 'order_delivered'
        WHEN status = 'cancelled' THEN 'order_cancelled'
        ELSE 'unknown_event'
    END AS event_type,
    CURRENT_TIMESTAMP() AS event_timestamp
FROM PC_HEVO_DB.PUBLIC.orders;

-- customers username validation (used for populating username column)
SELECT 
    id,
    first_name,
    last_name,
    email,
    address,
    COALESCE(SPLIT_PART(email, '@', 1), 'unknown_username') AS username
FROM PC_HEVO_DB.PUBLIC.customers
WHERE email IS NOT NULL AND email LIKE '%@%';