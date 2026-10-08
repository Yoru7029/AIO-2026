with payment_agg as (
    select
        payment_type,
        count(distinct order_id) as order_count,
        count(*) as payment_record_count,
        sum(payment_value) as payment_value,
        round(avg(payment_installments)::numeric, 2) as avg_installments
    from {{ ref('stg_payments') }}
    group by payment_type
)

select
    payment_type,
    order_count,
    payment_record_count,
    payment_value,
    avg_installments,
    round(100.0 * payment_value / nullif(sum(payment_value) over (), 0), 2) as pct_of_total_payment,
    rank() over (order by payment_value desc) as payment_value_rank
from payment_agg
order by payment_value_rank
