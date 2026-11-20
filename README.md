# Personal Website

Source for [www.brentchick.com](https://www.brentchick.com), served by GitHub Pages.

| Path | What it is |
|---|---|
| `index.html`, `research.html`, `publications.html`, `styles.css` | Hand-written main pages |
| `blog-source/` | Quarto source for the blog (posts, theme, templates) |
| `blog/` | Rendered blog. Generated; don't edit by hand |
| `.nojekyll` | Tells GitHub Pages to serve files as-is |

## Blog

Posts are Quarto documents (`.qmd`). R code runs when you render, and the code, figures
and output are published together. Run these from `blog-source/` in PowerShell.

**Start a post**

```powershell
.\blog.ps1 new "Revisiting a published ATAC-seq dataset"
```

This creates `posts/<date>-<slug>/index.qmd` from `_template/` and marks it `draft: true`.
Put the post's figures, `references.bib` and small helper files in the same folder.
Keep raw data out of git (anything under a post's `data/` folder is ignored); link to
the public source instead.

**Preview while writing**

```powershell
.\blog.ps1 preview
```

Opens the post you edited most recently, drafts included, and reloads on save. Preview
output goes to `.blog-preview/`, which is ignored by git.

**Publish**

1. Delete the `draft: true` line from the post.
2. Build the public site:

   ```powershell
   .\blog.ps1 render
   ```

3. Commit `blog-source/` and `blog/` together and push.

Drafts never reach `blog/`: they are left out of the post list, RSS feed and sitemap,
and `_scripts/remove-drafts.R` deletes their pages after each render. This repository is
public, though, so a committed draft's source can still be read on GitHub. Leave a draft
uncommitted until you're happy for people to see it.

**Good to know**

- Each post's code only re-runs when that post changes (`freeze: auto`). Cached results
  live in `blog-source/_freeze/`; commit them.
- Every post gets a Citation section (BibTeX) and a CC BY 4.0 Reuse section, set in
  `posts/_metadata.yml`.
- Tag a post's main figure with `#| classes: preview-image` so it shows on link
  previews (Bluesky, LinkedIn, Slack).
- The RSS feed (`/blog/index.xml`) carries full post text, which R-bloggers and
  Rogue Scholar need.
- Shared plot styling lives in `blog-source/_common.R`; the page styling is in
  `blog-source/theme.scss` and mirrors `styles.css`.
- If PowerShell blocks the script, run
  `powershell -ExecutionPolicy Bypass -File .\blog.ps1 <command>` or allow local
  scripts once with `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
- `blog.ps1` finds Quarto on your PATH or in RStudio. Installing the current release from
  [quarto.org](https://quarto.org/docs/get-started/) is recommended; RStudio bundles an
  older version (1.3).
