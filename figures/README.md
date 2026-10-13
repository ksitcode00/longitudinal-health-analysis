# Portfolio Figures

These figures present the study's aggregate evidence and the R analysis workflow. No participant-level data are used in figure generation.

| Figure | Purpose |
| --- | --- |
| [Research evidence](research-evidence.png) | Selected asthma-dyspnea associations and heatwave phase comparisons, with 95% confidence intervals |
| [Phase associations](phase-associations.png) | Heatwave and dust-storm reported impacts in later phases relative to Phase 1 |
| [Analysis workflow](analysis-workflow.png) | Data preparation, repeated-measures models, diagnostics, and interpretation |

## Sources

Numerical estimates were transcribed from the author's supplied final manuscript, Tables 6 and 7 (GEE model results). The table values are used consistently where manuscript prose differs slightly in rounding or confidence-interval endpoints. The published study is linked in the [project README](../README.md#related-publication).

The [selected estimate table](selected-gee-estimates.csv) and [phase estimate table](phase-gee-estimates.csv) contain aggregate model estimates only. Asthma is the single-NCD history indicator; phase contrasts use Phase 1 as the reference. Separate rows refer to separate outcomes and comparisons. Odds ratios are not risk ratios or predicted probabilities. Selection of these findings is for portfolio communication; it does not replace review of all models or account for multiple testing.

## Reproduce

From the repository root, with R packages `ggplot2`, `ragg`, and `svglite` installed:

```sh
Rscript R/05_portfolio_figures.R
```

The script uses the transcribed aggregate estimates and exports PNG and SVG versions. It does not load the restricted study files or refit the models.
