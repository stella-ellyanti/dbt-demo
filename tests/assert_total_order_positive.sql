select
    uuid,
    SUM(count_orders) AS count_orders
from {{ ref('stella_demo_customer_daily_orders') }}
group by 1
having not count_orders >= 0