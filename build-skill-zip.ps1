<#
  build-skill-zip.ps1 — rebuild the loadable Divi5 skill bundle.

  WHY a script: the zip must use FORWARD-SLASH entry paths or it breaks on
  Linux/WP installs. PowerShell's Compress-Archive writes BACK-slashes, so we
  use .NET System.IO.Compression directly. (See memory: zip-forward-slashes.)

  WHAT goes in: only the skill-CONTENT files Claude loads —
  SKILL.md, README.md, and every DIVI5-*.md. Repo-meta files
  (MODULE-TEMPLATE.md, WORKFLOW.md, .gitignore, this script) are EXCLUDED.

  OUTPUT: ..\divi5-skill.zip (the path existing consumers already use).
          Pass -OutFile to override.
#>
param(
    [string]$OutFile = (Join-Path (Split-Path $PSScriptRoot -Parent) 'divi5-skill.zip')
)

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = $PSScriptRoot
$include = @('SKILL.md', 'README.md') + (Get-ChildItem -Path $root -Filter 'DIVI5-*.md' | ForEach-Object { $_.Name })
$include = $include | Sort-Object -Unique

if (Test-Path $OutFile) { Remove-Item $OutFile -Force }

$zip = [System.IO.Compression.ZipFile]::Open($OutFile, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($name in $include) {
        $path = Join-Path $root $name
        if (-not (Test-Path $path)) { Write-Warning "missing: $name"; continue }
        # entry name = forward-slash, flat (matches the historical bundle layout)
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $path, $name) | Out-Null
        Write-Host "  + $name"
    }
}
finally { $zip.Dispose() }

$count = ([System.IO.Compression.ZipFile]::OpenRead($OutFile).Entries).Count
Write-Host "Built $OutFile ($count files)" -ForegroundColor Green
