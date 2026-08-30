# Base DPC — Actualización automática (un solo comando)
# Descarga la última versión, inicia servidor local y abre la app sin caché.
#
# Desde cualquier lugar:
#   powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/juosoriol/base-dpc/main/actualizar.ps1 | iex"
#
# Desde el proyecto:
#   .\actualizar.ps1

param(
    [switch]$SinAbrir,
    [int]$Puerto = 3000
)

$ErrorActionPreference = "Stop"
$ProjectPath = "C:\dev\BaseDPC"
$RepoUrl = "https://github.com/juosoriol/base-dpc.git"
$PidFile = Join-Path $ProjectPath ".serve.pid"

function Write-Ok([string]$Msg) {
    Write-Host "  $Msg" -ForegroundColor Green
}

function Write-Info([string]$Msg) {
    Write-Host "  $Msg" -ForegroundColor Cyan
}

function Test-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host ""
        Write-Host "ERROR: Git no está instalado." -ForegroundColor Red
        Write-Host "Descárgalo en: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
}

function Ensure-Project {
    if (-not (Test-Path "C:\dev")) {
        New-Item -ItemType Directory -Path "C:\dev" | Out-Null
        Write-Ok "Carpeta C:\dev creada"
    }

    if (-not (Test-Path $ProjectPath)) {
        Write-Info "Instalando Base DPC por primera vez..."
        git clone $RepoUrl $ProjectPath
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Write-Ok "Repositorio clonado en $ProjectPath"
        return
    }

    if (-not (Test-Path (Join-Path $ProjectPath ".git"))) {
        Write-Host "ERROR: $ProjectPath existe pero no es un repositorio git." -ForegroundColor Red
        Write-Host "Ejecuta el instalador completo: instalar.ps1" -ForegroundColor Yellow
        exit 1
    }

    Set-Location $ProjectPath
    Write-Info "Actualizando desde GitHub..."
    git fetch origin 2>$null
    git pull origin main
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Ok "Repositorio actualizado"
}

function Get-PythonCommand {
    if (Get-Command python -ErrorAction SilentlyContinue) { return "python" }
    if (Get-Command py -ErrorAction SilentlyContinue) { return "py" }
    return $null
}

function Stop-ExistingServer {
    if (-not (Test-Path $PidFile)) { return }
    try {
        $oldPid = [int](Get-Content $PidFile -Raw).Trim()
        $proc = Get-Process -Id $oldPid -ErrorAction SilentlyContinue
        if ($proc -and $proc.ProcessName -match "python") {
            Stop-Process -Id $oldPid -Force -ErrorAction SilentlyContinue
        }
    } catch {}
    Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
}

function Start-DevServer {
    param([int]$Port)

    $py = Get-PythonCommand
    if (-not $py) {
        Write-Host ""
        Write-Host "AVISO: Python no detectado. Se abrirá index.html directamente." -ForegroundColor Yellow
        Write-Host "Para evitar caché del navegador, instala Python 3." -ForegroundColor Yellow
        return $false
    }

    Stop-ExistingServer

    $args = @("-m", "http.server", "$Port")
    if ($py -eq "py") { $args = @("-3", "-m", "http.server", "$Port") }

    $proc = Start-Process -FilePath $py -ArgumentList $args `
        -WorkingDirectory $ProjectPath `
        -WindowStyle Hidden `
        -PassThru

    $proc.Id | Out-File -FilePath $PidFile -Encoding ascii -Force
    Start-Sleep -Milliseconds 800

    if ($proc.HasExited) {
        Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
        Write-Host "AVISO: No se pudo iniciar el servidor en el puerto $Port." -ForegroundColor Yellow
        return $false
    }

    Write-Ok "Servidor local en http://localhost:$Port"
    return $true
}

function Open-App {
    param(
        [bool]$UseServer,
        [int]$Port,
        [string]$VersionTag
    )

    if ($UseServer) {
        $url = "http://localhost:$Port/?v=$VersionTag"
    } else {
        $index = Join-Path $ProjectPath "index.html"
        $url = "$index`?v=$VersionTag"
    }

    Start-Process $url
    Write-Ok "Aplicación abierta en el navegador"
}

function Update-DesktopShortcut {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "Base DPC.lnk"
    $updater = Join-Path $ProjectPath "actualizar.bat"

    if (-not (Test-Path $updater)) { return }

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $updater
    $shortcut.WorkingDirectory = $ProjectPath
    $shortcut.Description = "Base DPC — actualiza y abre la app"
    $shortcut.Save()
    Write-Ok "Acceso directo del escritorio apunta a actualización automática"
}

Write-Host ""
Write-Host "=== Base DPC — Actualización automática ===" -ForegroundColor Cyan
Write-Host ""

Test-Git
Ensure-Project
Set-Location $ProjectPath

$commit = (git rev-parse --short HEAD).Trim()
$versionTag = "$commit-$(Get-Date -Format 'yyyyMMdd')"

Update-DesktopShortcut

if (-not $SinAbrir) {
    $serverOk = Start-DevServer -Port $Puerto
    Open-App -UseServer $serverOk -Port $Puerto -VersionTag $versionTag
}

Write-Host ""
Write-Host "Listo — versión $commit" -ForegroundColor Green
Write-Host "Proyecto: $ProjectPath" -ForegroundColor Gray
Write-Host ""
Write-Host "Uso diario: doble clic en 'Base DPC' del escritorio" -ForegroundColor White
Write-Host "O ejecuta:  .\actualizar.ps1" -ForegroundColor White
Write-Host ""
