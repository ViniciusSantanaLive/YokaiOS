@echo off
title YokaiOS Installer
color 0B

echo.
echo  ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
echo  ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
echo  ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
echo   Windows Gaming Optimizer
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] This installer requires Administrator privileges!
    echo [*] Right-click and select "Run as Administrator"
    pause
    exit /b 1
)

echo [*] Starting YokaiOS installation...
echo.

:: Run PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0Install-YokaiOS.ps1"

echo.
echo [*] Installation complete!
pause
