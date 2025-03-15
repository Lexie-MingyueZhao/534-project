library(testthat)
library(httr)
library(jsonlite)

test_that("get_exchanges() returns a valid data frame", {
  result <- get_exchanges()

  expect_s3_class(result, "data.frame")  # it's adata frame
  expect_true(nrow(result) > 0)  # not empty
  expect_true("id" %in% names(result))  # id exists
  expect_true("name" %in% names(result))  #name exists
  expect_true("trade_volume_24h_btc" %in% names(result))  # trading volume field exists
})

test_that("get_exchange_details() returns a valid list", {
  result <- get_exchange_details("Binance")  #  Using Binance as an example
  expect_type(result, "list")  # return list
  expect_true("id" %in% names(result))  #  id exist
  expect_true("name" %in% names(result))  #  name exist
})

test_that("get_exchange_details() handles invalid exchange ID", {
  expect_error(get_exchange_details("invalid_exchange"), "API request failed!")  # should return error
})

test_that("get_exchange_pairs() returns a valid data frame", {
  result <- get_exchange_pairs("Binance")
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true("pair" %in% names(result))
  expect_true("base_currency" %in% names(result))
})

test_that("get_exchange_pairs() handles invalid exchange ID", {
  expect_error(get_exchange_pairs("invalid_exchange"), "API request failed!")
})

test_that("get_exchange_volume_history() returns a valid data frame", {
  Sys.sleep(10)
  result <- get_exchange_volume_history("Binance")  #

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) == 1)
  expect_true("date" %in% names(result))
  expect_true("volume_btc" %in% names(result))
})
