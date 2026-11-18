-- Tabla de hechos. Granularidad: una fila por item de pedido.
with items as (
    select * from {{ ref('stg_olist__order_items') }}
),

orders as (
    select * from {{ ref('stg_olist__orders') }}
),

customers as (
    select customer_id, customer_unique_id from {{ ref('stg_olist__customers') }}
)

select
    items.order_id || '-' || items.order_item_id::text as order_item_key,
    items.order_id,
    items.order_item_id,
    customers.customer_unique_id,
    items.product_id,
    items.seller_id,
    orders.purchased_at::date as purchased_date,
    orders.order_status,
    items.price,
    items.freight_value,
    items.price + items.freight_value as item_total,
    orders.delivered_to_customer_at,
    orders.estimated_delivery_at,
    case
        when orders.delivered_to_customer_at is null then null
        else orders.delivered_to_customer_at > orders.estimated_delivery_at
    end as is_late
from items
inner join orders on orders.order_id = items.order_id
inner join customers on customers.customer_id = orders.customer_id
