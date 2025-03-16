library(testthat)
library(dplyr)
library(ggplot2)
library(TTR)


# Generate sample data
set.seed(123)
test_data <- data.frame(
  date = seq(as.Date("2023-01-01"), by = "day", length.out = 100),
  price = cumsum(runif(100, min = -5, max = 5)) + 50,  # Simulating price fluctuations
  volume = runif(100, min = 1000, max = 10000)  # Simulating trading volume
)

# Compute required indicators
test_data <- test_data %>%
  arrange(date) %>%
  mutate(
    ma = TTR::SMA(price, 14),
    retrace_ratio = price / max(price, na.rm = TRUE),
    capital_flow = (price - lag(price)) * volume
  )

# ==============================
# 1 (Retracement Ratio Plot)
# ==============================
test_that("plot_retracement() generates a valid ggplot object", {
  p <- plot_retracement(test_data)
  expect_s3_class(p, "ggplot")
})

# ==============================
#  2 (Capital Flow Plot)
# ==============================
test_that("plot_capital_flow() generates a valid ggplot object", {
  p <- plot_capital_flow(test_data)
  expect_s3_class(p, "ggplot")
})

# ==============================
# 3 (Market Price with Moving Average Plot)
# ==============================
test_that("plot_market_with_ma() generates a valid ggplot object", {
  p <- plot_market_with_ma(test_data, n = 14)
  expect_s3_class(p, "ggplot")
})

# ==============================
# 4 (Bollinger Bands Plot)
# ==============================
test_that("plot_bollinger_bands() generates a valid ggplot object", {
  p <- plot_bollinger_bands(test_data, n = 20)
  expect_s3_class(p, "ggplot")
})

# ==============================
# 5 (Error Handling)
# ==============================
test_that("plot_retracement() errors on missing 'price' column", {
  expect_error(plot_retracement(data.frame(date = Sys.Date())), "Error: The dataset must contain a `price` column.")
})

test_that("plot_capital_flow() errors on missing 'price' and 'volume' columns", {
  expect_error(plot_capital_flow(data.frame(date = Sys.Date())), "Error: Data must contain `price` and `volume` columns.")
})
