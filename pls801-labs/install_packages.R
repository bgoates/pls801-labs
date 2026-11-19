# Install the R packages used across the PLS 801 labs.
# Run once from this folder:  Rscript install_packages.R

pkgs <- c(
  "tidyverse", "readr", "haven",              # data
  "ggplot2", "patchwork", "GGally", "ggridges", "datasauRus",  # plots
  "jtools", "stargazer", "modelsummary",      # model summaries and tables
  "marginaleffects", "margins",               # marginal effects and predictions
  "rmarkdown", "knitr"
)

missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing) > 0) install.packages(missing) else message("All packages are already installed.")
