-- Create ref table for stella_demo_daily_orders_2

{{ config(materialized='view') }}

with source_data as (

    select
      CONCAT(pd_customer_uuid, CAST(created_date_utc AS STRING)) AS uuid,
      pd_customer_uuid,
      created_date_utc,
      count(*) AS count_orders
    from `fulfillment-dwh-production.pandata_curated.pd_orders`
    where created_date_utc >= date_sub(current_date, interval 2 day)
      and global_entity_id = 'FP_SG'
    group by
      uuid,
      pd_customer_uuid,
      created_date_utc
)

select
  *
from source_data