# Se till att svenska tecken visas rätt
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

$AppName = "VolumeLimiter"
$SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ExeSource = Join-Path $SourceDir "volume_limiter.exe"
$InstallDir = "C:\Program Files\$AppName"
$Startup = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $Startup "$AppName.lnk"

function Fail($msg) {
    Write-Host "`nFEL: $msg" -ForegroundColor Red
    Write-Host "Installationen avbryts."
    Read-Host "Tryck ENTER för att stänga"
    exit 1
}

Clear-Host
Write-Host "============================================"
Write-Host "   $AppName – Installationsprogram"
Write-Host "============================================`n"

# Kontrollera att källfilen finns
if (-not (Test-Path $ExeSource)) {
    Fail "Hittar inte $ExeSource"
}

# Skapa målmapp
try {
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    }
}
catch {
    Fail "Kunde inte skapa mappen ${InstallDir}: $($_.Exception.Message)"
}

# Kopiera filen
try {
    Copy-Item $ExeSource -Destination $InstallDir -Force -ErrorAction Stop
}
catch {
    Fail "Kunde inte kopiera programfilen: $($_.Exception.Message)"
}

# Skapa autostart-genväg
try {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = "$InstallDir\volume_limiter.exe"
    $shortcut.WorkingDirectory = $InstallDir
    $shortcut.Save()
}
catch {
    Fail "Kunde inte skapa autostart-genväg: $($_.Exception.Message)"
}

# Kontrollera att allt verkligen finns
if (-not (Test-Path "$InstallDir\volume_limiter.exe")) {
    Fail "Programfilen saknas efter kopiering."
}
if (-not (Test-Path $ShortcutPath)) {
    Fail "Autostart-genvägen skapades inte."
}

Write-Host "`nInstallationen slutförd utan fel."
Read-Host "Tryck ENTER för att stänga"
exit 0

