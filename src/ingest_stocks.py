import os
import yfinance as yf
import pandas as pd
from datetime import datetime, timezone
from snowflake.snowpark import Session

# Lecture sécurisée des identifiants depuis les variables d'environnement
connection_parameters = {
    "account": os.environ["SNOWFLAKE_ACCOUNT"],
    "user": os.environ["SNOWFLAKE_USER"],
    "password": os.environ["SNOWFLAKE_PASSWORD"],
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "FINANCE_LAKEHOUSE",
    "schema": "BRONZE"
}

TICKERS = ["RY.TO", "TD.TO", "BMO.TO", "AAPL", "MSFT", "JPM"]

def extract_stock_data(tickers, period="5d"):
    # En production quotidienne, on télécharge uniquement les 5 derniers jours
    all_data = []
    ingested_time = datetime.now(timezone.utc).replace(tzinfo=None)

    for ticker in tickers:
        df = yf.Ticker(ticker).history(period=period)
        if df.empty:
            continue
        df = df.reset_index()
        clean_df = pd.DataFrame({
            "TICKER": ticker,
            "TRADE_DATE": pd.to_datetime(df["Date"]).dt.date,
            "OPEN_PRICE": df["Open"],
            "HIGH_PRICE": df["High"],
            "LOW_PRICE": df["Low"],
            "CLOSE_PRICE": df["Close"],
            "VOLUME": df["Volume"].astype("int64"),
            "INGESTED_AT": ingested_time
        })
        all_data.append(clean_df)

    return pd.concat(all_data, ignore_index=True)

if __name__ == "__main__":
    df_stocks = extract_stock_data(TICKERS, period="5d")
    print(f" {len(df_stocks)} lignes extraites.")

    session = Session.builder.configs(connection_parameters).create()
    try:
        session.write_pandas(
            df=df_stocks,
            table_name="STOCK_PRICES_RAW",
            database="FINANCE_LAKEHOUSE",
            schema="BRONZE",
            auto_create_table=False,
            overwrite=False
        )
        print("Chargement réussi dans BRONZE. SILVER et GOLD suivront automatiquement.")
    finally:
        session.close()
