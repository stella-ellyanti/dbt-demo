
with dbt__CTE__INTERNAL_test as (
select
    uuid,
    SUM(count_orders) AS count_orders
from `dhh---analytics-apac-staging`.`pandata_intermediate`.`stella_demo_customer_daily_orders`
group by 1
having not count_orders >= 0
)select count(*) from dbt__CTE__INTERNAL_test