# Base DPC — Script de instalación y actualización
# Uso: .\setup.ps1          (instalación inicial)
#      .\setup.ps1 -Update  (actualizar repositorio existente)
#      .\setup.ps1 -Todo    (instalación completa con acceso directo y editor)

param(
    [switch]$Update,
    [switch]$Todo
)

if ($Todo) {
    & "$PSScriptRoot\instalar.ps1"
    exit $LASTEXITCODE
}

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
        if (Test-Path "$ProjectPath\.git") {
            Set-Location $ProjectPath
            git fetch origin
            git pull origin main
            if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
            Write-Host "  Repositorio actualizado." -ForegroundColor Green
            return
        }
        Write-Host "  La carpeta $ProjectPath ya existe (no es git)." -ForegroundColor Yellow
        Write-Host "  Usa: .\instalar.ps1  para instalación completa." -ForegroundColor Yellow
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
Write-Host "Instalación completa:  .\instalar.ps1" -ForegroundColor White
Write-Host "Abrir app:             doble clic en index.html" -ForegroundColor Gray
Write-Host "Servidor desarrollo:   .\serve.ps1" -ForegroundColor Gray
Write-Host "En Cursor/VS Code:     F5" -ForegroundColor Gray
