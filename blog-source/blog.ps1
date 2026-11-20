<#
.SYNOPSIS
  Helper for the Quarto blog at www.brentchick.com/blog/.

.EXAMPLE
  .\blog.ps1 new "Revisiting a published ATAC-seq dataset"
  Creates posts\<today>-<slug>\index.qmd from the template, marked as a draft.

.EXAMPLE
  .\blog.ps1 preview
  Live preview of the post you edited last (drafts included), built in a
  throwaway folder, so there is nothing to commit.

.EXAMPLE
  .\blog.ps1 render
  Builds the public site into ..\blog. Commit blog-source\ and blog\ afterwards.
#>
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet('new', 'preview', 'render')]
  [string]$Command,

  [Parameter(Position = 1)]
  [string]$Title
)

$ErrorActionPreference = 'Stop'

function Find-Quarto {
  $cmd = Get-Command quarto -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }
  $candidates = @(
    (Join-Path $env:ProgramFiles 'Quarto\bin\quarto.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Quarto\bin\quarto.exe'),
    (Join-Path $env:ProgramFiles 'RStudio\resources\app\bin\quarto\bin\quarto.exe')
  )
  foreach ($c in $candidates) {
    if (Test-Path $c) { return $c }
  }
  throw 'Quarto not found. Install it from https://quarto.org/docs/get-started/'
}

switch ($Command) {
  'new' {
    if (-not $Title) { throw 'Give the post a title, e.g.  .\blog.ps1 new "My title"' }

    $date = Get-Date -Format 'yyyy-MM-dd'
    $slug = ($Title.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    if ($slug.Length -gt 60) { $slug = $slug.Substring(0, 60).Trim('-') }
    if (-not $slug) { $slug = 'post' }

    $folder = "$date-$slug"
    $dir = Join-Path $PSScriptRoot "posts\$folder"
    if (Test-Path $dir) { throw "A post folder already exists: posts\$folder" }

    $text = [IO.File]::ReadAllText((Join-Path $PSScriptRoot '_template\index.qmd'))
    $safeTitle = $Title.Replace('\', '\\').Replace('"', '\"')
    $text = $text.Replace('__TITLE__', $safeTitle).Replace('__DATE__', $date)

    New-Item -ItemType Directory -Path $dir | Out-Null
    [IO.File]::WriteAllText((Join-Path $dir 'index.qmd'), $text, (New-Object Text.UTF8Encoding $false))
    Write-Host "Created posts\$folder\index.qmd (marked as a draft)."
  }

  'preview' {
    # Open the post edited most recently (drafts included); fall back to the post list.
    $latest = Get-ChildItem (Join-Path $PSScriptRoot 'posts') -Filter 'index.qmd' -Recurse -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $target = if ($latest) { $latest.FullName } else { $PSScriptRoot }
    $quarto = Find-Quarto
    $ErrorActionPreference = 'Continue'   # Quarto logs progress on stderr; rely on its exit code
    & $quarto preview $target --profile preview
    exit $LASTEXITCODE
  }

  'render' {
    $quarto = Find-Quarto
    $ErrorActionPreference = 'Continue'   # Quarto logs progress on stderr; rely on its exit code
    & $quarto render $PSScriptRoot
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host ''
    Write-Host 'Done. Commit both blog-source\ and blog\, then push to publish.'
  }
}
