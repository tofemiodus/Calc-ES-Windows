$ErrorActionPreference = "Stop"

$sourceDirectory = $PSScriptRoot
$installDirectory = Join-Path $env:LOCALAPPDATA "Programs\Calc ES"
$desktopDirectory = [Environment]::GetFolderPath("Desktop")
$startMenuDirectory = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$requiredFiles = @("index.html", "toto.css", "toto.js", "logo.svg")

foreach ($file in $requiredFiles) {
    $sourceFile = Join-Path $sourceDirectory $file
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
        throw "Required Calc ES file is missing: $sourceFile"
    }
}

New-Item -ItemType Directory -Force -Path $installDirectory, $startMenuDirectory | Out-Null
foreach ($file in $requiredFiles) {
    Copy-Item -LiteralPath (Join-Path $sourceDirectory $file) -Destination $installDirectory -Force
}

$indexPath = Join-Path $installDirectory "index.html"
$edgeCandidates = @(
    (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\Application\msedge.exe")
)
$edgePath = $edgeCandidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1

foreach ($shortcutPath in @(
    (Join-Path $desktopDirectory "Calc ES.lnk"),
    (Join-Path $startMenuDirectory "Calc ES.lnk")
)) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutPath)
    if ($edgePath) {
        $shortcut.TargetPath = $edgePath
        $shortcut.Arguments = "--app=`"$([Uri]::new($indexPath).AbsoluteUri)`""
        $shortcut.WorkingDirectory = $installDirectory
    }
    else {
        $shortcut.TargetPath = $indexPath
        $shortcut.WorkingDirectory = $installDirectory
    }
    $shortcut.Description = "Calc ES scientific calculator"
    $shortcut.Save()
}

Write-Output "Calc ES is installed. Launch it from the Desktop or Start menu."
if (-not $edgePath) {
    Write-Output "Microsoft Edge was not found; Calc ES will open in your default browser."
}
