# Dependency manifest for the public longitudinal-analysis pipeline.
required_packages <- c("readr", "dplyr", "tidyr", "stringr", "lme4", "geepack", "ggplot2")

load_project_packages <- function(packages = required_packages) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing)) stop("Install required packages: ", paste(missing, collapse = ", "), call. = FALSE)
  invisible(lapply(packages, library, character.only = TRUE))
}
