# Base DPC — Contraloría de Bogotá

## Qué es este proyecto
Base de conocimiento para la Dirección de Procesos de Control (DPC) de la Contraloría de Bogotá. App web **single-file** (`index.html`) sin dependencias locales: todo el CSS y JS está inline; la única dependencia externa es Quill.js (CDN).

## Ruta del proyecto
```
C:\Users\juoso\OneDrive\Escritorio\BaseConocimiento\
└── index.html   ← único archivo de la app
```

## Stack
- **HTML/CSS/JS puro** — sin frameworks, sin build step, sin npm
- **Quill.js 1.3.7** — editor de texto enriquecido (CDN)
- **localStorage** — persistencia de datos (sin backend)
- **Inter** — fuente (Google Fonts CDN)

## Claves de localStorage
| Clave | Contenido |
|---|---|
| `kb_dpc_v3` | Entradas y categorías |
| `kb_tags_v3` | Etiquetas (variables `{{TAG}}`) |
| `kb_tag_defaults_v1` | Valores por defecto de etiquetas |
| `kb_cargos_v1` | Cargos (conjuntos de valores pre-llenados) |
| `kb_theme` | `"light"` / `"dark"` |

## Estructura de una entrada
```js
{
  id: string,        // uid()
  title: string,
  categoryId: string,
  html: string,      // contenido Quill (HTML)
  body: string,      // texto plano legado
  tags: string[],    // etiquetas de búsqueda
  favorite: boolean,
  usageCount: number,
  versions: [],      // historial de versiones
  createdAt: number, // timestamp
  updatedAt: number
}
```

## Funcionalidades principales
- **Entradas** con editor Quill, categorías, etiquetas de búsqueda, favoritos, historial de versiones
- **Variables `{{ETIQUETA}}`** — se insertan en el contenido y se rellenan antes de copiar
- **Cargos** — conjuntos de valores pre-definidos para las variables (ej. Auditor, Supervisor)
- **Copiar para Word** — copia el HTML como texto enriquecido al portapapeles
- **Exportar/Importar JSON** — backup completo de los datos
- **Convertidor número→letras** — integrado en el editor
- **Modo oscuro** — toggle en el header
- **Impresión** — estilos de print incluidos

## Convenciones de código
- **Sin alert(), confirm() ni prompt()** — usar toasts y modales propios (`showToast()`, modales `.overlay`)
- **Sin comentarios innecesarios** — el código se explica por los nombres
- Todo en español (UI, variables, funciones) salvo el código JS estándar
- Las funciones de render empiezan con `render*`, las de modal con `open*`/`close*`

## Flujo de datos
1. Al cargar: `loadState()` lee localStorage o usa `SEED_DATA`
2. Cambios: `save()` persiste `state` a localStorage
3. UI: `renderAll()` → `renderSidebar()` + `renderStats()` + `renderTagFilters()` + `renderEntries()`

## Cómo probar cambios
Abrir `index.html` directamente en el navegador — no requiere servidor.

## Pendientes conocidos
- Git no inicializado aún (pendiente de `git init` + primer commit)
