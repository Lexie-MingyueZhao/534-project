library(testthat)
library(dplyr)
library(httr)
library(jsonlite)
library(TTR)
library(ggplot2)

test_that("Full workflow runs without errors", {
  # Step 1: Fetch market data
  df <- get_crypto_market_chart("bitcoin", "usd", 30)

  # Ensure data is retrieved correctly
  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "price", "volume") %in% colnames(df)))

  # Step 2: Compute technical indicators
  df <- calculate_ma(df, n = 14, plot = FALSE)
  df <- calculate_rsi(df, n = 14)
  df <- calculate_bollinger_bands(df, n = 20)

  # Ensure new columns exist
  expect_true(all(c("ma", "rsi", "middle_band", "upper_band", "lower_band") %in% colnames(df)))

  # Step 3: Fetch exchange data
  exchanges <- get_top_exchanges(5)
  expect_s3_class(exchanges, "data.frame")
  expect_gt(nrow(exchanges), 0)

  # Step 4: Run visualization functions (just to check they don’t throw errors)
  expect_s3_class(plot_market_with_ma(df, n = 14), "ggplot")
  expect_s3_class(plot_bollinger_bands(df, n = 20), "ggplot")
})
