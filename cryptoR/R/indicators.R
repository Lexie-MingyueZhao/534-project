# R/indicators.R

library(dplyr)
library(TTR)
library(ggplot2)

# ==============================
# (Moving Average, MA)
# ==============================
#' @title Calculate Moving Average
#' @description Calculate Moving Average (MA) for crypto price data
#' @param data A dataframe with at least `date` and `price` columns
#' @param n Number of days for moving average (default: 14)
#' @param plot If TRUE, plot the price and moving average (default: TRUE)
#' @return A dataframe with an additional `ma` column
#' @export
calculate_ma <- function(data, n = 14, plot = TRUE) {
  data <- data %>%
    arrange(date) %>%
    mutate(ma = TTR::SMA(price, n))

  data_clean <- data %>% filter(!is.na(ma))

  if (plot) {
    p <- ggplot(data_clean, aes(x = date)) +
      geom_line(aes(y = price, color = "Price"), linewidth = 1, alpha = 0.5) +
      geom_line(aes(y = ma, color = "Moving Average"), linewidth = 1) +
      scale_color_manual(values = c("Price" = "blue", "Moving Average" = "red")) +
      labs(title = paste(n, "-day Moving Average"), x = "Date", y = "Price (USD)", color = "Legend") +
      theme_minimal()

    print(p)
  }

  return(data_clean)
}
#btc_ma_100 <- calculate_ma(btc_data, 100)
# ==============================
#  (Relative Strength Index, RSI)
# ==============================
#' @title Calculate RSI
#' @description Calculate Relative Strength Index (RSI) for crypto price data
#' @param data A dataframe with at least `date` and `price` columns
#' @param n Number of periods for RSI calculation (default: 14)
#' @return A dataframe with an additional `rsi` column
#' @export
calculate_rsi <- function(data, n = 14) {
  data <- data %>%
    arrange(date) %>%
    mutate(rsi = TTR::RSI(price, n)) %>%
    filter(!is.na(rsi))

  print(head(data, 10))
  return(data)
}
#btc_rsi <- calculate_rsi(btc_data, 14)
# ==============================
#  (Support & Resistance)
# ==============================
#' @title Calculate Support and Resistance Levels
#' @description Compute rolling min/max to approximate support & resistance levels
#' @param data A dataframe with at least `date` and `price` columns
#' @param window Number of periods for rolling calculation (default: 20)
#' @return A dataframe with additional `support` and `resistance` columns
#' @export
calculate_support_resistance <- function(data, window = 20) {
  data <- data %>%
    arrange(date) %>%
    mutate(
      support = zoo::rollapply(price, window, min, fill = NA, align = "right"),
      resistance = zoo::rollapply(price, window, max, fill = NA, align = "right")
    ) %>%
    filter(!is.na(support))

  print(head(data, 10))
  return(data)
}
#btc_support_resistance <- calculate_support_resistance(btc_data, 20)
# ==============================
#   (Bollinger Bands)
# ==============================
#' @title Calculate Bollinger Bands
#' @description Compute Bollinger Bands for crypto price data
#' @param data A dataframe with at least `date` and `price` columns
#' @param n Number of periods for Bollinger Bands (default: 20)
#' @return A dataframe with additional `middle_band`, `upper_band`, `lower_band` columns
#' @export
calculate_bollinger_bands <- function(data, n = 20) {
  bands <- TTR::BBands(data$price, n = n)

  data <- data %>%
    arrange(date) %>%
    mutate(
      middle_band = bands[, "mavg"],
      upper_band = bands[, "up"],
      lower_band = bands[, "dn"]
    ) %>%
    filter(!is.na(middle_band))

  print(head(data, 10))
  return(data)
}
#btc_bbands <- calculate_bollinger_bands(btc_data, 20)
# ==============================
#  Calculate Historical Volatility (Historical Volatility)
# ==============================

#' @title Calculate Historical Volatility
#' @description Computes the annualized historical volatility for a given cryptocurrency.
#' @param symbol A character string representing the cryptocurrency symbol (e.g., "bitcoin").
#' @param days An integer specifying the number of past days to consider (default: 30).
#' @return A numeric value representing the annualized volatility.
#' @export
get_historical_volatility <- function(symbol, days = 30) {
  data <- get_crypto_market_chart(symbol, "usd", days)

  df <- data %>%
    arrange(date) %>%
    mutate(log_return = log(price / lag(price))) %>%
    filter(!is.na(log_return))

  volatility <- sd(df$log_return, na.rm = TRUE) * sqrt(365)

  message(sprintf("The %d-day historical volatility for %s is: %.4f", days, symbol, volatility))

  return(volatility)
}
#eth_volatility <- get_historical_volatility("ethereum", 60)
# ==============================
# Calculate Retracement Ratio (Retracement Ratio)
# ==============================

#' @title Calculate Retracement Ratio
#' @description Computes the retracement ratio for a given cryptocurrency.
#' @param data A dataframe with at least `date` and `price` columns.
#' @return A dataframe with an additional `retrace_ratio` column.
#' @export
calculate_retracement <- function(data) {
  data <- data %>%
    arrange(date) %>%
    mutate(retrace_ratio = price / max(price, na.rm = TRUE))

  print(head(data, 10))
  return(data)
}
#btc_retrace <- calculate_retracement(btc_data)
# ==============================
# Calculate Capital Flow(Capital Flow)
# ==============================

#' @title Calculate Capital Flow
#' @description Computes the estimated capital flow based on price changes and volume.
#' @param data A dataframe with at least `date`, `price`, and `volume` columns.
#' @return A dataframe with an additional `capital_flow` column.
#' @export
calculate_capital_flow <- function(data) {
  data <- data %>%
    arrange(date) %>%
    mutate(
      price_change = price - lag(price),
      capital_flow = price_change * volume
    ) %>%
    filter(!is.na(capital_flow))

  print(head(data, 10))
  return(data)
}
#btc_capital_flow <- calculate_capital_flow(btc_data)
#' @title Get Top Exchanges by Trading Volume
#' @description Retrieve the top cryptocurrency exchanges ranked by 24-hour trading volume.
#' @param top_n Number of exchanges to return (default: 10).
#' @return A dataframe with exchange ID, name, country, and 24-hour trading volume.
#' @export
get_top_exchanges <- function(top_n = 10) {
  df <- get_exchanges()
  df <- df %>% arrange(desc(trade_volume_24h_btc)) %>% head(top_n)

  return(df)
}
