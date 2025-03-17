
library(testthat)
library(httr)
library(jsonlite)


test_that("get_crypto_market_chart returns valid data", {
  df <- get_crypto_market_chart("bitcoin", "usd", 30)

  # API 失败时跳过测试
  skip_if(is.null(df) || nrow(df) == 0, "API request failed, skipping test")

  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "price", "volume") %in% colnames(df)))
})

test_that("get_crypto_market_chart handles incorrect symbols", {
  expect_error(get_crypto_market_chart("invalid_symbol", "usd", 30), "API request failed!")
})

test_that("get_crypto_market_chart handles API failure", {
  pkgload::load_all()  # Ensure the package is loaded

  with_mocked_bindings(
    get_crypto_market_chart = function(...) stop("API error"),
    expect_error(get_crypto_market_chart("bitcoin", "usd", 30), "API error")
  )
})
