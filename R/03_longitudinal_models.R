# Fit repeated-measures models for heatwave-related outcomes.
fit_heatwave_glmm <- function(dat_long) {
  analysis_data <- stats::na.omit(dat_long)
  lme4::glmer(
    Affected ~ phase + Age_Group + Gender + Family_Size_Group + Monthly_Income_Group + HH_Area + HTN_prior + Asthma_prior + Thyroid_prior + (1 | ID),
    family = stats::binomial(),
    data = analysis_data,
    nAGQ = 20,
    control = lme4::glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 2e5))
  )
}

fit_respiratory_gee <- function(dat_long) {
  geepack::geeglm(
    Respiratory ~ phase + Age_Group + Gender + Asthma_prior,
    id = ID,
    family = stats::binomial(),
    corstr = "exchangeable",
    data = stats::na.omit(dat_long)
  )
}

odds_ratio_table <- function(model) {
  estimate <- stats::coef(model)
  interval <- suppressMessages(stats::confint(model))
  data.frame(term = names(estimate), odds_ratio = exp(estimate), conf_low = exp(interval[, 1]), conf_high = exp(interval[, 2]), row.names = NULL)
}
