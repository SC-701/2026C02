---
agent: true
description: Genera un caso de uso completo (UC) con criterios de aceptación en formato GWT, siguiendo la plantilla del taller y cubriendo los 6 escenarios mínimos obligatorios.
tools: [codebase, editFiles]
owner: Por definir
version: 0.1
status: activo
scope: transversal
governs_by: constitution.md §2, ADR-002
---

# Prompt · Generar caso de uso (UC)

## Objetivo
Crear un archivo `docs/use-cases/UC-###-<nombre>.md` que sirva como **contrato ejecutable** para el ciclo SDD + TDD.

## Entradas
- **Nombre corto del caso de uso:** `${input:nombreUC:Nombre corto del caso de uso, ej. consultar-titulares}`
- **Historia de usuario asociada:** `${input:historiaUsuario:ID de la historia, ej. US-123}`
- **Rol del actor primario:** `${input:actor:Rol que ejecuta el caso, ej. Supervisor}`
- **Capacidad requerida:** `${input:capacidad:Qué necesita hacer el actor}`
- **Beneficio de negocio:** `${input:beneficio:Por qué lo necesita}`
- **Endpoint o vista relacionada (opcional):** `${input:endpoint:Ruta HTTP o vista, ej. GET /api/v1/titulares}`

## Contexto obligatorio a considerar
- Plantilla base: `academia/docs/templates/UC-template.md`.
- Constitution §2 (flujo SDD + TDD) y §2.5 (escenarios mínimos obligatorios).
- ADR-002 (SDD + TDD como práctica obligatoria).
- Cualquier UC existente en `docs/use-cases/` para mantener consistencia de estilo, numeración y dominio.

## Instrucciones para Copilot

1. **Consultá** los UCs existentes en `docs/use-cases/` para:
   - Determinar el siguiente ID disponible (`UC-###`).
   - Reutilizar convenciones de dominio, actores y estilo.

2. **Creá** el archivo `docs/use-cases/UC-###-${input:nombreUC}.md` respetando estrictamente la estructura del `UC-template.md`.

3. **Completá cada sección con contenido específico** (no dejes placeholders vacíos salvo donde el usuario deba decidir):
   - Frontmatter: `id`, `title`, `status: borrador`, `owner: Por definir`, `related_stories: [${input:historiaUsuario}]`, `version: 0.1`, `last-reviewed: <fecha actual>`.
   - Sección 1 (Historia de usuario) con los datos del actor, capacidad y beneficio.
   - Sección 2 (Actores) con el actor primario y los secundarios inferidos.
   - Sección 3 (Precondiciones) con al menos 2 precondiciones plausibles.
   - Sección 4 (Flujo básico) con al menos 4 pasos.
   - Sección 5 (Flujos alternos) con al menos 2 casos alternos.

4. **Generá los criterios de aceptación (sección 6) en formato GWT** cubriendo obligatoriamente los **6 escenarios mínimos** de la Constitution §2.5:
   - `AC-01` — Éxito (happy path).
   - `AC-02` — Validación de entrada.
   - `AC-03` — Autenticación / autorización.
   - `AC-04` — No encontrado / vacío.
   - `AC-05` — Duplicidad / idempotencia.
   - `AC-06` — Fallo de dependencia externa.

5. **Cada AC** debe tener:
   - Un nombre corto descriptivo.
   - `Dado` + `Y` (contexto).
   - `Cuando` (acción u evento).
   - `Entonces` + `Y` (resultado observable con código HTTP, mensaje o evento).

6. **Marcá el checklist** de la sección 6.7 según los AC generados.

7. **Completá la sección 9 (Trazabilidad)** con:
   - Enlace a la historia de usuario recibida.
   - Path esperado de pruebas: `tests/UC-###/*`.
   - Endpoint recibido en `${input:endpoint}` si aplica.

8. **Iniciá la sección 11 (Historial)** con la entrada de creación.

## Reglas duras
- **Idioma:** identificadores y contenido en español; términos técnicos y frameworks en su idioma original.
- **No omitir** ninguno de los 6 escenarios mínimos — si no aplica alguno, dejar `AC-##` con nota `N/A justificado: <razón>` en lugar de omitir.
- **No usar** placeholders genéricos tipo "<algo>" en el archivo final salvo en la sección 10 (notas).
- **Resultados observables:** cada `Entonces` debe ser verificable objetivamente (código HTTP exacto, mensaje literal, evento con nombre).

## Salida esperada
Archivo `docs/use-cases/UC-###-${input:nombreUC}.md` creado y listo para revisión.

## Referencias
- `academia/docs/constitution.md` §2
- `academia/docs/adr/ADR-002-sdd-tdd.md`
- `academia/docs/templates/UC-template.md`