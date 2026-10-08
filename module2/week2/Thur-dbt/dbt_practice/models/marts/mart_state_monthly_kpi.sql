with state_monthly as (
    select
        order_month,
        customer_state,
        count(distinct order_id) as order_count,
        count(distinct customer_id) as customer_count,
        sum(order_revenue) as revenue,
        round(avg(review_score)::numeric, 2) as avg_review_score
    from {{ ref('mart_orders') }}
    where order_status = 'delivered'
    group by order_month, customer_state
)

select
    order_month,
    customer_state,
    order_count,
    customer_count,
    revenue,
    avg_review_score,
    rank() over (
        partition by order_month
        order by revenue desc
    ) as state_rank_in_month,
    round(
        100.0 * revenue / nullif(sum(revenue) over (partition by order_month), 0),
        2
    ) as pct_of_month_revenue
from state_monthly
order by order_month, state_rank_in_month
