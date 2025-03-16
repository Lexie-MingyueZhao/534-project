# Crypto Screener R Package(534 Project)

### Automated Cryptocurrency Market Analysis & Screening

## Overview

The **Crypto Screener R Package** provides a **comprehensive toolset** for analyzing the cryptocurrency market.\
It leverages the **CoinGecko API** to retrieve **real-time and historical data**, apply **investment indicators**,\
and generate **visual insights** for better decision-making.

This package is designed for **traders, analysts, and researchers** looking to filter assets based on **market cap,\
liquidity, volatility, and key investment metrics**.

------------------------------------------------------------------------

## Objectives

The primary goal of this project is to develop an R package that:\
- Fetches real-time & historical **cryptocurrency market data** from APIs.\
- Screens assets based on **market cap, liquidity, volatility, and retracement ratios**.\
- Calculates investment indicators, including **RSI, historical volatility, and Bollinger Bands**.\
- Generates **visual trends** to track market movements.

------------------------------------------------------------------------

## Key Features

### 1. **Data Retrieval Functions**

-   `get_crypto_market_data()` – Fetches **live market data** (price, market cap, volume).\

-   `get_historical_volatility(symbol, days)` – Computes **historical price volatility**.\

-   `get_top_exchanges(n)` – Retrieves **top trading platforms by volume**.

-   `get_crypto_market_chart` – Fetches historical crypto price and volume data from CoinGecko with flexible parameters and structured output.

### 2. **Trend Analysis & Market Indicators**

-   `calculate_ma()` - Computes **Moving Average (MA)** to smooth price fluctuations and detect trends.

-   `calculate_bollinger_bands()` - Computes **Bollinger Bands** to measure price volatility and identify overbought/oversold conditions.

-   `calculate_rsi()` - Computes **Relative Strength Index (RSI)** to assess momentum and potential trend reversals.

-   `calculate_support_resistance()` - Identifies **Support and Resistance Levels**, key price areas for potential reversals.

-   `calculate_retracement()` - Computes **Retracement Ratio**, measuring price pullbacks from recent peaks.

### 3. **Market Data & Flow Analysis**

-   `Retracement Ratio` – Measures **decline from all-time high**.
-   `RSI (Relative Strength Index)` – Evaluates **overbought/oversold** conditions.\
-   `Historical Volatility` – Assesses **risk & market fluctuations**.

### 4. **Visualization Functions**

-   `plot_market_trend(symbol, days)` – **Displays price trends** over time.\
-   `plot_volatility_histogram()` – **Shows the distribution of price volatility**.\
-   `plot_liquidity_vs_market_cap()` – **Compares liquidity and asset size**.

------------------------------------------------------------------------

## Vignettes

------------------------------------------------------------------------

## Examples
