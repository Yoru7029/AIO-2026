-- Business rule: the total payment for each order must equal
-- item revenue plus freight value.
-- A singular dbt test passes when this query returns 0 rows.

select
    order_id,
    order_revenue,
    freight_value,
    total_payment_value,
    total_payment_value - (order_revenue + freight_value) as payment_difference
from {{ ref('mart_orders') }}
where total_payment_value is null
   or abs(
        total_payment_value - (order_revenue + freight_value)
   ) > 0.01
