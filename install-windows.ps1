$ErrorActionPreference = "Stop"

$sourceDirectory = $PSScriptRoot
$installDirectory = Join-Path $env:LOCALAPPDATA "ProgramsCalc ES"
$desktopDirectory = [Environment]::GetFolderPath("Desktop")
$startMenuDirectory = Join-Path $env:APPDATA "MicrosoftWindowsStart MenuPrograms"
$applicationFile = Join-Path $sourceDirectory "CalcES.exe"
$webAssets = Join-Path $sourceDirectory "wwwroot"

if (-not (Test-Path -LiteralPath $applicationFile -PathType Leaf)) {
    throw "CalcES.exe is missing. Download and extract the Windows release package before running this installer."
}
foreach ($file in @("index.html", "toto.css", "toto.js", "logo.svg")) {
    if (-not (Test-Path -LiteralPath (Join-Path $webAssets $file) -PathType Leaf)) {
        throw "Required Calc ES web asset is missing: $(Join-Path $webAssets $file)"
    }
}

New-Item -ItemType Directory -Force -Path $installDirectory, $startMenuDirectory | Out-Null
Get-ChildItem -LiteralPath $sourceDirectory -File |
    Where-Object { $_.Extension -in @(".exe", ".dll", ".json") } |
    ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $installDirectory -Force
    }
Copy-Item -LiteralPath $webAssets -Destination $installDirectory -Recurse -Force
foreach ($file in @("LICENSE", "README.md", "TRADEMARKS.md")) {
    $sourceFile = Join-Path $sourceDirectory $file
    if (Test-Path -LiteralPath $sourceFile -PathType Leaf) {
        Copy-Item -LiteralPath $sourceFile -Destination $installDirectory -Force
    }
}

foreach ($shortcutPath in @(
    (Join-Path $desktopDirectory "Calc ES.lnk"),
    (Join-Path $startMenuDirectory "Calc ES.lnk")
)) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutPath)
    $shortcut.TargetPath = Join-Path $installDirectory "CalcES.exe"
    $shortcut.WorkingDirectory = $installDirectory
    $shortcut.Description = "Calc ES scientific calculator"
    $shortcut.Save()
}

Write-Output "Calc ES for Windows is installed. Launch it from the Desktop or Start menu."
