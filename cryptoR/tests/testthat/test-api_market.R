
library(testthat)
library(httr)
library(jsonlite)


test_that("get_crypto_market_chart returns a valid data frame", {
  df <- get_crypto_market_chart("bitcoin", "usd", 30)

  # Check if df is a data frame
  expect_s3_class(df, "data.frame")

  # Check for required columns
  expect_true(all(c("date", "price", "volume") %in% colnames(df)))

  # Check if the date column is of type Date
  expect_s3_class(df$date, "Date")

  # Check if price and volume columns are numeric
  expect_type(df$price, "double")
  expect_type(df$volume, "double")
})

test_that("get_crypto_market_chart handles incorrect symbols", {
  expect_error(get_crypto_market_chart("invalid_symbol", "usd", 30),
               "API request failed, please check the currency symbol!")
})

test_that("get_crypto_market_chart handles API failure", {
  with_mock(
    `httr::GET` = function(...) {
      structure(list(status_code = 404), class = "response")
    },
    {
      expect_error(get_crypto_market_chart("bitcoin", "usd", 30),
                   "API request failed, please check the currency symbol!")
    }
  )
})
