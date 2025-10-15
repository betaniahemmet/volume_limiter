# Se till att svenska tecken visas rätt
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

$AppName = "VolumeLimiter"
$InstallDir = "C:\Program Files\$AppName"
$Startup = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $Startup "$AppName.lnk"

function Fail($msg) {
    Write-Host "`nFEL: $msg" -ForegroundColor Red
    Write-Host "Avinstallationen avbryts."
    Read-Host "Tryck ENTER för att stänga"
    exit 1
}

Clear-Host
Write-Host "============================================"
Write-Host "   $AppName – Avinstallationsprogram"
Write-Host "============================================`n"

# Stoppa processen om den körs
$proc = Get-Process -Name "volume_limiter" -ErrorAction SilentlyContinue
if ($proc) {
    Write-Host "Stoppar körande process..."
    try {
        Stop-Process -Name "volume_limiter" -Force -ErrorAction Stop
        Start-Sleep -Milliseconds 700
    }
    catch {
        Fail "Kunde inte stoppa processen: $($_.Exception.Message)"
    }
}

# Ta bort autostart-genväg
if (Test-Path $ShortcutPath) {
    Write-Host "Tar bort autostart-genväg..."
    try {
        Remove-Item -Force $ShortcutPath -ErrorAction Stop
        Write-Host "Genväg borttagen."
    }
    catch {
        Fail "Kunde inte ta bort genvägen: $($_.Exception.Message)"
    }
}
else {
    Write-Host "Ingen autostart-genväg hittades."
}

# Ta bort installationsmapp
if (Test-Path $InstallDir) {
    Write-Host "Tar bort installationsmapp..."
    try {
        Remove-Item -Recurse -Force $InstallDir -ErrorAction Stop
    }
    catch {
        Fail "Kunde inte ta bort ${InstallDir}: $($_.Exception.Message)"
    }

    if (Test-Path $InstallDir) {
        Fail "Filer finns kvar i ${InstallDir} – kunde inte tas bort."
    }

    Write-Host "Mapp borttagen: ${InstallDir}"
}
else {
    Write-Host "Ingen installationsmapp hittades."
}

Write-Host "`nAvinstallationen slutförd utan fel."
Read-Host "Tryck ENTER för att stänga"
exit 0

