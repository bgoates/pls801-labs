# PLS 801 lab materials: R for political science methods

Weekly R labs I taught as the methods fellow and lab instructor for **PLS 801**, the first-year graduate methods course in Political Science at Michigan State University (Fall 2024). The labs take students from describing and plotting data through OLS regression, marginal effects, and presenting results.

Each lab is self-contained: its own folder holds the code and the data it uses.

| Folder | Topic | What students practice |
|---|---|---|
| [`lab01_measurement`](labs/lab01_measurement) | Measurement and description | Summary statistics, reshaping with `pivot_longer()`, turning continuous variables into categories with `cut()`, histograms, density, bar and scatter plots, saving figures |
| [`lab02_pset1_solutions`](labs/lab02_pset1_solutions) | Problem Set 1 walkthrough | Data cleaning with base R and `dplyr`; descriptive statistics and plots (diplomatic parking-violation data) |
| [`lab03_uncertainty`](labs/lab03_uncertainty) | Describing uncertainty | Variance and standard deviation by hand, ridge plots, boxplots, ribbons, covariance and correlation, `ggpairs()`, why you should always plot your data (`datasauRus`) |
| [`lab04_ols_intro`](labs/lab04_ols_intro) | OLS regression | Computing slope and intercept by hand, `lm()`, residuals, `jtools::summ()`, average marginal effects |
| [`lab04b_review_marginal_effects`](labs/lab04b_review_marginal_effects) | Review: model summaries and marginal effects | `summ()`, `stargazer`, `modelsummary`, `margins`, and `marginaleffects` with democracy and polarization data |
| [`lab05_logs_multiple_regression`](labs/lab05_logs_multiple_regression) | Log models and multiple regression | Simulated data with a fixed seed, log-transformed outcomes and predictors and how to interpret them, `plot_predictions()` |
| [`lab06_tables_marginal_effects`](labs/lab06_tables_marginal_effects) | Summary tables and marginal effects | `datasummary_skim()`, `datasummary_balance()`, regression tables, `predictions()`, `slopes()`, interactions with `plot_slopes()` |
| [`extra_dummy_variables`](labs/extra_dummy_variables) | Dummy and categorical variables | Predicted values for scenarios, factors versus numeric coding, fixed effects |

## How to run a lab

1. Install the packages once: `Rscript install_packages.R`
2. Open a lab's `.Rmd` in RStudio and click **Knit**. R Markdown runs from the file's own folder, so the data are found automatically.
3. For the two `.R` scripts, first set the working directory to that lab's folder (**Session > Set Working Directory > To Source File Location**).

Labs 3 to 6 knit to PDF by default, which needs a LaTeX installation (`tinytex::install_tinytex()`); choose **Knit to HTML** to skip that.

All labs were last run end to end with R 4.3.3 (`marginaleffects` 0.18, `modelsummary` 1.4.5, `jtools` 2.2.2).

## Data

| File | Used in | Source |
|---|---|---|
| `life_exp.csv` | Lab 1 | Gapminder country data, 1952–2007 |
| `parking.csv` | Lab 2 | Fisman & Miguel (2007), "Corruption, Norms, and Legal Enforcement: Evidence from Diplomatic Parking Tickets," *Journal of Political Economy* |
| `wdiOrig.csv` | Lab 3, dummy variables | World Bank, World Development Indicators |
| `news.csv`, `newsweek.csv` | Lab 4 | Small teaching datasets for the OLS examples |
| `reviewlab_data.csv` | Lab 4b | Country-year data built from V-Dem (democracy, polarization) and GDP per capita |
| `fish.RData` | Labs 5, 6, dummy variables | Fish (2002), "Islam and Authoritarianism," *World Politics* |

The dummy-variables script also has two short sections that use `gdpRegions.rda` and `income.rda`, which are not included; those sections are skipped unless the files are added to that folder.

## Credits

- Course instructor: **Prof. Shahryar Minhas**, Michigan State University. Lab 2 (Problem Set 1 solutions) and the dummy-variables script are his; several labs build on his course materials, including the `smTheme()` plotting theme.
- Lab instruction, Labs 1 and 3 to 6, and the review lab: **Bailey G. Oates**.

## Contact

Bailey G. Oates · [github.com/bgoates](https://github.com/bgoates)
