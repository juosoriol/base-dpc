# Base DPC — Script de instalación y actualización
# Uso: .\setup.ps1          (instalación inicial)
#      .\setup.ps1 -Update  (actualizar repositorio existente)

param(
    [switch]$Update
)

$ErrorActionPreference = "Stop"
$ProjectPath = "C:\dev\BaseDPC"
$RepoUrl = "https://github.com/juosoriol/base-dpc.git"

function Test-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "ERROR: Git no está instalado." -ForegroundColor Red
        Write-Host "Descárgalo en: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
}

function Install-Project {
    Write-Host "Instalando Base DPC en $ProjectPath..." -ForegroundColor Cyan

    if (-not (Test-Path "C:\dev")) {
        New-Item -ItemType Directory -Path "C:\dev" | Out-Null
        Write-Host "  Carpeta C:\dev creada." -ForegroundColor Green
    }

    if (Test-Path $ProjectPath) {
        Write-Host "  La carpeta $ProjectPath ya existe." -ForegroundColor Yellow
        Write-Host "  Usa: .\setup.ps1 -Update  para actualizar." -ForegroundColor Yellow
        Set-Location $ProjectPath
        return
    }

    git clone $RepoUrl $ProjectPath
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Set-Location $ProjectPath
    Write-Host "  Repositorio clonado correctamente." -ForegroundColor Green
}

function Update-Project {
    Write-Host "Actualizando Base DPC en $ProjectPath..." -ForegroundColor Cyan

    if (-not (Test-Path $ProjectPath)) {
        Write-Host "  El proyecto no existe en $ProjectPath. Ejecutando instalación..." -ForegroundColor Yellow
        Install-Project
        return
    }

    Set-Location $ProjectPath

    if (-not (Test-Path ".git")) {
        Write-Host "ERROR: $ProjectPath no es un repositorio git." -ForegroundColor Red
        exit 1
    }

    git fetch origin
    git pull origin main
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Write-Host "  Repositorio actualizado." -ForegroundColor Green
}

Test-Git

if ($Update) {
    Update-Project
} else {
    Install-Project
}

Write-Host ""
Write-Host "Base DPC listo en: $ProjectPath" -ForegroundColor Green
Write-Host ""
Write-Host "Para abrir la app:" -ForegroundColor White
Write-Host "  Doble clic en index.html" -ForegroundColor Gray
Write-Host ""
Write-Host "Para servidor de desarrollo:" -ForegroundColor White
Write-Host "  .\serve.ps1" -ForegroundColor Gray
Write-Host "  http://localhost:3000" -ForegroundColor Gray
Write-Host ""
Write-Host "En VS Code / Cursor: F5 o Run > Base DPC (navegador)" -ForegroundColor White
