# <Nombre del repositorio / producto>

> *Frase corta que describe el propósito del repositorio.*

**Estado:** 🟢 activo · **Versión:** 0.1 · **Última actualización:** YYYY-MM-DD

---

## 📌 Descripción

*Descripción de 3–5 líneas del propósito del repositorio, qué contiene y a quién sirve.*

---

## 🏗️ Estructura del repositorio

```
<repo-name>/
├── .github/            # Personalización Copilot + Actions
│   ├── copilot-instructions.md
│   ├── instructions/
│   ├── prompts/
│   ├── agents/
│   └── workflows/
├── docs/               # Documentación funcional y técnica
│   ├── use-cases/
│   ├── stories/
│   ├── architecture/
│   ├── adr/
│   └── runbooks/
├── src/                # Código fuente
├── tests/              # Pruebas espejando src/
├── scripts/            # Automatizaciones locales
├── samples/            # Ejemplos de uso
├── .editorconfig  .gitignore  .gitattributes
├── CODEOWNERS  LICENSE  SECURITY.md  CHANGELOG.md
└── CONTRIBUTING.md  README.md
```

---

## 🚀 Requisitos previos

- *Herramienta 1 (versión mínima)*
- *Herramienta 2 (versión mínima)*
- *Acceso al npm registry de paquetes*

---

## ⚡ Cómo empezar

```bash
# Clonar el repositorio
git clone <url>

# Instalar dependencias
<comando de instalación>

# Ejecutar en modo desarrollo
<comando de arranque>

# Ejecutar pruebas
<comando de test>
```

---

## 📚 Documentación

- **Casos de uso:** `docs/use-cases/`
- **Arquitectura:** `docs/architecture/`
- **Decisiones (ADRs):** `docs/adr/`
- **Runbooks operativos:** `docs/runbooks/`

Documento maestro del taller: `<enlace al hub del taller>`.

---

## 🧪 Flujo de desarrollo

Este repositorio sigue el flujo del taller del Taller:

```
Historia (US) → Caso de uso (UC) + AC (GWT) → 🔴 RED → 🟢 GREEN → 🔵 REFACTOR → PR
```

- Todo AC debe tener al menos una prueba unitaria (relación 1 a 1).
- Todo PR debe referenciar el AC correspondiente (`AC-##`).
- Toda revisión valida trazabilidad AC ↔ Test ↔ Código.

---

## 🤖 GitHub Copilot en este repositorio

Este repo incluye personalización de Copilot en `.github/`:

- `copilot-instructions.md` — reglas siempre activas.
- `instructions/` — reglas por tipo de archivo.
- `prompts/` — macros invocables (`/<comando>`).
- `agents/` — personas especializadas.

Consultar el catálogo de prompts y agentes en cademia/docs/ del taller.

---

## 🏛️ Arquitectura

*Referencia breve al enfoque arquitectónico (ej. capas Abstracciones/API/Flujo/Reglas/Servicios/AccesoDatos para backend, o feature-based para SPA), con enlace al documento de arquitectura completo.*

Ver `docs/architecture/README.md` para el detalle.

---

## 🧭 Convenciones

- **Ramas:** `feature/<US-###>-<descripcion>`, `bugfix/<descripcion>`, `hotfix/<descripcion>`.
- **Commits:** *Conventional Commits* en imperativo (ej. `feat: agregar consulta de titulares`).
- **PRs:** siempre referenciar `US-###` y `AC-##`; template en `.github/PULL_REQUEST_TEMPLATE.md`.
- **Nomenclatura de código:** ver `.github/copilot-instructions.md`.

---

## 🔒 Seguridad

- Reportar vulnerabilidades siguiendo `SECURITY.md`.
- Dependencias controladas por catálogo de librerías justificadas con ADR.
- No se aceptan secretos en el repositorio.

---

## 🤝 Contribuir

Ver `CONTRIBUTING.md` para el detalle del proceso.

Resumen:
1. Crear rama desde `main`.
2. Seguir el flujo UC → AC → Test → Código.
3. Abrir PR usando el template.
4. Al menos 1 revisor aprueba.
5. CI verde antes de merge.

---

## 👥 Equipo y responsables

- **Product Owner:** *Por definir*
- **Docente del taller / Tech Lead:** *Por definir*
- **Owner de arquitectura:** *Por definir*

Ver `CODEOWNERS` para los responsables por carpeta.

---

## 📄 Licencia

Ver `LICENSE`.

---

## 🔗 Enlaces útiles

- Hub del Taller: `<enlace>`
- Catálogo de prompts: `<enlace>`
- Catálogo de componentes y librerías del equipo: `<enlace>`
- Wiki de Copilot: `<enlace>`

---

## 📝 Historial de cambios

Ver `CHANGELOG.md`.

---

*README versión academic-1.0 · Taller*