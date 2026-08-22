# Methodology

## Study design

The analysis follows repeated survey responses collected over three study phases. The working dataset is reshaped from wide to long format so that within-participant correlation can be modeled explicitly.

## Analytical workflow

1. Load approved survey and symptom-scoring files from the private data directory.
2. Standardize demographic and clinical fields, then map free-text symptom descriptions into analytical indicators.
3. Reshape phase-specific responses into a participant-by-phase longitudinal dataset.
4. Estimate adjusted binary-outcome models for heatwave-related health impacts and symptom groups.
5. Compare time specifications and account for repeated observations using generalized linear mixed models and generalized estimating equations (GEE).
6. Review model diagnostics and sensitivity checks before interpreting adjusted odds ratios.

## Modeling approach

The R workflow uses logistic mixed-effects models with participant-level random effects, alongside GEE sensitivity analyses. Models adjust for available demographic, household, and prior-diagnosis covariates. Time is evaluated across the three survey phases using categorical and alternative functional forms.

## Interpretation

Reported estimates describe adjusted associations in the study sample; they should not be read as causal effects or generalized beyond the approved research context.
