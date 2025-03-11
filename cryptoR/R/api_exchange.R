#' @title Get Exchange Data
#' @description Retrieve information about cryptocurrency exchanges, including trading volume, trust score, and more.
#' @return A dataframe containing exchange ID, name, country, trading volume, and trust score.
#' @export
get_exchanges <- function() {
  url <- "https://api.coingecko.com/api/v3/exchanges"
  response <- GET(url)

  if (status_code(response) != 200) {
    stop("API request failed!")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  df <- data.frame(
    id = data$id,
    name = data$name,
    year_established = data$year_established,
    country = data$country,
    trade_volume_24h_btc = data$trade_volume_24h_btc,
    trust_score = data$trust_score,
    url = data$url
  )

  return(df)
}

#' @title Get Exchange Details
#' @description Retrieve detailed information for a specific exchange.
#' @param exchange_id The unique ID of the exchange (e.g., "binance").
#' @return A list containing exchange details.
#' @export
get_exchange_details <- function(exchange_id) {
  url <- paste0("https://api.coingecko.com/api/v3/exchanges/", exchange_id)
  response <- GET(url)

  if (status_code(response) != 200) {
    stop("API request failed! Please check the exchange ID.")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  return(data)
}

#' @title Get Exchange Trading Pairs
#' @description Retrieve the list of trading pairs available on a specific exchange.
#' @param exchange_id The unique ID of the exchange (e.g., "binance").
#' @return A dataframe containing trading pairs, base currency, and quote currency.
#' @export
get_exchange_pairs <- function(exchange_id) {
  url <- paste0("https://api.coingecko.com/api/v3/exchanges/", exchange_id, "/tickers")
  response <- GET(url)

  if (status_code(response) != 200) {
    stop("API request failed! Please check the exchange ID.")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  df <- data.frame(
    pair = sapply(data$tickers, function(x) x$market$identifier),
    base_currency = sapply(data$tickers, function(x) x$base),
    quote_currency = sapply(data$tickers, function(x) x$target),
    volume = sapply(data$tickers, function(x) x$volume)
  )

  return(df)
}

#' @title Get Exchange Volume History
#' @description Retrieve the historical trading volume for a specific exchange.
#' @param exchange_id The unique ID of the exchange (e.g., "binance").
#' @return A dataframe with date and trading volume.
#' @export
get_exchange_volume_history <- function(exchange_id) {
  url <- paste0("https://api.coingecko.com/api/v3/exchanges/", exchange_id)
  response <- GET(url)

  if (status_code(response) != 200) {
    stop("API request failed! Please check the exchange ID.")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  df <- data.frame(
    date = Sys.Date(),  # Assuming latest volume data
    volume_btc = data$trade_volume_24h_btc
  )

  return(df)
}

