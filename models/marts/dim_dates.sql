-- Una fila por dia, desde la primera hasta la ultima compra.
with bounds as (
    select
        min(purchased_at)::date as first_day,
        max(purchased_at)::date as last_day
    from {{ ref('stg_olist__orders') }}
),

days as (
    select generate_series(first_day, last_day, interval '1 day')::date as date_day
    from bounds
)

select
    date_day,
    extract(year from date_day)::int    as year_number,
    extract(quarter from date_day)::int as quarter_number,
    extract(month from date_day)::int   as month_number,
    to_char(date_day, 'YYYY-MM')        as year_month,
    extract(isodow from date_day)::int  as iso_day_of_week,  -- 1 = lunes ... 7 = domingo
    extract(isodow from date_day) in (6, 7) as is_weekend
from days
