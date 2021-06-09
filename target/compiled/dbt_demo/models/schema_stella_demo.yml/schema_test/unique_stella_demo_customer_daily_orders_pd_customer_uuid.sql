
    
    



select count(*) as validation_errors
from (

    select
        pd_customer_uuid

    from `dhh---analytics-apac-staging`.`pandata_intermediate`.`stella_demo_customer_daily_orders`
    where pd_customer_uuid is not null
    group by pd_customer_uuid
    having count(*) > 1

) validation_errors


