#' @title Get Exchange Data
#' @description Retrieve information about cryptocurrency exchanges, including trading volume, trust score, and more.
#' @return A dataframe containing exchange ID, name, country, trading volume, and trust score.
#' @export
get_exchanges <- function() {
  url <- "https://api.coingecko.com/api/v3/exchanges"
  response <- httr::GET(url)

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
  if (!"id" %in% names(data)) {
    data$id <- exchange_id
  }

  result <- list(
    id = data$id,
    name = data$name,
    year_established = data$year_established,
    country = data$country,
    description = data$description,
    url = data$url,
    image = data$image,
    trust_score = data$trust_score,
    trade_volume_24h_btc = data$trade_volume_24h_btc
  )

  return(result)
}

#' @title Get Exchange Trading Pairs
#' @description Retrieve the list of trading pairs available on a specific exchange.
#' @param exchange_id The unique ID of the exchange (e.g., "binance").
#' @return A dataframe containing trading pairs, base currency, and quote currency.
#' @export
get_exchange_pairs <- function(exchange_id) {
  url <- paste0("https://api.coingecko.com/api/v3/exchanges/", exchange_id, "/tickers")
  response <- httr::GET(url)

  if (status_code(response) != 200) {
    stop("API request failed! Please check the exchange ID.")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  if (!"tickers" %in% names(data) || is.null(data$tickers) || length(data$tickers) == 0) {
    stop("No tickers found for this exchange.")
  }
  tickers <- data$tickers


  df <- data.frame(
    pair = data$tickers$market$identifier,
    base_currency = data$tickers$base,
    quote_currency = data$tickers$target,
    volume = data$tickers$volume
  )

  return(df)
}

#' @title Get Exchange Volume History
#' @description Retrieve the historical trading volume for a specific exchange.
#' @param exchange_id The unique ID of the exchange (e.g., "binance").
#' @return A dataframe with date and trading volume.
#' @export
get_exchange_volume_history <- function(exchange_id) {
  url <- paste0("https://api.coingecko.com/api/v3/exchanges/", exchange_id, "/volume_chart?days=7")
  response <- httr::GET(url)

  if (status_code(response) != 200) {
    stop("API request failed! Please check the exchange ID.")
  }

  data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  if (!"tickers" %in% names(data) || length(data$tickers) == 0) {
    return(data.frame(pair = character(), base_currency = character(), quote_currency = character(), volume = numeric()))
  }

  trade_volume_24h_btc <- data$trade_volume_24h_btc
  # extract data safely
  df <- data.frame(
    pair = sapply(data$tickers, function(x) {
      if ("market" %in% names(x) && "identifier" %in% names(x$market)) {
        return(x$market$identifier)
      } else {
        return(exchange_id)
      }
    }),
    base_currency = sapply(data$tickers, function(x) ifelse(!is.null(x$base), x$base, NA)),
    quote_currency = sapply(data$tickers, function(x) ifelse(!is.null(x$target), x$target, NA)),
    volume = sapply(data$tickers, function(x) ifelse(!is.null(x$volume), x$volume, 0))
  )

  return(df)
}

