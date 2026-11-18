-- Falla si algun item tiene precio o flete negativo.
select
    order_item_key,
    price,
    freight_value
from {{ ref('fct_order_items') }}
where price < 0 or freight_value < 0
