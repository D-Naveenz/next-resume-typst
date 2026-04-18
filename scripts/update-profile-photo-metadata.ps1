param(
    [Parameter(Mandatory = $true)]
    [string]$ImagePath,

    [string]$MetadataPath = "metadata.toml"
)

$ErrorActionPreference = "Stop"

function Convert-ToRepoRelativePath {
    param(
        [string]$BaseDirectory,
        [string]$TargetPath
    )

    $baseUri = [System.Uri]((Resolve-Path -LiteralPath $BaseDirectory).Path + [System.IO.Path]::DirectorySeparatorChar)
    $targetUri = [System.Uri](Resolve-Path -LiteralPath $TargetPath).Path
    $relativeUri = $baseUri.MakeRelativeUri($targetUri)
    return [System.Uri]::UnescapeDataString($relativeUri.ToString()).Replace('\', '/')
}

$metadataResolved = Resolve-Path -LiteralPath $MetadataPath
$repoRoot = Split-Path -Parent $metadataResolved.Path
$imageResolved = Resolve-Path -LiteralPath $ImagePath
$repoRelativeImagePath = Convert-ToRepoRelativePath -BaseDirectory $repoRoot -TargetPath $imageResolved.Path

Add-Type -AssemblyName System.Drawing
$image = [System.Drawing.Image]::FromFile($imageResolved.Path)
try {
    if ($image.Height -eq 0) {
        throw "Image height is zero, cannot compute aspect ratio."
    }

    $aspectRatio = [math]::Round($image.Width / $image.Height, 4)
}
finally {
    $image.Dispose()
}

$content = Get-Content -LiteralPath $metadataResolved.Path -Raw
$updated = $content
$updated = [regex]::Replace(
    $updated,
    '(?m)^(\s*profile_photo\s*=\s*)".*"$',
    {
        param($match)
        $match.Groups[1].Value + '"' + $repoRelativeImagePath + '"'
    }
)
$updated = [regex]::Replace(
    $updated,
    '(?m)^(\s*profile_photo_aspect_ratio\s*=\s*).*$',
    {
        param($match)
        $match.Groups[1].Value + $aspectRatio.ToString('0.0000', [System.Globalization.CultureInfo]::InvariantCulture)
    }
)

if ($updated -eq $content) {
    Write-Output ("No changes needed in {0}: profile_photo = ""{1}"", profile_photo_aspect_ratio = {2}" -f
        $metadataResolved.Path,
        $repoRelativeImagePath,
        $aspectRatio.ToString('0.0000', [System.Globalization.CultureInfo]::InvariantCulture))
    exit 0
}

Set-Content -LiteralPath $metadataResolved.Path -Value $updated
Write-Output ("Updated {0}: profile_photo = ""{1}"", profile_photo_aspect_ratio = {2}" -f
    $metadataResolved.Path,
    $repoRelativeImagePath,
    $aspectRatio.ToString('0.0000', [System.Globalization.CultureInfo]::InvariantCulture))
