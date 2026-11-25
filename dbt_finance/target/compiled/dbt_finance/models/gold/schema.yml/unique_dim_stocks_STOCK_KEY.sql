
    
    

select
    STOCK_KEY as unique_field,
    count(*) as n_records

from FINANCE_LAKEHOUSE.GOLD.dim_stocks
where STOCK_KEY is not null
group by STOCK_KEY
having count(*) > 1


