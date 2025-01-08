import requests
import yfinance as yf

def fetch_crypto_prices():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {"ids": "bitcoin,ethereum", "vs_currencies": "usd"}
    response = requests.get(url, params=params)
    return response.json()

def fetch_stock_price(ticker):
    stock = yf.Ticker(ticker)
    data = stock.history(period="1d")
    return data["Close"].iloc[-1]

if __name__ == "__main__":
    print("Cryptocurrency Prices:", fetch_crypto_prices())
    print("Apple Stock Price:", fetch_stock_price("AAPL"))

#automatic updater
import schedule
import time


def job():
    print("Fetching data...")
    print("Cryptocurrency Prices:", fetch_crypto_prices())
    print("Apple Stock Price:", fetch_stock_price("AAPL"))

schedule.every(10).minutes.do(job)

while True:
    schedule.run_pending()
    time.sleep(1)