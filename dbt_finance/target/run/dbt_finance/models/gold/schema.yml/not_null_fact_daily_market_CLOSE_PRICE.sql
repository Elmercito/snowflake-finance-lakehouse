
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CLOSE_PRICE
from FINANCE_LAKEHOUSE.GOLD.fact_daily_market
where CLOSE_PRICE is null



  
  
      
    ) dbt_internal_test