#' @title Get Crypto Market Chart Data
#' @description Fetch historical crypto market data (price & volume) from CoinGecko API.
#' @param symbol Cryptocurrency symbol (e.g., "bitcoin").
#' @param currency Quoted currency (default: "usd").
#' @param days Number of days of historical data to retrieve (default: 30).
#' @return A dataframe with `date`, `price`, and `volume` columns.
#' @export
get_crypto_market_chart <- function(symbol, currency, days) {
  url <- paste0("https://api.coingecko.com/api/v3/coins/", symbol, "/market_chart?vs_currency=", currency, "&days=", days)
  response <- httr::GET(url)

  if (httr::status_code(response) != 200) {
    stop("API request failed! Please check the currency symbol.")
  }

  data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

  if (is.null(data$prices) || length(data$prices) == 0) {
    stop("No market data available for this symbol.")
  }

  df <- data.frame(
    date = as.Date(as.POSIXct(data$prices[, 1] / 1000, origin = "1970-01-01")),
    price = data$prices[, 2],
    volume = data$total_volumes[, 2]
  )

  return(df)
}
