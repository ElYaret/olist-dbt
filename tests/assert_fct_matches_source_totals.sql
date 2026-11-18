-- Falla si el total de precios de la tabla de hechos no coincide con el de staging.
select
    fct.total_fct,
    stg.total_staging
from (select sum(price) as total_fct from {{ ref('fct_order_items') }}) as fct
cross join (select sum(price) as total_staging from {{ ref('stg_olist__order_items') }}) as stg
where fct.total_fct <> stg.total_staging
