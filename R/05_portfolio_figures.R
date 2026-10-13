# Run from the repository root: Rscript R/05_portfolio_figures.R
# Aggregate GEE estimates transcribed from the supplied final manuscript,
# Tables 6 and 7. This script does not access participant records.
library(ggplot2)
library(grid)

colors <- c(Heatwave = "#BE4436", `Dust storm` = "#087E83")
ink <- "#242C30"
muted <- "#59666C"
theme_set(theme_minimal(base_size = 16, base_family = "Helvetica") +
  theme(plot.background = element_rect(fill = "white", colour = NA),
    panel.grid.minor = element_blank(), panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(colour = "#E5EBED", linewidth = 0.4),
    axis.title.y = element_blank(), axis.text = element_text(colour = ink),
    plot.title = element_text(size = 26, face = "bold", colour = ink),
    plot.subtitle = element_text(size = 15, colour = muted, margin = margin(b = 26)),
    plot.caption = element_text(size = 11, colour = muted, hjust = 0, lineheight = 1.4),
    plot.title.position = "plot", plot.caption.position = "plot",
    plot.margin = margin(25, 32, 22, 25),
    legend.position = "top", legend.justification = "left", legend.title = element_blank()))

save_plot <- function(p, name, height) {
  ggsave(file.path("figures", paste0(name, ".png")), p, width = 12, height = height,
         dpi = 180, device = ragg::agg_png, bg = "white")
  ggsave(file.path("figures", paste0(name, ".svg")), p, width = 12, height = height,
         device = svglite::svglite, bg = "white")
}

evidence <- data.frame(
  event = c("Heatwave", "Dust storm", "Heatwave", "Heatwave"),
  outcome = c("Dyspnea", "Dyspnea", "Reported impact", "Reported impact"),
  comparison = c("Asthma history", "Asthma history", "Phase 2 vs Phase 1", "Phase 3 vs Phase 1"),
  estimate = c(2.31, 1.92, 0.54, 0.47),
  lower = c(1.78, 1.52, 0.47, 0.41), upper = c(2.99, 2.43, 0.63, 0.55),
  row = c(4, 3, 1.5, 0.5))
evidence$label <- sprintf("%.2f  (%.2f - %.2f)", evidence$estimate, evidence$lower, evidence$upper)

p <- ggplot(evidence, aes(x = estimate, y = row, colour = event)) +
  geom_vline(xintercept = 1, colour = "#7F8D92", linetype = "dashed", linewidth = 0.6) +
  geom_segment(aes(x = lower, xend = upper, yend = row), linewidth = 1.4) +
  geom_point(size = 4.5, shape = 18) +
  geom_text(aes(x = 3.8, label = label), hjust = 0, size = 4.6, colour = ink) +
  annotate("text", x = 0.24, y = 5.25, label = "Outcome / comparison", hjust = 0, size = 4.4, colour = muted) +
  annotate("text", x = 3.8, y = 5.25, label = "Adjusted OR (95% CI)", hjust = 0, size = 4.4, colour = muted) +
  annotate("text", x = 0.24, y = 4.65, label = "Asthma and breathing difficulty", hjust = 0, size = 4.8, fontface = "bold", colour = ink) +
  annotate("text", x = 0.24, y = 2.15, label = "Heatwave impacts across phases", hjust = 0, size = 4.8, fontface = "bold", colour = ink) +
  scale_colour_manual(values = colors) +
  scale_x_log10(breaks = c(0.5, 1, 2, 3), labels = c("0.5", "1", "2", "3"), limits = c(0.24, 10)) +
  scale_y_continuous(breaks = evidence$row,
    labels = c("Heatwave-related dyspnea", "Dust-related dyspnea", "Phase 2 vs Phase 1", "Phase 3 vs Phase 1"),
    limits = c(-0.15, 5.6), expand = c(0, 0)) +
  labs(title = "Breathing difficulty and changing health impacts",
    subtitle = "660 adults surveyed across three phases | Selected adjusted GEE associations",
    x = "Odds ratio (log scale)   |   Dashed line: no association",
    caption = "Asthma rows: single-NCD history indicator. Phase rows: reported heatwave impact.\nPoints: adjusted odds ratios; lines: 95% confidence intervals. Associations do not establish causation.\nSource: final manuscript, Tables 6-7. Selected results; not an exhaustive model summary.")
save_plot(p, "research-evidence", 7.4)

phase <- data.frame(
  event = rep(c("Heatwave", "Dust storm"), each = 2),
  phase = rep(c("Phase 2 vs Phase 1", "Phase 3 vs Phase 1"), 2),
  estimate = c(0.54, 0.47, 0.62, 0.60), lower = c(0.47, 0.41, 0.53, 0.52),
  upper = c(0.63, 0.55, 0.73, 0.70))
phase$phase <- factor(phase$phase, levels = rev(unique(phase$phase)))
phase$label <- sprintf("%.2f  (%.2f - %.2f)", phase$estimate, phase$lower, phase$upper)
p2 <- ggplot(phase, aes(x = estimate, y = phase, colour = event)) +
  geom_vline(xintercept = 1, colour = "#7F8D92", linetype = "dashed") +
  geom_segment(aes(x = lower, xend = upper, yend = phase), linewidth = 1.4) +
  geom_point(size = 4.5, shape = 18) +
  geom_text(aes(x = 1.16, label = label), hjust = 0, size = 4.8, colour = ink) +
  facet_grid(event ~ ., switch = "y") +
  scale_colour_manual(values = colors, guide = "none") +
  scale_x_log10(breaks = c(0.4, 0.5, 0.75, 1), limits = c(0.36, 1.95)) +
  scale_y_discrete(expand = expansion(add = 0.6)) +
  theme(strip.text.y.left = element_text(angle = 0, face = "bold", size = 16, colour = ink),
    strip.placement = "outside", panel.spacing.y = unit(24, "pt")) +
  labs(title = "Reported impacts were lower in later phases",
    subtitle = "Adjusted GEE odds ratios for reported impact | Phase 1 is the reference",
    x = "Odds ratio (log scale)   |   Dashed line: Phase 1 reference",
    caption = "Points: adjusted odds ratios; lines: 95% confidence intervals. Right column: OR (95% CI).\nSource: final manuscript, Tables 6-7. These are phase associations, not measured exposure effects.")
save_plot(p2, "phase-associations", 6.4)

draw_workflow <- function() {
  grid.newpage()
  txt <- function(x, y, label, size = 16, col = ink, bold = FALSE) {
    grid.text(label, x, y, just = c("left", "top"),
      gp = gpar(fontfamily = "Helvetica", fontsize = size, col = col,
                fontface = if (bold) "bold" else "plain", lineheight = 1.5))
  }
  line <- function(x1, y1, x2, y2, col = "#DDE5E7") {
    grid.lines(c(x1, x2), c(y1, y2), gp = gpar(col = col, lwd = 1))
  }
  txt(.05, .94, "From survey responses to statistical evidence", 27, bold = TRUE)
  txt(.05, .85, "R workflow | Three repeated survey phases | Restricted participant data", 16, muted)
  for (i in 1:3) {
    x <- c(.05, .37, .69)[i]
    txt(x, .70, c("Prepare", "Model", "Interpret")[i], 23, bold = TRUE)
    line(x, .635, x + .25, .635, colors[[if (i == 2) 1 else 2]])
  }
  txt(.05, .59, "Standardize free text\nGroup clinical symptoms\nBuild person-phase records", 17)
  txt(.37, .59, "GLMM: subject-specific\nGEE: population-average\nCheck model diagnostics", 17)
  txt(.69, .59, "Odds ratios and intervals\nPhase contrasts\nPublic-health implications", 17)
  for (x in c(.325, .645)) {
    grid.lines(c(x - .025, x), c(.48, .48), arrow = arrow(length = unit(.1, "inches")),
               gp = gpar(col = muted, lwd = 1.5))
  }
  line(.05, .31, .95, .31)
  txt(.05, .265, "Statistical judgment", 16, bold = TRUE)
  txt(.05, .205, "Evaluate random-slope singularity; retain a supported correlation structure.\nCompare time specifications and report uncertainty alongside effect sizes.", 16, muted)
  txt(.05, .085, "Public portfolio: code and aggregate estimates. Participant records remain restricted.", 13, muted)
}
ragg::agg_png("figures/analysis-workflow.png", width = 12, height = 7, units = "in", res = 180, background = "white")
draw_workflow()
dev.off()
svglite::svglite("figures/analysis-workflow.svg", width = 12, height = 7)
draw_workflow()
dev.off()

write.csv(evidence[c("event", "outcome", "comparison", "estimate", "lower", "upper")],
          "figures/selected-gee-estimates.csv", row.names = FALSE)
write.csv(phase[c("event", "phase", "estimate", "lower", "upper")],
          "figures/phase-gee-estimates.csv", row.names = FALSE)
