# Create phase-level visualizations only in an approved local environment.
plot_prevalence_by_phase <- function(dat_long, outcome = "Respiratory") {
  summary_df <- dat_long |>
    dplyr::group_by(phase) |>
    dplyr::summarise(prevalence = mean(.data[[outcome]], na.rm = TRUE), .groups = "drop")

  ggplot2::ggplot(summary_df, ggplot2::aes(x = phase, y = prevalence, group = 1)) +
    ggplot2::geom_line(color = "#247b84", linewidth = 1) +
    ggplot2::geom_point(color = "#e17d3e", size = 3) +
    ggplot2::scale_y_continuous(labels = function(x) paste0(round(100 * x), "%")) +
    ggplot2::labs(title = "Symptom prevalence by survey phase", x = "Survey phase", y = "Prevalence") +
    ggplot2::theme_minimal(base_size = 12)
}

save_private_figure <- function(plot, filename) {
  dir.create("results/private", recursive = TRUE, showWarnings = FALSE)
  ggplot2::ggsave(file.path("results/private", filename), plot = plot, width = 8, height = 5, dpi = 300)
}
