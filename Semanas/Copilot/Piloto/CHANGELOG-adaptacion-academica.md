# CHANGELOG — Adaptación a Contexto Académico

**Taller de Desarrollo con GitHub Copilot** · Adaptación: 2026-07-06

---

## Resumen ejecutivo

Este CHANGELOG documenta la transformación del material original del Plan Piloto Institucional — escrito para un entorno corporativo — en material didáctico abierto para el **Taller de Desarrollo con GitHub Copilot**, dirigido a cursos universitarios de ingeniería de software.

**Principio guía:** el rigor técnico no se diluyó. SDD, TDD, Clean Architecture, SOLID, los 8 elementos de personalización de Copilot y las 11 reglas duras del frontend están intactos. Lo que cambió es el contexto y el lenguaje.

---

## Parámetros de la adaptación

| Parámetro | Valor elegido |
|---|---|
| Nombre del curso | Taller de Desarrollo con GitHub Copilot |
| Organización académica | Educativo (genérico) |
| Duración | 2 semanas |
| Estilo de ADRs | Descriptivos (`ADR-arquitectura-por-capas`) |
| Carpeta de artefactos nuevos | `academia/` |

---

## Archivos modificados

### `readme.md`

**Cambios:**
- Título: "Plan Piloto Institucional de Desarrollo con GitHub Copilot" → "Taller de Desarrollo con GitHub Copilot"
- Estado: 🧪 Piloto → 🟢 Activo · Versión: 0.1 → academic-1.0
- Referencia a "Banco Central de Costa Rica (BCCR / TIS)" eliminada.
- Referencia a "toda la DST" → "proyectos de equipo del curso".
- Tabla de roles: "Team Coach / Arquitecto" → "Docente del taller"; "Responsable de seguridad o gobernanza" → "Líder de equipo".
- "Plan Piloto" → "taller" en todas las ocurrencias.
- "SharePoint / Wiki institucional" eliminados; reemplazados por "GitHub Pages del curso".
- Referencia a `Bccr.Tis.Copilot.EjemplosPrompts` eliminada; reemplazada por `academia/`.
- Estado del piloto: sección con tiempos "por definir" → sección con duración de 2 semanas.
- Estructura prevista: actualizada para reflejar carpeta `academia/` y sin `componentes-core-ui.md`.
- Principio 7: "Solo componentes institucionales" → "librerías open-source justificadas con ADR".
- Sección "¿Cómo contribuir?" adaptada al taller.

### `copilot-estrategia.md`

**Cambios en frontmatter:**
- `title`: "Plan Piloto Institucional" → "Taller de Desarrollo con GitHub Copilot"
- `audience`: "Team Coaches, Arquitectos, Desarrolladores TIS/DST BCCR" → "Docentes universitarios, Estudiantes de ingeniería de software"
- `version`: 0.2 → academic-1.0
- `status`: piloto → activo
- `license`: "BCCR — Uso interno" → "Educativo — Uso abierto"

**Cambios en contenido:**
- "Banco Central de Costa Rica" y todas sus variantes eliminadas.
- Organizaciones GitHub departamentales (TISDSTBCCR, TEFDSTBCCR, etc.) eliminadas; reemplazadas por "GitHub Classroom o equivalente".
- Nomenclatura `Bccr.<Producto>.<Componente>` → `<NombreProyecto>.<Componente>` (ej. `BibliotecaCurso.Api`).
- Estructura de solución: `Bccr.<Producto>.*` → `<NombreProyecto>.*` en todos los bloques de código.
- Repo central `Bccr.Tis.Copilot.EjemplosPrompts` → `academia/prompts/` del curso.
- Repository Templates: `Bccr.Tis.Template.*` → `Taller.Template.*`.
- Aprobación de MCP: "Seguridad TI + Arquitectura" → "Docente del taller".
- Política de dependencias frontend: tabla completamente reformada — eliminados `@core/bccr.core.ui.react.*`, `@bccr/bccrgridui`, `central.bccr.fi.cr`; reemplazados por Radix UI / Headless UI con justificación ADR.
- Manejo de datos: `manejador-peticiones` BCCR → custom hook `useRecurso<T>()` propio; `manejador-de-formulario` → `useState` + `useReducer` nativo; `bccrgridui` → `<table>` nativo.
- Reglas duras del SPA (#5, #6, #7, #8): actualizadas para eliminar referencias a componentes institucionales.
- DIP en React: "servicios dependen del `manejador-peticiones` BCCR" → "servicios dependen del custom hook `useRecurso<T>()` del proyecto".
- Roles: "Responsables departamentales (TIS, TEF, TSP, TCO)" → "Responsables de equipo"; "Seguridad TI" → "Docente del taller"; "Team Coaches" → "Líderes de equipo".
- Catálogos: `@core/bccr.core.ui.react.*` eliminado; `Bccr.Tis.Arquitectura` → `docs/adr/`.
- RACI: MCP aprobador "Seguridad TI + Arquitectura" → "Docente del taller".
- Roadmap: ítems 6 y 7 renombrados de `Bccr.Tis.Template.*` a `Taller.Template.*`; ítem 16 "Retrospectiva del piloto" → "Retrospectiva del taller".
- "Referencias internas BCCR" → "Referencias del taller"; eliminadas todas las URLs y repos internos.
- Historial: entrada `academic-1.0` agregada.

---

## Archivos NO modificados (ya estaban limpios)

Los siguientes archivos no tenían referencias corporativas específicas y su contenido técnico está intacto:

- `docs/estandares/constitution.md`
- `docs/estandares/adr/ADR-001-polirrepo.md`
- `docs/estandares/adr/ADR-002-sdd-tdd.md`
- `docs/estandares/adr/ADR-003-skills-como-octavo-elemento.md`
- `docs/estandares/adr/ADR-Frontend-001-react-funcional.md`
- `docs/estandares/adr/ADR-Frontend-002-lista-blanca-dependencias.md`
- `docs/estandares/agents/programador-mapi.agent.md`
- `docs/estandares/agents/programador-spa-react.agent.md`
- `docs/estandares/ejemplos/guia-proyecto-ejemplo-album-mundial.md`
- `docs/estandares/instructions/copilot-instructions.backend.md`
- `docs/estandares/instructions/copilot-instructions.frontend.md`
- `docs/estandares/Prompts/generar-caso-de-uso.prompt.md`
- `docs/estandares/Prompts/generar-componente-funcional.prompt.md`
- `docs/estandares/Prompts/generar-custom-hook.prompt.md`
- `docs/estandares/Prompts/generar-prueba-desde-ac.prompt.md`
- `docs/estandares/Prompts/implementar-para-pasar-prueba.prompt.md`
- `docs/estandares/skills/analisis-cobertura.skill.md`
- `docs/estandares/skills/refactor-solid.skill.md`
- `docs/estandares/skills/revisar-pr.skill.md`
- `docs/estandares/skills/validar-uc.skill.md`
- `docs/estandares/templates/` (todos los templates)
- `docs/estandares/workflows/` (todos los workflows)
- `guia-de-uso.md`

---

## Artefactos académicos creados

Los siguientes archivos son **nuevos** y no existían en el repositorio original:

| Archivo | Descripción |
|---|---|
| `academia/syllabus.md` | Programa completo del taller: objetivos, cronograma, evaluación, bibliografía |
| `academia/guia-docente.md` | Guía para el docente: preparación, sesión por sesión, uso de workflows para feedback, FAQ |
| `academia/rubrica-evaluacion.md` | Rúbrica maestra con 6 dimensiones, 4 niveles y pesos porcentuales |
| `academia/proyecto-integrador.md` | Proyecto semestral con dominio Álbum del Mundial, historias mínimas, arquitectura, hitos y criterios de entrega |
| `academia/CHANGELOG-adaptacion-academica.md` | Este archivo |

---

## Verificación final

### Referencias corporativas eliminadas
- [x] Banco Central de Costa Rica / BCCR
- [x] TIS, DST, TEF, TCO, TSP (departamentos)
- [x] TISDSTBCCR, TEFDSTBCCR (organizaciones GitHub)
- [x] `@core/bccr.core.ui.react.*`
- [x] `@bccr/bccrgridui`
- [x] `central.bccr.fi.cr`
- [x] `Bccr.<Producto>.*` (nomenclatura)
- [x] `Bccr.Tis.Template.*`
- [x] `Bccr.Tis.Copilot.EjemplosPrompts`
- [x] `Bccr.Tis.Arquitectura`
- [x] Wiki.GitHubCopilot
- [x] Nombres de personas reales (Team Coaches, Arquitectos específicos)

### Rigor técnico preservado
- [x] Ciclo 🔴 RED → 🟢 GREEN → 🔵 REFACTOR intacto
- [x] Relación 1:1 AC ↔ Prueba ↔ Código intacta
- [x] 6 escenarios mínimos por UC intactos
- [x] 6 capas del backend (ABS, API, BW, BC, SG, DA) intactas
- [x] 11 reglas duras del frontend intactas (adaptadas para contexto open-source)
- [x] SOLID + Clean Code intactos
- [x] Estructura 9 secciones de un Skill intacta
- [x] Estructura 6 secciones obligatorias de un Agent intacta
- [x] Formato RFC 2119 de la Constitution intacto

---

*CHANGELOG generado el 2026-07-06 como parte de la adaptación a contexto académico universitario.*
