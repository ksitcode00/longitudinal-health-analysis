# R pipeline

These scripts expose the key longitudinal workflow as reusable entrypoints while the complete documented analysis remains in the R Markdown file.

| Script | Purpose |
|---|---|
| `00_packages.R` | Validates package dependencies |
| `01_data_cleaning.R` | Loads approved local inputs and reshapes records by phase |
| `02_symptom_mapping.R` | Maps cleaned free-text conditions into analytical indicators |
| `03_longitudinal_models.R` | Fits GLMM and GEE repeated-measures models |
| `04_visualization.R` | Creates phase-level figures in `results/private/` |

The public scripts contain no participant-level records. The full workflow is in [`analysis/longitudinal_health_analysis.Rmd`](../analysis/longitudinal_health_analysis.Rmd).
