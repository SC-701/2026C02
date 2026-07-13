---
agent: true
description: Genera una historia de usuario completa (US) con criterios INVEST, criterios de aceptación de alto nivel y casos de uso derivables sugeridos, siguiendo la plantilla del taller y el flujo SDD + TDD.
tools: [codebase, editFiles]
owner: Por definir
version: 0.1
status: activo
scope: transversal
governs_by: constitution.md §2.1, ADR-002
---

# Prompt · Generar historia de usuario (US)

## Objetivo
Crear un archivo `docs/stories/US-###-<nombre>.md` que sirva como **punto de partida ejecutable** para el ciclo SDD + TDD, expresando valor de negocio y habilitando la derivación de casos de uso.

## Entradas
- **Nombre corto de la historia:** `${input:nombreUS:Nombre corto en kebab-case, ej. registrar-postal-coleccion}`
- **Epic o feature agrupador:** `${input:epicFeature:Nombre del epic o feature, ej. Gestión de colección}`
- **Rol del usuario:** `${input:actor:Rol que obtiene el valor, ej. Coleccionista}`
- **Capacidad requerida:** `${input:capacidad:Qué necesita poder hacer el usuario}`
- **Beneficio de negocio:** `${input:beneficio:Por qué lo necesita / qué valor obtiene}`
- **Contexto de dominio (opcional):** `${input:contexto:Información adicional del dominio, reglas de negocio conocidas, restricciones}`

## Contexto obligatorio a considerar
- Plantilla base: `docs/templates/US-template.md`.
- Constitution §2.1 (spec antes de código) y ADR-002 (SDD + TDD obligatorio).
- Cualquier US existente en `docs/stories/` para mantener consistencia de numeración y dominio.
- Cualquier UC existente en `docs/use-cases/` para identificar UCs ya derivados que puedan relacionarse.

## Instrucciones para Copilot

1. **Consultá** las historias existentes en `docs/stories/` para:
   - Determinar el siguiente ID disponible (`US-###`).
   - Reutilizar convenciones de dominio, actores y estilo.

2. **Creá** el archivo `docs/stories/US-###-${input:nombreUS}.md` respetando estrictamente la estructura del `US-template.md`.

3. **Completá el frontmatter** con:
   - `id: US-###` (siguiente disponible).
   - `title`: título corto y descriptivo.
   - `status: borrador`.
   - `owner: Por definir`.
   - `size`: estimá según complejidad inferida del contexto (`XS | S | M | L | XL`).
   - `priority: media` (ajustar si el contexto indica otra prioridad).
   - `related_uc: []` (se completará al derivar UCs).
   - `related_epic`: valor de `${input:epicFeature}`.
   - `tags`: inferir del dominio y subdominio.
   - `version: 0.1`.
   - `last-reviewed`: fecha actual.

4. **Completá cada sección con contenido específico** (no dejes placeholders vacíos salvo donde el usuario deba decidir):
   - **§1 Historia de usuario:** formato exacto `Como / Quiero / Con el fin de` con los datos del actor, capacidad y beneficio.
   - **§2 Valor de negocio:** al menos 2 viñetas concretas explicando el problema que resuelve y la oportunidad que habilita.
   - **§3 Criterios INVEST:** evaluá cada criterio según la historia y marcá `[x]` los que se cumplen; añadí una nota breve si alguno no aplica.
   - **§4 Criterios de aceptación de alto nivel:** al menos 3 criterios en lenguaje natural, observables, que luego se formalizarán en GWT dentro de los UCs.
   - **§5 Casos de uso asociados:** listá los UCs que se pueden derivar de esta historia (al menos 1 sugerido), aunque aún no existan. Marcalos con estado `sugerido`.
   - **§6 Restricciones y supuestos:** al menos 1 restricción técnica o de negocio y 1 supuesto asumido.
   - **§7 Fuera de alcance:** al menos 2 ítems concretos que eviten scope creep.
   - **§8 Dependencias:** indicar dependencias conocidas o escribir "Sin dependencias identificadas" si no las hay.
   - **§9 Notas de refinamiento:** preguntas abiertas al PO o al equipo técnico que quedan pendientes.
   - **§10 Historial:** iniciar con la entrada de creación.

5. **Sugerí los UCs derivables** en §5 con nombres descriptivos que sigan el patrón `UC-###-<nombre-kebab-case>`, aunque los archivos no existan aún.

6. **Al finalizar**, invocá el skill `validar-us` sobre el archivo creado y reportá la decisión. Si hay observaciones altas o críticas, corregalas antes de reportar la historia como completa.

## Reglas duras
- **Idioma:** identificadores y contenido en español; términos técnicos y frameworks en su idioma original.
- **No omitir** ninguna de las 10 secciones — si una no aplica, escribirlo explícitamente con justificación.
- **No usar** placeholders genéricos tipo `<algo>` en el archivo final salvo en §9 (Notas de refinamiento) y §10 (Historial).
- **Criterios INVEST obligatorios:** los 6 ítems deben estar marcados o con justificación — nunca dejar ítems sin evaluar.
- **Criterios de aceptación observables:** cada criterio en §4 debe poder verificarse objetivamente; no usar frases como "el sistema responde correctamente".
- **La US no contiene diseño técnico** — expresar valor de negocio, no soluciones de implementación.

## Salida esperada
Archivo `docs/stories/US-###-${input:nombreUS}.md` creado, completo y validado por el skill `validar-us` con decisión `Lista`.

## Referencias
- `docs/constitution.md` §2.1
- `docs/adr/ADR-002-sdd-tdd.md`
- `docs/templates/US-template.md`
- `docs/skills/validar-us.skill.md`
