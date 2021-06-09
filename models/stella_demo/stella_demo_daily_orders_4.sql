-- Macros

-- Get unique business_type_apac from pd_vendors_agg_business_types 
-- using package dbt_utils
-- get_column_values returns the unique values for a column in a given relation
{% set business_types = 
  dbt_utils.get_column_values(
  	table=source("pandata_curated", "pd_vendors_agg_business_types"), 
  	column='business_type_apac'
  )
%}

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
  	{{ minutes_to_hours('delivery_time_in_minutes') }}
  ) AS avg_delivery_time_in_hour,

  -- Macro 2: Loops
  {% for business_type in business_types %}
  count(distinct if(business_type_apac = '{{ business_type }}', id, NULL)) 
    as total_{{ business_type }}_orders_recent,
  {% endfor %}

from {{ source("pandata_curated", "pd_orders") }} as orders
left join {{ source("pandata_curated", "pd_vendors") }} as vendors
       on orders.pd_vendor_uuid = vendors.uuid
left join {{ source("pandata_curated", "pd_vendors_agg_business_types") }} as vendor_types
       on vendors.uuid = vendor_types.uuid
where orders.created_date_utc >= date_sub(current_date, interval 2 day)
  and orders.global_entity_id = 'FP_SG'
group by pd_customer_uuid
