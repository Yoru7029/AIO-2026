select
    order_month,
    count(*) filter (where delivery_status in ('On Time', 'Late')) as delivered_orders,
    sum(case when delivery_status = 'Late' then 1 else 0 end) as late_orders,
    sum(case when delivery_status = 'On Time' then 1 else 0 end) as on_time_orders,
    round(
        100.0 * sum(case when delivery_status = 'Late' then 1 else 0 end)
        / nullif(count(*) filter (where delivery_status in ('On Time', 'Late')), 0),
        2
    ) as late_rate_pct,
    round(avg(delivery_days) filter (where delivery_status in ('On Time', 'Late'))::numeric, 2) as avg_delivery_days,
    round(avg(delay_days) filter (where delivery_status = 'Late')::numeric, 2) as avg_delay_days
from {{ ref('mart_orders') }}
group by order_month
order by order_month
