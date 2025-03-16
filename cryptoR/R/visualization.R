# ==============================
# 1  Retracement Ratio
# ==============================
#' @title Plot Retracement Ratio
#' @description Visualize retracement ratio over time.
#' @param data A dataframe with at least `date` and `price` columns.
#' @export
plot_retracement <- function(data) {
  if (!"price" %in% colnames(data)) {
    stop("Error: The dataset must contain a `price` column.")
  }

  if (all(is.na(data$price))) {
    stop("Error: All `price` values are NA. Cannot compute retracement ratio.")
  }

  max_price <- max(data$price, na.rm = TRUE)

  if (max_price == 0) {
    stop("Error: The maximum price value is 0, invalid for retracement calculation.")
  }

  if (!"retrace_ratio" %in% colnames(data)) {
    data <- data %>%
      arrange(date) %>%
      mutate(retrace_ratio = price / max_price)
  }

  data_clean <- data %>% filter(!is.na(retrace_ratio))

  ggplot(data_clean, aes(x = date, y = retrace_ratio)) +
    geom_line(color = "red", linewidth = 1) +
    labs(title = "Retracement Ratio Over Time", x = "Date", y = "Retracement Ratio") +
    theme_minimal()
}

# ==============================
# 2  Capital Flow
# ==============================
#' @title Plot Capital Flow
#' @description Visualize capital flow as a bar chart.
#' @param data A dataframe with at least `date`, `price`, and `volume` columns.
#' @export
plot_capital_flow <- function(data) {
  if (!"capital_flow" %in% colnames(data)) {
    if ("price" %in% colnames(data) && "volume" %in% colnames(data)) {
      data <- data %>%
        arrange(date) %>%
        mutate(
          price_change = price - lag(price),
          capital_flow = price_change * volume
        )
    } else {
      stop("Error: Data must contain `price` and `volume` columns.")
    }
  }
  data_clean <- data %>% filter(!is.na(capital_flow))

  ggplot(data_clean, aes(x = date, y = capital_flow, fill = capital_flow > 0)) +
    geom_bar(stat = "identity", show.legend = FALSE) +
    scale_fill_manual(values = c("red", "green")) +
    labs(title = "Capital Flow Over Time", x = "Date", y = "Capital Flow") +
    theme_minimal()
}

# ==============================
#  3  Market Price with Moving Average
# ==============================
#' @title Plot Market Price with Moving Average
#' @description Overlay price and moving average in one chart.
#' @param data A dataframe with `date` and `price` columns.
#' @param n Number of days for moving average (default: 14).
#' @export
plot_market_with_ma <- function(data, n = 14) {
  if (!"ma" %in% colnames(data)) {
    data <- data %>%
      arrange(date) %>%
      mutate(ma = TTR::SMA(price, n))
  }

  data_clean <- data %>% filter(!is.na(ma))

  ggplot(data_clean, aes(x = date)) +
    geom_line(aes(y = price, color = "Price"), linewidth = 1, alpha = 0.5) +
    geom_line(aes(y = ma, color = "Moving Average"), linewidth = 1) +
    scale_color_manual(values = c("Price" = "blue", "Moving Average" = "red")) +
    labs(title = paste(n, "-day Moving Average"), x = "Date", y = "Price (USD)", color = "Legend") +
    theme_minimal()
}

# ==============================
# 4  Bollinger Bands
# ==============================
#' @title Plot Bollinger Bands
#' @description Visualize Bollinger Bands for crypto price data.
#' @param data A dataframe with `date` and `price` columns.
#' @param n Number of periods for Bollinger Bands (default: 20).
#' @export
plot_bollinger_bands <- function(data, n = 20) {
  if (!"middle_band" %in% colnames(data) || !"upper_band" %in% colnames(data) || !"lower_band" %in% colnames(data)) {
    bands <- TTR::BBands(data$price, n = n)
    data <- data %>%
      arrange(date) %>%
      mutate(
        middle_band = bands[, "mavg"],
        upper_band = bands[, "up"],
        lower_band = bands[, "dn"]
      )
  }

  data_clean <- data %>% filter(!is.na(middle_band))

  ggplot(data_clean, aes(x = date)) +
    geom_line(aes(y = price), color = "blue", linewidth = 1, alpha = 0.5) +
    geom_line(aes(y = middle_band), color = "red", linewidth = 1) +
    geom_ribbon(aes(ymin = lower_band, ymax = upper_band), fill = "gray", alpha = 0.2) +
    labs(title = "Bollinger Bands", x = "Date", y = "Price (USD)") +
    theme_minimal()
}

# plot_market_with_ma(btc_data, 50)

# plot_retracement(btc_data)

# plot_capital_flow(btc_data)

# plot_bollinger_bands(btc_data, 20)
