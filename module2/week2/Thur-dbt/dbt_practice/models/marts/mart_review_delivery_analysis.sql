select
    delivery_status,
    count(*) as order_count,
    round(avg(review_score)::numeric, 2) as avg_review_score,
    sum(case when review_score <= 2 then 1 else 0 end) as low_review_count,
    round(
        100.0 * sum(case when review_score <= 2 then 1 else 0 end)
        / nullif(count(*), 0),
        2
    ) as low_review_rate_pct
from {{ ref('mart_orders') }}
where review_score is not null
group by delivery_status
order by avg_review_score desc
