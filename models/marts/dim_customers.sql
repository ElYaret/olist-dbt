-- Una fila por persona (customer_unique_id), con los datos de su compra mas reciente.
with customers as (
    select * from {{ ref('stg_olist__customers') }}
),

orders as (
    select customer_id, purchased_at from {{ ref('stg_olist__orders') }}
),

ranked as (
    select
        customers.customer_unique_id,
        customers.zip_code_prefix,
        customers.city,
        customers.state,
        row_number() over (
            partition by customers.customer_unique_id
            order by orders.purchased_at desc nulls last, customers.customer_id
        ) as recency_rank
    from customers
    left join orders on orders.customer_id = customers.customer_id
)

select
    customer_unique_id,
    zip_code_prefix,
    city,
    state
from ranked
where recency_rank = 1
