#' @title Get Exchange Data
#' @description Retrieve information about cryptocurrency exchanges, including trading volume, trust score, and more.
#' @return A dataframe containing exchange ID, name, country, trading volume, and trust score.
#' @export
get_exchanges <- function() {
  url <- "https://api.coingecko.com/api/v3/exchanges"

  response <- tryCatch(
    httr::GET(url),
    error = function(e) {
      message("API request failed: ", e$message)
      return(NULL)
    }
  )

  if (is.null(response) || httr::status_code(response) != 200) {
    warning("API request failed, returning empty data frame")
    return(data.frame(id = character(), name = character(), country = character(), trade_volume_24h_btc = numeric()))
  }

  data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

  df <- data.frame(
    id = data$id,
    name = data$name,
    country = data$country,
    trade_volume_24h_btc = data$trade_volume_24h_btc
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
    message("No tickers found for this exchange. Returning empty dataframe.")
    return(data.frame(pair = character(), base_currency = character(), quote_currency = character(), volume = numeric()))
  }

  df <- data.frame(
    pair = sapply(data$tickers, function(x) if (!is.null(x$market$identifier)) x$market$identifier else NA),
    base_currency = sapply(data$tickers, function(x) if (!is.null(x$base)) x$base else NA),
    quote_currency = sapply(data$tickers, function(x) if (!is.null(x$target)) x$target else NA),
    volume = sapply(data$tickers, function(x) if (!is.null(x$volume)) x$volume else 0)
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

  # 如果 API 返回空数据，返回空 DataFrame
  if (length(data) == 0) {
    return(data.frame(date = as.Date(character()), volume_btc = numeric()))
  }

  df <- data.frame(
    date = as.POSIXct(sapply(data, function(x) x[[1]] / 1000), origin = "1970-01-01"),
    volume_btc = sapply(data, function(x) x[[2]])
  )

  return(df)
}
