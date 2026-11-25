SELECT 
    st.STOCK_KEY,
    TO_NUMBER(TO_CHAR(s.TRADE_DATE, 'YYYYMMDD')) AS DATE_KEY,
    s.CLOSE_PRICE,
    s.VOLUME,
    s.DAILY_RETURN_PCT
FROM {{ ref('stg_stock_prices') }} s
JOIN {{ ref('dim_stocks') }} st ON s.TICKER = st.TICKER
