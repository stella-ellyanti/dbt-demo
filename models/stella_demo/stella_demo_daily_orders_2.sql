-- Build table using ref

with source_data as (

    select
      created_date_utc,
      count(*) AS count_order
    from {{ ref("stella_demo_customer_daily_orders") }}
    group by 1
)

select *
from source_data