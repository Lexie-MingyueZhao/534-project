# Contributing to the Project

Thank you for considering contributing to the Crypto Screener R Package project! To ensure smooth collaboration and maintain high code quality, please follow the guidelines outlined below.

## **1. Getting Started**

Before making any contributions, please:

-   Fork the repository to your own GitHub account.

-   Clone the repository to your local machine.

-   Create a new branch for your feature or bug fix.

### **Clone the Repository**

``` sh

git clone <https://github.com/Lexie-MingyueZhao/534-project.git> 

cd 534-project
```

### **Create a New Branch**

Always create a feature branch before making changes:

``` sh
git checkout -b feature/your-feature-name
```

------------------------------------------------------------------------

## **2. Code Submission Guidelines**

### **Commit Messages**

Follow clear and concise commit message formats:

-   **Good:** fix: Correct API response handling in get_exchange_pairs()

-   **Bad:** Fixed it or Updated some stuff

### **Pull Requests (PRs)**

-   Open a **Pull Request (PR)** when your code is ready for review.

-   Provide a clear description of what the PR does.

-   Include any relevant issue numbers in your PR (e.g., Closes #23).

-   Ensure your PR is **small and focused**—one feature or bug fix per PR.

------------------------------------------------------------------------

## **3. Running Tests**

Before submitting any changes, make sure your code passes all tests.

**Install Required Packages**

Ensure all dependencies are installed:

``` r
install.packages(c("testthat", "httr", "jsonlite", "dplyr", "ggplot2"))
```

### **Run Tests Locally**

Execute tests using the testthat package:

``` r
library(testthat)
test_dir("tests")
```

Or run a specific test file:

``` r
test_file("tests/test-exchange_functions.R")
```

### **Writing Tests**

-   Place all test files in the tests/ directory.

-   Use testthat to write unit tests for functions.

-   Ensure tests cover edge cases and API error handling.

Example test for get_exchange_pairs():

``` r
test_that("get_exchange_pairs() returns a valid data frame", {
  result <- get_exchange_pairs("kraken")
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true("pair" %in% names(result))
  expect_true("base_currency" %in% names(result))
})
```

------------------------------------------------------------------------

**4. Code Quality and Documentation**

-   Follow **tidyverse style** for clean and readable R code.

-   Ensure all functions have **Roxygen2** documentation.

-   Run devtools::document() before pushing changes.

Example function documentation:

``` r
#' @title Get Exchange Trading Pairs
#' @description Retrieve available trading pairs for a specific exchange.
#' @param exchange_id The exchange identifier (e.g., "binance").
#' @return A data frame with `pair`, `base_currency`, `quote_currency`, and `volume`.
#' @export
get_exchange_pairs <- function(exchange_id) {
  # Function implementation here
}
```

------------------------------------------------------------------------

**5. Handling API Limits**

-   Be mindful of API rate limits when testing.

-   If you receive an error like 429 Too Many Requests, wait or use cached data.

-   Implement **error handling** for API requests to avoid breaking the workflow.

Example API request with error handling:

``` r
response <- httr::GET(url)
if (httr::status_code(response) != 200) {
  stop("API request failed! Please check the exchange ID.")
}
```

------------------------------------------------------------------------

**6. License & Contribution Agreement**

By contributing to this project, you agree that:

-   Your contributions will be licensed under the **MIT License**.

-   You grant the project maintainers the right to modify and distribute your work.

------------------------------------------------------------------------

Thank you for contributing! If you have any questions, feel free to reach out.
