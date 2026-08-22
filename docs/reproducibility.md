# Reproducibility

[`R/00_packages.R`](../R/00_packages.R) lists the packages required by the separated R pipeline. A lockfile is not fabricated because a correct `renv.lock` must be created from the actual approved environment and its installed package versions.

After data authorization, initialize a local R environment:

```r
install.packages(c("renv", "readr", "dplyr", "tidyr", "stringr", "lme4", "geepack", "ggplot2"))
renv::init()
renv::snapshot()
```

Do not add survey inputs, participant-level outputs, or restricted derived tables to Git.
