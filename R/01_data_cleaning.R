# Load authorized longitudinal survey inputs and create a participant-by-phase dataset.
source("R/00_packages.R")
load_project_packages()

load_private_inputs <- function(
  survey_path = "data/private/cleaned_study_data.csv",
  severity_path = "data/private/symptom_severity_scores.csv"
) {
  if (!all(file.exists(c(survey_path, severity_path)))) {
    stop("Restricted inputs not found. See data/README.md for approved local access.", call. = FALSE)
  }
  survey <- readr::read_csv(survey_path, skip = 4, locale = readr::locale(encoding = "latin1"), show_col_types = FALSE)
  severity <- utils::read.csv(severity_path, check.names = FALSE)
  list(survey = survey, severity = severity)
}

make_longitudinal_data <- function(df_wide) {
  if ("Affected" %in% names(df_wide)) df_wide <- dplyr::rename(df_wide, Affected_overall = Affected)

  df_wide |>
    tidyr::pivot_longer(
      cols = tidyselect::matches("^T[123]_(Heatwave_(Affected|Condition)|HW_symptom_severity_score)$"),
      names_to = c("phase", ".value"),
      names_pattern = "^T([123])_(?:Heatwave_|HW_)?(.*)$"
    ) |>
    dplyr::mutate(
      phase = factor(paste0("T", phase), levels = c("T1", "T2", "T3")),
      Affected = dplyr::case_when(
        Affected %in% c(1, "1", "Yes", "YES", "Y", TRUE) ~ 1L,
        Affected %in% c(0, "0", "No", "NO", "N", FALSE) ~ 0L,
        TRUE ~ NA_integer_
      )
    )
}
