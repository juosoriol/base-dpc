# Base DPC — Contraloría de Bogotá

Base de conocimiento para la Dirección de Procesos de Control (DPC). Aplicación web de un solo archivo (`index.html`) sin dependencias locales.

## Requisitos

- [Git](https://git-scm.com/download/win)
- Navegador moderno (Chrome, Edge, Firefox o Safari)
- Python 3 (opcional, solo para servidor local de desarrollo)

## Instalación en Windows

### Opción 1: Script automático (recomendado)

Abre PowerShell y ejecuta:

```powershell
git clone https://github.com/juosoriol/base-dpc.git C:\dev\BaseDPC
cd C:\dev\BaseDPC
.\setup.ps1
```

Si ya tienes el repositorio clonado y solo quieres actualizarlo:

```powershell
cd C:\dev\BaseDPC
.\setup.ps1 -Update
```

### Opción 2: Manual

```powershell
# Crear carpeta de desarrollo
New-Item -ItemType Directory -Force -Path C:\dev

# Clonar repositorio
git clone https://github.com/juosoriol/base-dpc.git C:\dev\BaseDPC

# Entrar al proyecto
cd C:\dev\BaseDPC
```

## Uso

### Abrir la aplicación

Doble clic en `index.html` o arrástralo al navegador.

### Servidor de desarrollo (opcional)

```powershell
cd C:\dev\BaseDPC
.\serve.ps1
```

Luego abre [http://localhost:3000](http://localhost:3000).

### VS Code / Cursor

1. Abre la carpeta `C:\dev\BaseDPC` como workspace
2. Pulsa **F5** o ejecuta **Run > Base DPC (navegador)**
3. Se inicia el servidor y se abre el navegador automáticamente

## Actualizar el proyecto

```powershell
cd C:\dev\BaseDPC
git pull origin main
```

## Estructura

```
C:\dev\BaseDPC\
├── index.html          ← aplicación completa (HTML + CSS + JS)
├── CLAUDE.md           ← documentación para asistentes de IA
├── README.md           ← este archivo
├── setup.ps1           ← instalación/actualización
├── serve.ps1           ← servidor de desarrollo (Windows)
├── serve.sh            ← servidor de desarrollo (Linux/Mac)
├── .gitignore
└── .vscode/            ← configuración de depuración en VS Code/Cursor
    ├── launch.json
    └── tasks.json
```

## Funcionalidades

- Entradas con editor Quill, categorías, etiquetas y favoritos
- Variables `{{ETIQUETA}}` rellenables antes de copiar
- Cargos con valores predefinidos
- Copiar para Word (HTML enriquecido)
- Exportar/Importar JSON
- Convertidor número → letras
- Modo oscuro e impresión

## Repositorio

https://github.com/juosoriol/base-dpc
