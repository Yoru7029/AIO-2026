with payment_summary as (
    select
        order_id,
        count(*) as payment_record_count,
        sum(payment_value) as total_payment_value,
        avg(payment_installments) as avg_installments
    from {{ ref('stg_payments') }}
    group by order_id
),

payment_type_value as (
    select
        order_id,
        payment_type,
        sum(payment_value) as payment_type_value,
        row_number() over (
            partition by order_id
            order by sum(payment_value) desc, payment_type
        ) as rn
    from {{ ref('stg_payments') }}
    group by order_id, payment_type
)

select
    summary.order_id,
    summary.payment_record_count,
    summary.total_payment_value,
    main_type.payment_type as main_payment_type,
    round(summary.avg_installments::numeric, 2) as avg_installments
from payment_summary as summary
left join payment_type_value as main_type
    on summary.order_id = main_type.order_id
   and main_type.rn = 1
