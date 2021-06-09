-- Materialise table / view with using underlying table

{{ config(materialized='table') }}

with source_data as (

    select
      created_date_utc,
      count(*) AS count_order
    from `fulfillment-dwh-production.pandata_curated.pd_orders`
    where created_date_utc >= date_sub(current_date, interval 2 day)
      and global_entity_id = 'FP_SG'
    group by 1
)

select *
from source_data