using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;
using System.Windows.Forms;

namespace CalcES.Windows;

internal sealed class MainForm : Form
{
    private const string AppHost = "calc-es.local";
    private readonly WebView2 webView = new() { Dock = DockStyle.Fill };

    public MainForm()
    {
        Text = "Calc ES";
        StartPosition = FormStartPosition.CenterScreen;
        MinimumSize = new Size(760, 620);
        Size = new Size(1280, 900);
        Controls.Add(webView);
        Shown += InitializeWebView;
    }

    private async void InitializeWebView(object? sender, EventArgs e)
    {
        var webRoot = Path.Combine(AppContext.BaseDirectory, "wwwroot");
        var startPage = Path.Combine(webRoot, "index.html");
        if (!File.Exists(startPage))
        {
            MessageBox.Show(
                this,
                $"The Calc ES web files are missing from:\n{webRoot}",
                "Calc ES could not start",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
            return;
        }

        try
        {
            var userDataFolder = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "Calc ES",
                "WebView2");
            Directory.CreateDirectory(userDataFolder);
            var environment = await CoreWebView2Environment.CreateAsync(
                userDataFolder: userDataFolder);
            await webView.EnsureCoreWebView2Async(environment);
            webView.CoreWebView2.SetVirtualHostNameToFolderMapping(
                AppHost,
                webRoot,
                CoreWebView2HostResourceAccessKind.DenyCors);
            webView.CoreWebView2.NavigationStarting += CancelExternalNavigation;
            webView.Source = new Uri($"https://{AppHost}/index.html");
        }
        catch (WebView2RuntimeNotFoundException)
        {
            MessageBox.Show(
                this,
                "Calc ES needs the Microsoft Edge WebView2 Runtime. Install the free Evergreen Runtime from microsoft.com/edge/webview2, then start Calc ES again.",
                "WebView2 Runtime required",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
        }
        catch (IOException exception)
        {
            MessageBox.Show(
                this,
                $"Calc ES could not access its local app files.\n\n{exception.Message}",
                "Calc ES could not start",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
        }
        catch (UnauthorizedAccessException exception)
        {
            MessageBox.Show(
                this,
                $"Calc ES could not access its app data folder.\n\n{exception.Message}",
                "Calc ES could not start",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
        }
        catch (InvalidOperationException exception)
        {
            MessageBox.Show(
                this,
                $"The Calc ES browser component could not initialize.\n\n{exception.Message}",
                "Calc ES could not start",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
        }
        catch (COMException exception)
        {
            MessageBox.Show(
                this,
                $"The WebView2 runtime could not start Calc ES.\n\n{exception.Message}",
                "Calc ES could not start",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Close();
        }
    }

    private static void CancelExternalNavigation(
        object? sender,
        CoreWebView2NavigationStartingEventArgs eventArgs)
    {
        if (!Uri.TryCreate(eventArgs.Uri, UriKind.Absolute, out var target)
            || target.Scheme != Uri.UriSchemeHttps
            || !string.Equals(target.Host, AppHost, StringComparison.OrdinalIgnoreCase))
        {
            eventArgs.Cancel = true;
        }
    }
}
