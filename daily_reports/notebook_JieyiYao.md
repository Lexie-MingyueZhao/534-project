# **🚀 Debugging GitHub Actions CI/CD for `cryptoR`**

## **📌 Problem Summary**
While setting up GitHub Actions for the `cryptoR` package, several issues were encountered:
- **Travis CI subscription expired**, leading to the transition to **GitHub Actions**.
- **Failed to install dependencies** (`ggplot2`, `devtools`, etc.).
- **Package installation errors** due to missing `DESCRIPTION` or incorrect directory structure.
- **API request failures** when running tests.
- **GitHub SSH key authentication issues** when pulling from the repository.

---

## **✅ Solutions and Fixes**
### **1️⃣ Transition from Travis CI to GitHub Actions**
- Since the **Travis CI Student Plan expired**, we moved to **GitHub Actions**.
- Created a `.github/workflows/R-CI.yml` file to set up the CI pipeline.

**GitHub Actions YAML Configuration:**
```yaml
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

---

### **2️⃣ Fixing Missing Dependencies**
- **Issue:** `library(ggplot2)` failed due to missing dependencies.
- **Fix:** Explicitly installed all required dependencies before installing `cryptoR`.

```yaml
      - name: Install dependencies
        run: |
          R -e 'install.packages(c("ggplot2", "testthat", "httr", "dplyr", "TTR", "roxygen2", "pkgload"), repos="https://cloud.r-project.org")'
```

---

### **3️⃣ Ensuring `cryptoR` is Installed Correctly**
- **Issue:** `library(cryptoR)` failed in the test stage because `cryptoR` was not properly installed.
- **Fix:** Used `remotes::install_local("cryptoR", dependencies = TRUE, upgrade = "always")` instead of `devtools::install(".")`.

```yaml
      - name: Verify package installation
        run: |
          R -e 'if (!requireNamespace("cryptoR", quietly = TRUE)) stop("cryptoR is not installed!")'
```

---



## **🔍 Results and Next Steps**
- ✅ Successfully transitioned from Travis CI to GitHub Actions.
- ✅ Resolved missing dependencies (`ggplot2`, `testthat`, etc.).
- ✅ Ensured `cryptoR` installs correctly in CI/CD.
- ✅ Implemented API error handling and mocking.
- ✅ Fixed GitHub authentication issues.

