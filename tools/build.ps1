param(
    [string]$Language = "en",
    [string]$CvSource = "cv.typ",
    [string]$LetterSource = "letter.typ",
    [string]$CvOutput = "cv.pdf",
    [string]$LetterOutput = "letter.pdf"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$TempDir = Join-Path $RepoRoot "temp"
$RawCv = Join-Path $TempDir "cv.raw.pdf"
$Manifest = Join-Path $TempDir "nextresume-actualtext.json"
$PostProcessor = Join-Path $PSScriptRoot "apply-actual-text.py"
$VenvPython = Join-Path $RepoRoot ".venv\Scripts\python.exe"
$Python = if (Test-Path $VenvPython) { $VenvPython } else { "python" }

New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

Push-Location $RepoRoot
try {
    typst compile --input "language=$Language" $CvSource $RawCv
    typst query --input "language=$Language" $CvSource "<nextresume-actualtext>" --pretty |
        Set-Content -Encoding UTF8 $Manifest
    & $Python $PostProcessor --input $RawCv --manifest $Manifest --output $CvOutput
    if ($LASTEXITCODE -ne 0) {
        throw "ActualText post-processing failed with exit code $LASTEXITCODE"
    }

    typst compile --input "language=$Language" $LetterSource $LetterOutput
}
finally {
    Pop-Location
}
