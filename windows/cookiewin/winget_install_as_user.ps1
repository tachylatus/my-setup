try
{
    winget search --accept-source-agreements somethingthatdoesnotexist >$null
    Write-Host ">>> Canonical.Ubuntu.2204"
    winget install --scope user -e --id Canonical.Ubuntu.2204
    Write-Host ">>> Derailed.k9s"
    winget install --scope user -e --id Derailed.k9s -l "$env:USERPROFILE\bin" -r k9s.exe
    Write-Host ">>> Discord.Discord"
    winget install --scope user -e --id Discord.Discord
    Write-Host ">>> FiloSottile.age"
    winget install --scope user -e --id FiloSottile.age -l "$env:USERPROFILE\bin"
    Write-Host ">>> FluxCD.Flux"
    winget install --scope user -e --id FluxCD.Flux -l "$env:USERPROFILE\bin" -r flux.exe
    Write-Host ">>> jqlang.jq"
    winget install --scope user -e --id jqlang.jq -l "$env:USERPROFILE\bin" -r jq.exe
    Write-Host ">>> Kubernetes.kubectl"
    winget install --scope user -e --id Kubernetes.kubectl -l "$env:USERPROFILE\bin" -r kubectl.exe
    Write-Host ">>> Microsoft.AzureDataStudio"
    winget install --scope user -e --id Microsoft.AzureDataStudio
    Write-Host ">>> Microsoft.VisualStudioCode"
    winget install --scope user -e --id Microsoft.VisualStudioCode
    Write-Host ">>> MikeFarah.yq"
    winget install --scope user -e --id MikeFarah.yq -l "$env:USERPROFILE\bin" -r yq.exe
    Write-Host ">>> Mozilla.SOPS"
    winget install --scope user -e --id Mozilla.SOPS -l "$env:USERPROFILE\bin" -r sops.exe
    Write-Host ">>> OpenWhisperSystems.Signal"
    winget install --scope user -e --id OpenWhisperSystems.Signal
    Write-Host ">>> SlackTechnologies.Slack"
    winget install --scope user -e --id SlackTechnologies.Slack
    Write-Host ">>> WinSCP.WinSCP"
    winget install --scope user -e --id WinSCP.WinSCP

    Write-Host ">>> Gyan.FFmpeg"
    if (Test-Path "$env:USERPROFILE\bin\ffmpeg")
    {
        Write-Host "> Skipped, already exists: $env:USERPROFILE\bin\ffmpeg"
    }
    else
    {
        winget install --scope user -e --id Gyan.FFmpeg -l "$env:USERPROFILE\bin\ffmpeg_winget"
        Write-Host "> Moving to $env:USERPROFILE\bin\ffmpeg"
        Move-Item "$env:USERPROFILE\bin\ffmpeg_winget\ffmpeg-*" "$env:USERPROFILE\bin\ffmpeg"
        Write-Host "> Cleaning up"
        Remove-Item "$env:USERPROFILE\bin\ffmpeg_winget\Gyan.FFmpeg_*.db" -Force
        Remove-Item "$env:USERPROFILE\bin\ffmpeg_winget"
    }

    Write-Host ">>> Checking PATH for USER"
    $userpath = [System.Environment]::GetEnvironmentVariable("PATH","USER")
    if ($userpath.Contains(";$env:USERPROFILE\bin"))
    {
        Write-Host "> Already in PATH: $env:USERPROFILE\bin"
    }
    else
    {
        Write-Host "> Adding to PATH: $env:USERPROFILE\bin"
        $userpath = $userpath + ";$env:USERPROFILE\bin"
        [System.Environment]::SetEnvironmentVariable("PATH", $userpath,"USER")
    }
    if ($userpath.Contains(";$env:USERPROFILE\bin\ffmpeg\bin"))
    {
        Write-Host "> Already in PATH: $env:USERPROFILE\bin\ffmpeg\bin"
    }
    else
    {
        Write-Host "> Adding to User PATH: $env:USERPROFILE\bin\ffmpeg\bin"
        $userpath = $userpath + ";$env:USERPROFILE\bin\ffmpeg\bin"
        [System.Environment]::SetEnvironmentVariable("PATH", $userpath,"USER")
    }
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
