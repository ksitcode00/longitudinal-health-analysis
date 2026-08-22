# Map standardized free-text conditions into analytical symptom indicators.
condition_flag <- function(x, keywords) {
  cleaned <- stringr::str_to_upper(stringr::str_squish(dplyr::coalesce(as.character(x), "")))
  as.integer(vapply(cleaned, function(value) {
    any(vapply(keywords, function(keyword) stringr::str_detect(value, stringr::fixed(keyword)), logical(1)))
  }, logical(1)))
}

add_key_symptom_flags <- function(dat_long) {
  dat_long |>
    dplyr::mutate(
      Respiratory = condition_flag(Condition, c("COUGH", "TIGHTNESS", "CYANOSIS", "RESPIRATORY")),
      Dyspnea = condition_flag(Condition, "DYSPNEA"),
      Fatigue = condition_flag(Condition, "FATIGUE"),
      Headache = condition_flag(Condition, "HEADACHE"),
      Asthma_prior = condition_flag(Prior_Diagnosis, "ASTHMA")
    )
}
