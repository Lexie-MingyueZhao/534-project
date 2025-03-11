#' @title Get Crypto Market Chart Data
#' @description Fetch historical crypto market data (price & volume) from CoinGecko API.
#' @param symbol Cryptocurrency symbol (e.g., "bitcoin").
#' @param currency Quoted currency (default: "usd").
#' @param days Number of days of historical data to retrieve (default: 30).
#' @return A dataframe with `date`, `price`, and `volume` columns.
#' @export
get_crypto_market_chart <- function(symbol, currency = "usd", days = 30) {
  url <- paste0("https://api.coingecko.com/api/v3/coins/", symbol, "/market_chart")

  response <- GET(url, query = list(vs_currency = currency, days = days))

  if (status_code(response) != 200) {
    stop("API request failed, please check the currency symbol!")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  df <- data.frame(
    date = as.Date(as.POSIXct(data$prices[,1] / 1000, origin = "1970-01-01")),
    price = data$prices[,2],
    volume = data$total_volumes[,2]  # Adding trading volume
  )

  return(df)
}

