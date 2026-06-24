#!/usr/bin/env bash
# Inicia servidor de desarrollo en http://localhost:3000
PORT=3000
echo "Base DPC — servidor en http://localhost:$PORT"
echo "Ctrl+C para detener"
python3 -m http.server "$PORT"
