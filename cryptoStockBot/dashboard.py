from dash import Dash, dcc, html
import pandas as pd
import plotly.express as px
from crypto_bot import fetch_crypto_prices, fetch_stock_price

app = Dash(__name__)

#fetch data
crypto_data = fetch_crypto_prices()
stock_price = fetch_stock_price("AAPL")

#prepare data
df = pd.DataFrame({
    "Asset": ["Bitcoin","Ethereum","Apple"],
    "Price (USD)": [
        crypto_data["bitcoin"]["usd"],
        crypto_data["ethereum"]["usd"],
        stock_price
    ]
})

#create chart
fig = px.bar(df, x="Asset", y="Price (USD)", title="Asset Prices")

app.layout = html.Div([
    html.H1("Crypto and Stock Price Tracker"),
    dcc.Graph(figure=fig)
])

if __name__ == "__main__":
    app.run_server(debug=True)
