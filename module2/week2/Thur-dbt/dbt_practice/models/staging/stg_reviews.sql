select
    review_id,
    order_id,
    review_score
from {{ source('raw', 'raw_reviews') }}
