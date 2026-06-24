# Base DPC — Instalador completo (un solo comando)
# Ejecutar desde cualquier lugar:
#   powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/juosoriol/base-dpc/main/instalar.ps1 | iex"

param(
    [switch]$SinAbrir
)

$ErrorActionPreference = "Stop"
$ProjectPath = "C:\dev\BaseDPC"
$RepoUrl = "https://github.com/juosoriol/base-dpc.git"
$OldPath = "C:\Users\juoso\OneDrive\Escritorio\BaseConocimiento"

function Write-Step([string]$Msg) {
    Write-Host "  $Msg" -ForegroundColor Green
}

function Test-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host ""
        Write-Host "ERROR: Git no está instalado." -ForegroundColor Red
        Write-Host "Descárgalo en: https://git-scm.com/download/win" -ForegroundColor Yellow
        Write-Host "Reinicia PowerShell después de instalarlo y vuelve a ejecutar este script." -ForegroundColor Yellow
        exit 1
    }
}

function Ensure-Project {
    if (-not (Test-Path "C:\dev")) {
        New-Item -ItemType Directory -Path "C:\dev" | Out-Null
        Write-Step "Carpeta C:\dev creada"
    }

    if (Test-Path $ProjectPath) {
        if (Test-Path "$ProjectPath\.git") {
            Set-Location $ProjectPath
            git fetch origin 2>$null
            git pull origin main
            if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
            Write-Step "Repositorio actualizado"
            return
        }
        Write-Host "ERROR: $ProjectPath existe pero no es un repositorio git." -ForegroundColor Red
        exit 1
    }

    git clone $RepoUrl $ProjectPath
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Set-Location $ProjectPath
    Write-Step "Repositorio clonado en $ProjectPath"
}

function New-DesktopShortcut {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "Base DPC.lnk"
    $indexPath = Join-Path $ProjectPath "index.html"

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $indexPath
    $shortcut.WorkingDirectory = $ProjectPath
    $shortcut.Description = "Base de conocimiento DPC — Contraloría de Bogotá"
    $shortcut.Save()
    Write-Step "Acceso directo creado en el escritorio"
}

function Open-Editor {
    $workspace = Join-Path $ProjectPath "BaseDPC.code-workspace"
    if (Get-Command cursor -ErrorAction SilentlyContinue) {
        Start-Process cursor -ArgumentList $workspace
        Write-Step "Proyecto abierto en Cursor"
        return
    }
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process code -ArgumentList $workspace
        Write-Step "Proyecto abierto en VS Code"
        return
    }
    Write-Host "  (Cursor/VS Code no detectado — abre manualmente $ProjectPath)" -ForegroundColor Gray
}

function Show-MigrationNote {
    if (Test-Path $OldPath) {
        Write-Host ""
        Write-Host "NOTA: Detectada copia anterior en:" -ForegroundColor Yellow
        Write-Host "  $OldPath" -ForegroundColor Gray
        Write-Host "Los datos de la app están en el navegador (localStorage)." -ForegroundColor Gray
        Write-Host "Exporta un JSON desde la app antigua e impórtalo en la nueva si necesitas migrar datos." -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== Base DPC — Instalación completa ===" -ForegroundColor Cyan
Write-Host ""

Test-Git
Ensure-Project
New-DesktopShortcut
Show-MigrationNote

if (-not $SinAbrir) {
    Open-Editor
}

Write-Host ""
Write-Host "Listo. Proyecto en: $ProjectPath" -ForegroundColor Green
Write-Host ""
Write-Host "Abrir app:     doble clic en 'Base DPC' del escritorio" -ForegroundColor White
Write-Host "Desarrollo:    cd C:\dev\BaseDPC && .\serve.ps1" -ForegroundColor White
Write-Host "En Cursor:     F5 para servidor + navegador" -ForegroundColor White
Write-Host ""
