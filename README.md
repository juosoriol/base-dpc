# Base DPC — Contraloría de Bogotá

Base de conocimiento para la Dirección de Procesos de Control (DPC). Aplicación web de un solo archivo (`index.html`) sin dependencias locales.

## Instalación rápida (un solo comando)

Abre **PowerShell** y pega esto:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/juosoriol/base-dpc/main/instalar.ps1 | iex"
```

Eso hace todo automáticamente:
- Crea `C:\dev\BaseDPC`
- Clona o actualiza el repositorio
- Crea acceso directo en el escritorio
- Abre el proyecto en Cursor o VS Code (si están instalados)

## Requisitos

- [Git](https://git-scm.com/download/win)
- Navegador moderno (Chrome, Edge, Firefox o Safari)
- Python 3 (opcional, solo para servidor local de desarrollo)

## Instalación manual

Si ya tienes el repositorio clonado:

```powershell
cd C:\dev\BaseDPC
.\instalar.ps1
```

O doble clic en `instalar.bat`.

Para solo actualizar:

```powershell
cd C:\dev\BaseDPC
.\setup.ps1 -Update
```

## Uso

### Abrir la aplicación

- Doble clic en **Base DPC** del escritorio
- O abre `C:\dev\BaseDPC\index.html`

### Servidor de desarrollo

```powershell
cd C:\dev\BaseDPC
.\serve.ps1
```

Luego abre [http://localhost:3000](http://localhost:3000).

### VS Code / Cursor

1. Abre `BaseDPC.code-workspace` (o la carpeta `C:\dev\BaseDPC`)
2. Pulsa **F5** → servidor + navegador automático

## Estructura

```
C:\dev\BaseDPC\
├── index.html              ← aplicación completa
├── BaseDPC.code-workspace  ← abrir en Cursor/VS Code
├── instalar.ps1            ← instalador completo
├── instalar.bat            ← doble clic para instalar
├── setup.ps1               ← clonar/actualizar
├── serve.ps1               ← servidor local (puerto 3000)
├── README.md
├── CLAUDE.md
└── .vscode/
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
