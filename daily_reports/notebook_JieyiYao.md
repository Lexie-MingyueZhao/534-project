# **🚀 Debugging GitHub Actions CI/CD for `cryptoR`**

## **📌 Problem Summary**

While setting up GitHub Actions for the `cryptoR` package, several issues were encountered: - **Travis CI subscription expired**, leading to the transition to **GitHub Actions**. - **Failed to install dependencies** (`ggplot2`, `devtools`, etc.). - **Package installation errors** due to missing `DESCRIPTION` or incorrect directory structure. - **API request failures** when running tests. - **GitHub SSH key authentication issues** when pulling from the repository.

------------------------------------------------------------------------

## **✅ Solutions and Fixes**

### **1️⃣ Transition from Travis CI to GitHub Actions**

-   Since the **Travis CI Student Plan expired**, we moved to **GitHub Actions**.
-   Created a `.github/workflows/R-CI.yml` file to set up the CI pipeline.

**GitHub Actions YAML Configuration:**

``` yaml
name: R-CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Install R
        uses: r-lib/actions/setup-r@v2

      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev

      - name: Install `remotes` package
        run: |
          R -e 'install.packages("remotes", repos="https://cloud.r-project.org")'

      - name: Install R dependencies
        run: |
          R -e 'remotes::install_cran(c("ggplot2", "testthat", "httr", "dplyr", "TTR", "roxygen2", "pkgload"))'

      - name: Install the package
        run: |
          R -e 'remotes::install_local("cryptoR", dependencies = TRUE, upgrade = "always")'

      - name: Run tests
        run: Rscript -e 'library(testthat); library(cryptoR); testthat::test_package("cryptoR")'
```

------------------------------------------------------------------------

### **2️⃣ Fixing Missing Dependencies**

-   **Issue:** `library(ggplot2)` failed due to missing dependencies.
-   **Fix:** Explicitly installed all required dependencies before installing `cryptoR`.

``` yaml
      - name: Install dependencies
        run: |
          R -e 'install.packages(c("ggplot2", "testthat", "httr", "dplyr", "TTR", "roxygen2", "pkgload"), repos="https://cloud.r-project.org")'
```

------------------------------------------------------------------------

### **3️⃣ Ensuring `cryptoR` is Installed Correctly**

-   **Issue:** `library(cryptoR)` failed in the test stage because `cryptoR` was not properly installed.
-   **Fix:** Used `remotes::install_local("cryptoR", dependencies = TRUE, upgrade = "always")` instead of `devtools::install(".")`.

``` yaml
      - name: Verify package installation
        run: |
          R -e 'if (!requireNamespace("cryptoR", quietly = TRUE)) stop("cryptoR is not installed!")'
```

------------------------------------------------------------------------

## **🔍 Results and Next Steps**

-   ✅ Successfully transitioned from Travis CI to GitHub Actions.
-   ✅ Resolved missing dependencies (`ggplot2`, `testthat`, etc.).
-   ✅ Ensured `cryptoR` installs correctly in CI/CD.
-   ✅ Implemented API error handling and mocking.
-   ✅ Fixed GitHub authentication issues.

# 📌 Vignette Development Progress

## 📖 1. Overview

Today, I worked on building and integrating a vignette for the `cryptoR` package. The goal was to provide users with comprehensive documentation on how to install, use, and test the package, along with code examples and explanations.

------------------------------------------------------------------------

## 🛠 2. Tasks Completed

### 🔹 1️⃣ Created and Organized the Vignette

-   Developed the vignette as an `.Rmd` file.
-   Placed the file in the `vignettes/` directory following standard R package structure.
-   Ensured the vignette includes installation steps, function descriptions, and usage examples.

### 🔹 2️⃣ Installed Required Dependencies

-   Confirmed that all necessary libraries (`testthat`, `httr`, `ggplot2`, `dplyr`, `TTR`, `roxygen2`, `pkgload`, `jsonlite`) are properly installed and loaded.
-   Added installation and loading instructions in the vignette.

### 🔹 3️⃣ Built and Tested the Vignette

-   Used `devtools::build_vignettes()` to generate the vignette documentation.
-   Verified that the vignette was successfully built and stored in `inst/doc/`.

### 🔹 4️⃣ Debugged Missing Vignette Issue

-   Encountered an issue where `browseVignettes("cryptoR")` returned **"No vignettes found"**.
-   Found that the vignette was built locally but had not been pushed to GitHub.
-   Fixed the issue by committing the vignette and `inst/doc/` files to the repository.

### 🔹 5️⃣ Committed and Pushed to GitHub

-   Added the vignette file and `inst/doc/` to Git.

-   Ran:

    ``` bash
    git add vignettes/CryptoR_User_Guide.Rmd
    git add inst/doc/
    git commit -m "Add vignette for CryptoR"
    git push origin main
    ```

-   Reinstalled the package from GitHub with vignette support:

    ``` r
    devtools::install_github("Lexie-MingyueZhao/534-project/cryptoR", build_vignettes = TRUE)
    ```

### 🔹 6️⃣ Verified That the Vignette Works

-   Successfully loaded and viewed the vignette using:

    ``` r
    vignette("CryptoR_User_Guide")
    ```

-   Also checked in a web browser using:

    ``` r
    browseVignettes("cryptoR")
    ```

------------------------------------------------------------------------

## 🎯 4. Conclusion

Today, I successfully built, tested, and integrated a vignette for the `cryptoR` package. The documentation now provides users with clear installation steps, function usage, and testing instructions. Moving forward, I will refine the vignette further and ensure full compatibility with best practices.

🚀 **CryptoR is now well-documented and easier to use!**
