with item_summary as (
    select
        order_id,
        count(*) as item_count,
        count(distinct product_id) as product_count,
        sum(item_revenue) as order_revenue,
        sum(freight_value) as freight_value
    from {{ ref('int_order_items_enriched') }}
    group by order_id
)

select
    orders.order_id,
    orders.customer_id,
    customers.customer_unique_id,
    customers.customer_city,
    customers.customer_state,
    orders.order_status,
    orders.order_purchase_timestamp,
    orders.order_purchase_date,
    orders.order_month,
    orders.order_delivered_customer_date,
    orders.order_estimated_delivery_date,
    case
        when orders.order_delivered_customer_date is null then null
        else round((extract(epoch from (orders.order_delivered_customer_date - orders.order_purchase_timestamp)) / 86400.0)::numeric, 2)
    end as delivery_days,
    case
        when orders.order_delivered_customer_date is null then null
        else round((extract(epoch from (orders.order_delivered_customer_date - orders.order_estimated_delivery_date)) / 86400.0)::numeric, 2)
    end as delay_days,
    case
        when orders.order_delivered_customer_date is null then 'Not Delivered'
        when orders.order_delivered_customer_date <= orders.order_estimated_delivery_date then 'On Time'
        else 'Late'
    end as delivery_status,
    coalesce(items.item_count, 0) as item_count,
    coalesce(items.product_count, 0) as product_count,
    coalesce(items.order_revenue, 0) as order_revenue,
    coalesce(items.freight_value, 0) as freight_value,
    payments.payment_record_count,
    payments.total_payment_value,
    payments.main_payment_type,
    payments.avg_installments,
    reviews.review_score
from {{ ref('stg_orders') }} as orders
left join {{ ref('stg_customers') }} as customers
    on orders.customer_id = customers.customer_id
left join item_summary as items
    on orders.order_id = items.order_id
left join {{ ref('int_order_payments') }} as payments
    on orders.order_id = payments.order_id
left join {{ ref('stg_reviews') }} as reviews
    on orders.order_id = reviews.order_id
