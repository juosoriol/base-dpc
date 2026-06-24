@echo off
title Base DPC - Instalador
echo.
echo === Base DPC - Instalacion completa ===
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1"
echo.
pause
