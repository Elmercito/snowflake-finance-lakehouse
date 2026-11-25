
    
    

with child as (
    select STOCK_KEY as from_field
    from FINANCE_LAKEHOUSE.GOLD.fact_daily_market
    where STOCK_KEY is not null
),

parent as (
    select STOCK_KEY as to_field
    from FINANCE_LAKEHOUSE.GOLD.dim_stocks
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


