% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/indicators.R
\name{calculate_rsi}
\alias{calculate_rsi}
\title{Calculate RSI}
\usage{
calculate_rsi(data, n = 14)
}
\arguments{
\item{data}{A dataframe with at least \code{date} and \code{price} columns}

\item{n}{Number of periods for RSI calculation (default: 14)}
}
\value{
A dataframe with an additional \code{rsi} column
}
\description{
Calculate Relative Strength Index (RSI) for crypto price data
}
