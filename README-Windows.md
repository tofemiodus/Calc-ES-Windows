# Calc ES for Windows

See the [Windows app README](README.md) for the current desktop and web app
installation instructions, release downloads, build steps, features, and license
terms.
# Calc ES for Windows

This Windows edition runs the Calc ES web application as an offline desktop
window. It uses the same HTML, CSS, and JavaScript as the hosted web app, so
the calculator, linear/quadratic and multi-equation solvers, polynomial roots
and factorization, graphing, fractions and mixed numbers, permutations and
combinations, and matrix operations are available without Python or GTK.
The Linux-only GTK interface is not used by this Windows launcher.

## Install

1. Download and extract the Windows source bundle from this repository's
   [Releases](https://github.com/tofemiodus/Calc-ES-Windows/releases/latest).
2. Double-click `install-windows.cmd`.
3. Launch **Calc ES** from the Desktop or Start menu.

The installer copies the web app files to `%LOCALAPPDATA%\Programs\Calc ES`.
When Microsoft Edge is installed, it opens the app in an Edge app window;
otherwise it opens in the default browser.

To run without installing, open `index.html` in a modern browser.

## Source and license

The desktop entry point and web application are included in this repository.
Private non-commercial use and private modification are permitted by the
[Calc ES Source Available License](LICENSE). Public redistribution and
commercial use require written permission. See [TRADEMARKS.md](TRADEMARKS.md).

Submit ideas or feature requests in the repository's **Ideas** discussion.
