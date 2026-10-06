# Calc ES for Windows

Calc ES is a scientific calculator and mathematics workbench with a Windows
desktop application and a separate browser version. Both use the same
HTML/CSS/JavaScript calculator implementation, so the tools and calculations
stay consistent between them.

## Try the web app

Use the [Calc ES web app](https://tofemiodus.github.io/Calc-ES-Windows/) or
open `index.html` in a modern browser. It works offline and needs no account.
The Windows desktop app includes the same files under `wwwroot/`.

## Download and install the Windows desktop app

1. Download the latest **Windows x64** package from
   [GitHub Releases](https://github.com/tofemiodus/Calc-ES-Windows/releases/latest).
2. Extract the ZIP, then run `install-windows.cmd`.
3. Start **Calc ES** from the Desktop shortcut or Start menu.

The desktop application is a native Windows Forms window hosting the shared
calculator through Microsoft Edge WebView2. Install the free
[Evergreen WebView2 Runtime](https://developer.microsoft.com/microsoft-edge/webview2/)
if Windows reports that it is missing. The calculator itself runs offline
after installation.

## Build from source

Install the .NET 10 SDK on Windows, then run:

```powershell
dotnet publish .\CalcES.Windows.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -o .\publish
```

The published executable uses `wwwroot/index.html`, `wwwroot/toto.css`,
`wwwroot/toto.js`, and `wwwroot/logo.svg`. Keep these assets beside the
executable in the `wwwroot` folder. GitHub Actions also builds the Windows
package on pushes and attaches a ZIP to version-tag releases.

## Features

The shared calculator provides scientific calculations, linear/quadratic and
simultaneous equation solving, polynomial roots and factorization, graphing,
fraction conversion, permutations/combinations, and matrix operations.

## Source, license, and marks

This repository is distributed under the
[Calc ES Source Available License](LICENSE): private non-commercial use and
private modifications are permitted; redistribution and commercial use are
not. Earlier AGPL-licensed releases retain the terms that accompanied them.
See [TRADEMARKS.md](TRADEMARKS.md) for the name and logo notice.

This is a custom source-available license, not standard BSL 1.1. The trademark
notice does not register a trademark; consider legal advice on licensing and
trademark registration.
