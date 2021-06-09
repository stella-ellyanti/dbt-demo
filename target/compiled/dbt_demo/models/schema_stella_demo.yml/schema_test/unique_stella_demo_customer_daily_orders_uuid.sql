
    
    



select count(*) as validation_errors
from (

    select
        uuid

    from `dhh---analytics-apac-staging`.`pandata_intermediate`.`stella_demo_customer_daily_orders`
    where uuid is not null
    group by uuid
    having count(*) > 1

) validation_errors


