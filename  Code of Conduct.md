# Code of Conduct

## 1. Purpose
Our project aims to develop a high-quality R-based cryptocurrency data analysis tool. To maintain an open, inclusive, and productive environment, this Code of Conduct applies to all contributors, maintainers, and users.

## 2. Respect & Inclusivity
We encourage collaboration and strive to maintain a respectful and diverse community. Please adhere to the following principles:
- Respect differing opinions, even if you disagree.
- Avoid offensive, discriminatory, or harassing language.
- Be welcoming and supportive of new contributors.

## 3. Contribution Guidelines

### 3.1 Code Quality
- Follow **clean and maintainable** R coding practices, adhering to `tidyverse` style guidelines where applicable.
- All new features **must include unit tests** using `testthat` and meet **reproducibility** standards.
- Keep changes **consistent** to prevent breaking existing functionality.

### 3.2 API Usage Compliance
- This project relies on **CoinGecko API** for exchange data retrieval. Ensure all API calls **respect CoinGecko’s Rate Limits**.
- Use **efficient caching mechanisms** to minimize unnecessary API requests.
- Before submitting a PR, manually verify API calls to avoid Rate Limit errors affecting test results.

### 3.3 Bug Reporting
- Before reporting a bug, verify that the **API is operational** (`status_code(response) == 200`).
- Provide **detailed reproduction steps**, including:
  - **Input parameters**
  - **Error logs**
  - **Screenshots (if applicable)**
- Specify **environment details** (R version, operating system, etc.).

### 3.4 Pull Request (PR) Requirements
- Develop new features in **feature branches**, not directly in `main`.
- When submitting a PR:
  - **Include test results** (e.g., `testthat::test_dir("tests/")`).
  - **Ensure CI/CD checks pass** (if applicable).
  - **Provide a clear description** of the changes.

## 4. Communication & Collaboration
- **Respect teammates' time** and avoid unnecessary mentions.
- **Use GitHub Issues** for discussions to maintain traceability.
- When discussing API-related issues, provide the **raw API JSON response** for debugging purposes.

## 5. Enforcement
If a contributor violates this Code of Conduct, maintainers may take the following actions:
- **Issue a warning** and request behavior correction.
- **Remove inappropriate content** (e.g., spam PRs, off-topic issues).
- **Temporarily or permanently ban** contributors who repeatedly violate the guidelines.

---

### Final Interpretation
This Code of Conduct is enforced and maintained by the project’s maintainers, who reserve the right to update it as needed.
