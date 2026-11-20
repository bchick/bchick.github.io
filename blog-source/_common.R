# Shared setup for posts. Each post starts with:  source("../../_common.R")

suppressPackageStartupMessages({
  library(ggplot2)
})

# Colours from the site's stylesheet
blog_palette <- c(
  ink    = "#1A1A1A",
  muted  = "#5E6B57",
  accent = "#B5453F",
  blue   = "#3F6E8C",
  grid   = "#DCE5D5",
  paper  = "#F3F7F0"
)

theme_set(
  theme_minimal(base_size = 12) +
    theme(
      plot.background     = element_rect(fill = blog_palette[["paper"]], colour = NA),
      panel.grid.minor    = element_blank(),
      panel.grid.major    = element_line(colour = blog_palette[["grid"]], linewidth = 0.3),
      axis.text           = element_text(colour = blog_palette[["muted"]]),
      axis.title          = element_text(colour = blog_palette[["ink"]]),
      legend.position     = "top",
      legend.justification = "left",
      plot.title.position = "plot",
      plot.margin         = margin(12, 16, 10, 10)
    )
)
