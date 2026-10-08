with category_base as (
    select
        items.product_category_name,
        items.order_id,
        items.order_item_id,
        items.price,
        items.freight_value,
        items.item_revenue
    from {{ ref('int_order_items_enriched') }} as items
    inner join {{ ref('stg_orders') }} as orders
        on items.order_id = orders.order_id
    where orders.order_status = 'delivered'
),

category_agg as (
    select
        product_category_name,
        count(distinct order_id) as order_count,
        count(*) as item_count,
        sum(item_revenue) as revenue,
        sum(freight_value) as freight_value,
        round(avg(price)::numeric, 2) as avg_item_price
    from category_base
    group by product_category_name
)

select
    product_category_name,
    order_count,
    item_count,
    revenue,
    freight_value,
    avg_item_price,
    round(100.0 * revenue / nullif(sum(revenue) over (), 0), 2) as pct_of_total_revenue,
    rank() over (order by revenue desc) as category_rank
from category_agg
order by category_rank
