select
    product_id,
    lower(product_category_name) as product_category_name
from {{ source('raw', 'raw_products') }}
