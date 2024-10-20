# self-elevate if not running as an administrator
$myWindowsIdentity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $myWindowsIdentity.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    return
}

try
{
    winget search --accept-source-agreements somethingthatdoesnotexist >$null
    Write-Host ">>> 7zip.7zip"
    winget install -e --id 7zip.7zip
    Write-Host ">>> Audacity.Audacity"
    winget install -e --id Audacity.Audacity
    Write-Host ">>> cthoeing.PasswordTech"
    winget install -e --id cthoeing.PasswordTech
    Write-Host ">>> Docker.DockerDesktop"
    winget install -e --id Docker.DockerDesktop
    Write-Host ">>> DominikReichl.KeePass"
    winget install -e --id DominikReichl.KeePass
    Write-Host ">>> GIMP.GIMP"
    winget install -e --id GIMP.GIMP
    Write-Host ">>> Git.Git"
    winget install -e --id Git.Git
    Write-Host ">>> Google.Chrome"
    winget install -e --id Google.Chrome
    Write-Host ">>> Google.EarthPro"
    winget install -e --id Google.EarthPro
    Write-Host ">>> Google.GoogleDrive"
    winget install -e --id Google.GoogleDrive
    Write-Host ">>> Google.PlatformTools"
    winget install -e --id Google.PlatformTools
    Write-Host ">>> Inkscape.Inkscape"
    winget install -e --id Inkscape.Inkscape
    Write-Host ">>> JoachimEibl.KDiff3"
    winget install -e --id JoachimEibl.KDiff3
    Write-Host ">>> Kubernetes.minikube"
    winget install -e --id Kubernetes.minikube
    Write-Host ">>> Microsoft.AzureCLI"
    winget install -e --id Microsoft.AzureCLI
    Write-Host ">>> Microsoft.VisualStudio.2022.Community"
    winget install -e --id Microsoft.VisualStudio.2022.Community
    Write-Host ">>> Microsoft.VisualStudio.2022.Community - added component workloads:"
    Write-Host "... https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2022"
    Write-Host "... .NET desktop development"
    Write-Host "... ASP.NET and web development"
    Write-Host "... Python development + native development"
    winget install -e --id Microsoft.VisualStudio.2022.Community --force --override (
        "--passive --add " +
        "Microsoft.VisualStudio.Workload.ManagedDesktop " +
        "Microsoft.VisualStudio.Workload.NetWeb " +
        "Microsoft.VisualStudio.Workload.Python " +
        "Microsoft.ComponentGroup.PythonTools.NativeDevelopment")
    Write-Host ">>> Microsoft.WindowsTerminal"
    winget install -e --id Microsoft.WindowsTerminal
    Write-Host ">>> Musescore.Musescore"
    winget install -e --id Musescore.Musescore
    Write-Host ">>> Notepad++.Notepad++"
    winget install -e --id Notepad++.Notepad++
    Write-Host ">>> Oracle.VirtualBox"
    winget install -e --id Oracle.VirtualBox
    Write-Host ">>> PuTTY.PuTTY"
    winget install -e --id PuTTY.PuTTY
    # Python requires admin privileges due to global launcher, but is installed inside user's AppData folder
    Write-Host ">>> Python.Python.3.9"
    winget install --scope user -e --id Python.Python.3.9
    Write-Host ">>> Python.Python.3.10"
    winget install --scope user -e --id Python.Python.3.10
    Write-Host ">>> Python.Python.3.11"
    winget install --scope user -e --id Python.Python.3.11
    Write-Host ">>> Python.Python.3.12"
    winget install --scope user -e --id Python.Python.3.12
    Write-Host ">>> Seagate.SeaTools.Legacy"
    winget install -e --id Seagate.SeaTools.Legacy
    Write-Host ">>> TeamViewer.TeamViewer"
    winget install -e --id TeamViewer.TeamViewer
    Write-Host ">>> TheDocumentFoundation.LibreOffice"
    winget install -e --id TheDocumentFoundation.LibreOffice
    Write-Host ">>> Valve.Steam"
    winget install -e --id Valve.Steam
    Write-Host ">>> VideoLAN.VLC"
    winget install -e --id VideoLAN.VLC
    Write-Host ">>> WinMerge.WinMerge"
    winget install -e --id WinMerge.WinMerge
    Write-Host ">>> Zoom.Zoom"
    winget install -e --id Zoom.Zoom
}
finally
{
    if (-not $psISE)
    {
        Write-Host -NoNewLine 'Press ENTER to exit...'
        while ($Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode -ne 13)
        {}
        Write-Host
    }
}
