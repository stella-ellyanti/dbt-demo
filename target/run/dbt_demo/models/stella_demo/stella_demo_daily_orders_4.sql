

  create or replace table `dhh---analytics-apac-staging`.`pandata_intermediate`.`stella_demo_daily_orders_4`
  
  
  OPTIONS()
  as (
    -- Macros

-- Get unique business_type_apac from pd_vendors_agg_business_types 
-- using package dbt_utils
-- get_column_values returns the unique values for a column in a given relation


-- business_types = [
--   'restaurants', 
--   'pandago', 
--   'shops', 
--   'caterers', 
--   'concepts', 
--   'kitchens', 
--   'dmart', 
--   'vouchers'
-- ]

select
  orders.pd_customer_uuid,

  -- Macro 1: minutes_to_hours
  AVG(
  	
  ROUND(delivery_time_in_minutes / 60, precision)

  ) AS avg_delivery_time_in_hour,

  -- Macro 2: Loops
  
  count(distinct if(business_type_apac = 'restaurants', id, NULL)) 
    as total_restaurants_orders_recent,
  
  count(distinct if(business_type_apac = 'pandago', id, NULL)) 
    as total_pandago_orders_recent,
  
  count(distinct if(business_type_apac = 'shops', id, NULL)) 
    as total_shops_orders_recent,
  
  count(distinct if(business_type_apac = 'caterers', id, NULL)) 
    as total_caterers_orders_recent,
  
  count(distinct if(business_type_apac = 'concepts', id, NULL)) 
    as total_concepts_orders_recent,
  
  count(distinct if(business_type_apac = 'kitchens', id, NULL)) 
    as total_kitchens_orders_recent,
  
  count(distinct if(business_type_apac = 'dmart', id, NULL)) 
    as total_dmart_orders_recent,
  
  count(distinct if(business_type_apac = 'vouchers', id, NULL)) 
    as total_vouchers_orders_recent,
  

from `fulfillment-dwh-production`.`pandata_curated`.`pd_orders` as orders
left join `fulfillment-dwh-production`.`pandata_curated`.`pd_vendors` as vendors
       on orders.pd_vendor_uuid = vendors.uuid
left join `fulfillment-dwh-production`.`pandata_curated`.`pd_vendors_agg_business_types` as vendor_types
       on vendors.uuid = vendor_types.uuid
where orders.created_date_utc >= date_sub(current_date, interval 2 day)
  and orders.global_entity_id = 'FP_SG'
group by pd_customer_uuid
  );
    