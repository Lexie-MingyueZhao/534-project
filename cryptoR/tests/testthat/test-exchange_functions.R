library(testthat)
library(httr)
library(jsonlite)

test_that("get_exchanges() returns a valid data frame", {
  result <- tryCatch(
    get_exchanges(),
    error = function(e) {
      message("API request failed: ", e$message)
      return(NULL)
    }
  )

  expect_true(!is.null(result), "API request failed, check API status")
  expect_s3_class(result, "data.frame")  # Must be a data frame
  expect_true(nrow(result) > 0)  # Ensure it's not empty
  expect_true(all(c("id", "name", "trade_volume_24h_btc") %in% names(result)))  # Required fields exist
})

test_that("get_exchange_details() returns a valid list", {
  result <- get_exchange_details("binance")

  # API 失败时跳过测试
  skip_if(is.null(result), "API request failed, skipping test")

  expect_type(result, "list")
  expect_true(all(c("id", "name") %in% names(result)))
})

test_that("get_exchange_details() handles invalid exchange ID", {
  expect_error(get_exchange_details("invalid_exchange"), "API request failed!")
})

test_that("get_exchange_pairs() returns a valid data frame", {
  df <- tryCatch(
    get_exchange_pairs("Binance"),
    error = function(e) {
      message("API request failed: ", e$message)
      return(NULL)
    }
  )

  # 如果 API 失败，跳过测试
  skip_if(is.null(df), "API request failed, skipping test")

  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})

test_that("get_exchange_pairs() handles invalid exchange ID", {
  expect_error(get_exchange_pairs("invalid_exchange"), "API request failed!")
})

test_that("get_exchange_volume_history() returns a valid data frame", {
  result <- tryCatch(
    get_exchange_volume_history("Binance"),
    error = function(e) {
      message("API request failed: ", e$message)
      return(NULL)
    }
  )

  skip_if(is.null(result), "API request failed, skipping test")

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true(all(c("date", "volume_btc") %in% names(result)))
})
