library(testthat)
library(dplyr)
library(TTR)
library(ggplot2)


# create data
set.seed(534)
test_data <- data.frame(
  date = seq(as.Date("2023-01-01"), by = "day", length.out = 100),
  price = cumsum(runif(100, min = -5, max = 5)) + 50,  # price change
  volume = runif(100, min = 1000, max = 10000)
)

# ==============================
#  (Moving Average, MA)
# ==============================
test_that("calculate_ma() returns correct structure", {
  df <- calculate_ma(test_data, n = 14, plot = FALSE)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "price", "ma") %in% colnames(df)))
  expect_s3_class(df$date, "Date")
  expect_type(df$ma, "double")
  expect_false(any(is.na(df$ma)))  # make sure no NA
})

# ==============================
#(Relative Strength Index, RSI)
# ==============================
test_that("calculate_rsi() returns correct structure", {
  df <- calculate_rsi(test_data, n = 14)

  expect_s3_class(df, "data.frame")
  expect_true("rsi" %in% colnames(df))
  expect_type(df$rsi, "double")
  expect_false(any(is.na(df$rsi)))
})

# ==============================
#(Support & Resistance)
# ==============================
test_that("calculate_support_resistance() returns correct structure", {
  df <- calculate_support_resistance(test_data, window = 20)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("support", "resistance") %in% colnames(df)))
  expect_type(df$support, "double")
  expect_type(df$resistance, "double")
  expect_false(any(is.na(df$support)))
  expect_false(any(is.na(df$resistance)))
})

# ==============================
# (Bollinger Bands)
# ==============================
test_that("calculate_bollinger_bands() returns correct structure", {
  df <- calculate_bollinger_bands(test_data, n = 20)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("middle_band", "upper_band", "lower_band") %in% colnames(df)))
  expect_type(df$middle_band, "double")
  expect_type(df$upper_band, "double")
  expect_type(df$lower_band, "double")
  expect_false(any(is.na(df$middle_band)))
})

# ==============================
#  (Historical Volatility)
# ==============================
test_that("get_historical_volatility() returns a numeric value", {
  expect_type(get_historical_volatility("bitcoin", 30), "double")
})

# ==============================
#  (Retracement Ratio)
# ==============================
test_that("calculate_retracement() returns correct structure", {
  df <- calculate_retracement(test_data)

  expect_s3_class(df, "data.frame")
  expect_true("retrace_ratio" %in% colnames(df))
  expect_type(df$retrace_ratio, "double")
})

# ==============================
# (Capital Flow)
# ==============================
test_that("calculate_capital_flow() returns correct structure", {
  df <- calculate_capital_flow(test_data)

  expect_s3_class(df, "data.frame")
  expect_true("capital_flow" %in% colnames(df))
  expect_type(df$capital_flow, "double")
})

# ==============================
#  (Top Exchanges)
# ==============================
test_that("get_top_exchanges() returns a data frame", {
  df <- get_top_exchanges(5)

  expect_s3_class(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_true(all(c("id", "name", "country", "trade_volume_24h_btc") %in% colnames(df)))
})
