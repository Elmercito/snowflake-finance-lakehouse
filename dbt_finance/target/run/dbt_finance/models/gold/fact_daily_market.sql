
  
    

create or replace transient table FINANCE_LAKEHOUSE.GOLD.fact_daily_market
    
    
    
    
    

    as (SELECT 
    st.STOCK_KEY,
    TO_NUMBER(TO_CHAR(s.TRADE_DATE, 'YYYYMMDD')) AS DATE_KEY,
    s.CLOSE_PRICE,
    s.VOLUME,
    s.DAILY_RETURN_PCT
FROM FINANCE_LAKEHOUSE.SILVER.stg_stock_prices s
JOIN FINANCE_LAKEHOUSE.GOLD.dim_stocks st ON s.TICKER = st.TICKER
    )
;


  