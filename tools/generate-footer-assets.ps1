param(
    [string]$MetadataPath = "metadata.toml",
    [string]$OutputDir = "assets/footer"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$target = Join-Path $root $OutputDir
$metadataFile = Join-Path $root $MetadataPath
New-Item -ItemType Directory -Force -Path $target | Out-Null

$metadata = Get-Content -LiteralPath $metadataFile
$firstName = ($metadata | Select-String -Pattern '^\s*first_name\s*=\s*"([^"]+)"' | Select-Object -First 1).Matches.Groups[1].Value
$lastName = ($metadata | Select-String -Pattern '^\s*last_name\s*=\s*"([^"]+)"' | Select-Object -First 1).Matches.Groups[1].Value
$fullName = "$firstName $lastName".Trim()

function New-FooterSvg {
    param(
        [string]$FullName,
        [string]$DocumentType,
        [string]$FileName
    )

    $source = @"
#set page(width: 182mm, height: 12pt, margin: 0pt, fill: none)
#set text(font: "Source Sans 3", size: 8pt, fill: rgb("999999"))
#table(
  columns: (1fr, auto),
  stroke: none,
  inset: 0pt,
  smallcaps("$FullName"),
  smallcaps("$DocumentType"),
)
"@

    $output = Join-Path $target $FileName
    $source | typst compile - $output --format svg
}

$currentLang = $null
$footerByLang = [ordered]@{}

foreach ($line in $metadata) {
    if ($line -match '^\s*\[lang\.([^\]]+)\]\s*$') {
        $currentLang = $Matches[1]
        continue
    }

    if ($currentLang -and $line -match '^\s*cv_footer\s*=\s*"([^"]+)"') {
        $footerByLang[$currentLang] = $Matches[1]
    }
}

foreach ($entry in $footerByLang.GetEnumerator()) {
    New-FooterSvg -FullName $fullName -DocumentType $entry.Value -FileName "footer-$($entry.Key).svg"
}
