
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select STOCK_KEY
from FINANCE_LAKEHOUSE.GOLD.fact_daily_market
where STOCK_KEY is null



  
  
      
    ) dbt_internal_test