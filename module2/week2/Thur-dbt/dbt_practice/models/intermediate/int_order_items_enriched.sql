select
    items.order_id,
    items.order_item_id,
    items.product_id,
    products.product_category_name,
    items.seller_id,
    items.price,
    items.freight_value,
    items.price as item_revenue,
    items.price + items.freight_value as item_total_with_freight
from {{ ref('stg_order_items') }} as items
left join {{ ref('stg_products') }} as products
    on items.product_id = products.product_id
