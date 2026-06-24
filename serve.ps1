# Inicia servidor de desarrollo en http://localhost:3000
$Port = 3000
Write-Host "Base DPC — servidor en http://localhost:$Port" -ForegroundColor Cyan
Write-Host "Ctrl+C para detener" -ForegroundColor Gray
python -m http.server $Port
