@echo off
:: Auto-elevate to admin if needed
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal

:: Define adapter names
set "wifi=Wi-Fi"
set "ethernet=Ethernet"

:: Get Wi-Fi status using PowerShell
for /f "delims=" %%a in ('powershell -Command "(Get-NetAdapter -Name \"%wifi%\").Status"') do (
    set "wifiStatus=%%a"
)

echo Current Wi-Fi status: %wifiStatus%
echo.

if /I "%wifiStatus%"=="Up" (
    echo Wi-Fi is ON. Turning it OFF and enabling Ethernet...
    netsh interface set interface "%wifi%" admin=disable
    timeout /t 2 >nul
    netsh interface set interface "%ethernet%" admin=enable
) else (
    echo Wi-Fi is OFF. Turning it ON and disabling Ethernet...
    netsh interface set interface "%ethernet%" admin=disable
    timeout /t 2 >nul
    netsh interface set interface "%wifi%" admin=enable
)

echo.
echo Done.
pause
