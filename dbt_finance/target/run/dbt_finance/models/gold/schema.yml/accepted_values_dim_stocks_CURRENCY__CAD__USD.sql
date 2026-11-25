
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        CURRENCY as value_field,
        count(*) as n_records

    from FINANCE_LAKEHOUSE.GOLD.dim_stocks
    group by CURRENCY

)

select *
from all_values
where value_field not in (
    'CAD','USD'
)



  
  
      
    ) dbt_internal_test