with monthly as (
    select
        order_month,
        count(distinct order_id) as order_count,
        count(distinct customer_id) as customer_count,
        sum(order_revenue) as revenue,
        sum(freight_value) as freight_value,
        round(sum(order_revenue) / nullif(count(distinct order_id), 0), 2) as avg_order_value,
        round(avg(review_score)::numeric, 2) as avg_review_score
    from {{ ref('mart_orders') }}
    where order_status = 'delivered'
    group by order_month
),

with_windows as (
    select
        order_month,
        order_count,
        customer_count,
        revenue,
        freight_value,
        avg_order_value,
        avg_review_score,
        lag(revenue) over (order by order_month) as prev_month_revenue,
        sum(revenue) over (
            order by order_month
            rows between unbounded preceding and current row
        ) as running_revenue
    from monthly
)

select
    order_month,
    order_count,
    customer_count,
    revenue,
    freight_value,
    avg_order_value,
    avg_review_score,
    prev_month_revenue,
    round(100.0 * (revenue - prev_month_revenue) / nullif(prev_month_revenue, 0), 2) as revenue_growth_pct,
    running_revenue
from with_windows
order by order_month
