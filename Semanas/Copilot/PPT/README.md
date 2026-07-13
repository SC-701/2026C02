# Instalación de Slidev

Este proyecto usa Slidev para crear presentaciones en formato Markdown.

## Requisitos

- Node.js 18 o superior
- npm o pnpm

## Opción 1: instalar Slidev globalmente

Si quieres usar Slidev desde cualquier carpeta, ejecuta:

```bash
npm install -g @slidev/cli
```

O con pnpm:

```bash
pnpm add -g @slidev/cli
```

## Opción 2: instalarlo en este proyecto

Desde la carpeta del proyecto:

```bash
cd d:\Code\2026C02L\2026C02\Semanas\Copilot\PPT
pnpm install
```

Si prefieres npm:

```bash
npm install
```

## Ejecutar la presentación

```bash
pnpm dev
```

O con npm:

```bash
npm run dev
```

Luego abre en tu navegador:

```text
http://localhost:3030
```

## Editar la presentación

Puedes modificar el archivo [slides.md](./slides.md) para cambiar el contenido de las diapositivas.

## Exportar la presentación

Para exportar a PDF:

```bash
pnpm export-pdf
```

Para exportar a PPTX:

```bash
pnpm export-pptx
```

Más información en la documentación oficial de Slidev: https://sli.dev/
