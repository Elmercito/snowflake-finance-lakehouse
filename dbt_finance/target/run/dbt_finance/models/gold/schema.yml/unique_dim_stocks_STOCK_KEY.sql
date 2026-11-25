
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    STOCK_KEY as unique_field,
    count(*) as n_records

from FINANCE_LAKEHOUSE.GOLD.dim_stocks
where STOCK_KEY is not null
group by STOCK_KEY
having count(*) > 1



  
  
      
    ) dbt_internal_test