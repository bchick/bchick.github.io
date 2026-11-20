# Quarto post-render step: delete rendered drafts from the public output (../blog).
#
# Quarto hides posts marked `draft: true` from the post list, RSS feed and sitemap,
# but older versions still write the page itself. Without this step a draft would
# be online at a guessable URL. Preview builds (../.blog-preview) are left alone.

out_dir <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR")
if (!nzchar(out_dir)) out_dir <- "../blog"
if (basename(normalizePath(out_dir, mustWork = FALSE)) != "blog") quit(save = "no")

is_draft <- function(path) {
  lines <- trimws(readLines(path, warn = FALSE, encoding = "UTF-8"))
  if (length(lines) == 0 || lines[1] != "---") return(FALSE)
  end <- which(lines == "---")[2]
  if (is.na(end)) return(FALSE)
  any(grepl("^draft:\\s*(true|yes)\\b", lines[seq_len(end - 1)][-1], ignore.case = TRUE))
}

sources <- list.files("posts", pattern = "\\.(qmd|Rmd|md)$", recursive = TRUE, full.names = TRUE)
for (src in sources[vapply(sources, is_draft, logical(1))]) {
  page <- file.path(out_dir, sub("\\.(qmd|Rmd|md)$", ".html", src))
  if (!file.exists(page)) next
  if (basename(src) %in% c("index.qmd", "index.Rmd", "index.md")) {
    unlink(dirname(page), recursive = TRUE)
  } else {
    unlink(page)
  }
  message("Left draft out of the public site: ", src)
}
