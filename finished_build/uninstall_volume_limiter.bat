@echo off
:: Run as Administrator if not already
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoLogo -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Use UTF-8 for åäö
chcp 65001 >nul

:: Launch uninstaller PowerShell script
powershell.exe -NoLogo -ExecutionPolicy Bypass -File "%~dp0InstallationFiles\uninstall_volume_limiter.ps1"
pause

