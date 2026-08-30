@echo off
title Base DPC - Actualizar
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0actualizar.ps1"
if errorlevel 1 (
  echo.
  echo ERROR durante la actualizacion.
  pause
  exit /b 1
)
exit /b 0
