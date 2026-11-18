-- Una fila por producto, con la categoria en ingles cuando existe la traduccion.
select
    products.product_id,
    products.product_category_name as category_name_pt,
    coalesce(
        translation.product_category_name_english,
        products.product_category_name,
        'unknown'
    ) as category_name,
    products.product_weight_g,
    products.product_length_cm,
    products.product_height_cm,
    products.product_width_cm,
    products.product_photos_qty
from {{ ref('stg_olist__products') }} as products
left join {{ ref('stg_olist__product_category_translation') }} as translation
    on translation.product_category_name = products.product_category_name
