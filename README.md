# Crypto Screener R Package(534 Project)

[![R-CI](https://github.com/Lexie-MingyueZhao/534-project/actions/workflows/R-CI.yml/badge.svg)](https://github.com/Lexie-MingyueZhao/534-project/actions)

This package is designed for **traders, analysts, and researchers** looking to filter assets based on **market cap,liquidity, volatility, and key investment metrics**. It leverages the **CoinGecko API** to retrieve **real-time and historical data**, apply **investment indicators**,and generate **visual insights** for better decision-making.

------------------------------------------------------------------------

## Key Features

### 1. **Data Retrieval (Market & Exchange Data)**

-   `get_exchanges()`: Retrieve exchange information.

-   `get_crypto_market_chart( symbol, currency, days)`:Get market price and volume data.

### 2. **Technical Indicators**

-   `calculate_ma(data, n)`: Moving Average

-   `calculate_rsi(data, n)`: Relative Strength Index (RSI)

-   `calculate_bollinger_bands(data, n)`: Bollinger Bands

### 3. **Visualization**

-   `plot_market_with_ma(data, n)`: Price & MA Chart

-   `plot_bollinger_bands(data, n)`: Bollinger Bands Chart

------------------------------------------------------------------------

## [**Vignettes**](https://github.com/Lexie-MingyueZhao/534-project/tree/main/vignettes)

------------------------------------------------------------------------

## Contributors:

-   Wenjun Cheng

-   Jieyi Yao

-   Mingyue Zhao
