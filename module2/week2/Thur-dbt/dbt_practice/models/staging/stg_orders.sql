select
    order_id,
    customer_id,
    lower(order_status) as order_status,
    nullif(order_purchase_timestamp, '')::timestamp as order_purchase_timestamp,
    nullif(order_approved_at, '')::timestamp as order_approved_at,
    nullif(order_delivered_customer_date, '')::timestamp as order_delivered_customer_date,
    nullif(order_estimated_delivery_date, '')::timestamp as order_estimated_delivery_date,
    nullif(order_purchase_timestamp, '')::date as order_purchase_date,
    date_trunc('month', nullif(order_purchase_timestamp, '')::timestamp)::date as order_month
from {{ source('raw', 'raw_orders') }}
