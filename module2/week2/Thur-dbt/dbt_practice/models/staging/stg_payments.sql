select
    order_id,
    payment_sequential,
    lower(payment_type) as payment_type,
    payment_installments,
    payment_value::numeric(12, 2) as payment_value
from {{ source('raw', 'raw_payments') }}
