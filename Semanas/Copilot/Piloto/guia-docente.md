---
title: Guía Docente — Taller de Desarrollo con GitHub Copilot
audience: Docentes universitarios
owner: Docente del curso
version: academic-1.0
status: activo
last-reviewed: 2026-07-06
tags: [guia-docente, taller, copilot, evaluacion, feedback]
---

# Guía Docente — Taller de Desarrollo con GitHub Copilot

> Esta guía es de uso exclusivo para el docente o coordinador académico del taller. Contiene instrucciones para preparar cada sesión, actividades sugeridas, rúbricas de evaluación y cómo utilizar los workflows agentic para dar feedback a los equipos.

---

## 1. Preparación previa al taller

### 1.1 Configuración del entorno

Antes del inicio del taller, el docente debe:

1. **Crear la organización GitHub del curso** (GitHub Classroom recomendado).
2. **Configurar el repositorio base** con:
   - `copilot-instructions.md` organizacional en Settings → Copilot.
   - Template de repositorio con estructura estándar (`.github/`, `docs/`, `src/`, `tests/`).
3. **Verificar licencias de Copilot** — todos los estudiantes deben tener GitHub Copilot Education activado.
4. **Preparar el proyecto integrador** — elegir dominio (ver `proyecto-integrador.md`) y cargar las historias de usuario iniciales.
5. **Revisar los materiales** del taller: `copilot-estrategia.md`, `constitution.md`, ADRs, templates.

### 1.2 Formación de equipos

- Equipos de 3 a 5 personas.
- Mezclar perfiles cuando sea posible (backend, frontend, QA).
- Designar un líder de equipo que administrará el repo y coordinará los PRs.

---

## 2. Guía sesión por sesión

> Cada sesión dura **3 horas**. Los bloques son orientativos — el docente puede ajustar según el ritmo del grupo.

### Día 1 (3 horas) — UC + GWT + Personalización de Copilot + TDD (RED→GREEN)

**Objetivo:** Que todos los equipos tengan repositorio creado, UC-001 escrito con 6 ACs en GWT, y AC-01 cubierto con el ciclo TDD completo.

**Bloque 1 — Apertura + Setup (20 min)**
1. Presentación del taller: objetivos, reglas, herramientas, criterios de evaluación (10 min).
2. Formación de equipos + creación de repositorio desde template + verificación de Copilot Education (10 min).

**Bloque 2 — UC + GWT (40 min)**
1. Demo en vivo: crear UC-001 con el prompt `/generar-caso-de-uso` (15 min).
2. Taller práctico: cada equipo escribe UC-001 con 6 ACs observables en GWT (25 min).

**Bloque 3 — Personalización de Copilot (30 min)**
1. Demo: Copilot sin Instructions vs. con Instructions — diferencia en el código generado (10 min).
2. Cada equipo crea su `copilot-instructions.md` y 2 prompts propios (20 min).

**Bloque 4 — TDD: RED + GREEN + REFACTOR (50 min)**
1. Explicación del ciclo 🔴 RED → 🟢 GREEN → 🔵 REFACTOR con ejemplo en vivo (15 min).
2. Demo: AC-01 → prueba que falla → código mínimo → refactor SRP (10 min).
3. Taller: cada equipo replica el ciclo completo para su AC-01 (25 min).

**Cierre Día 1 (10 min)**
- Revisión rápida de commits: ¿aparece el test *antes* del código?
- Preguntas y ajustes.

**Checklist de cierre Día 1:**
- [ ] Repositorio creado con estructura correcta y CI activo.
- [ ] UC-001 con 6 ACs en GWT correcto y observables.
- [ ] Commit RED (test que falla) + commit GREEN (pasa) + commit REFACTOR (SRP).
- [ ] `copilot-instructions.md` propio + 2 prompts en `.github/prompts/`.

---

### Día 2 (3 horas) — TDD (AC-02/AC-03) + React + ADR + Demo

**Objetivo:** Completar cobertura ≥ 70% del UC-001, tener componente React funcional, redactar 1 ADR y hacer demo final con trazabilidad.

**Bloque 1 — Recap + AC-02 y AC-03 en TDD (30 min)**
1. Revisión de commits del Día 1: ¿el ciclo está bien documentado? (10 min).
2. Cada equipo aplica TDD para AC-02 (validación) y AC-03 (error/no encontrado) (20 min).

**Bloque 2 — Tema 4: React + TypeScript (50 min)**
1. Demo: componente "sin reglas" vs. componente con discriminated union + `useRecurso<T>()` (15 min).
2. Demo: usar `/generar-componente-funcional` con Copilot (10 min).
3. Taller: cada equipo implementa el componente del UC-001 con custom hook propio (25 min).

**Error frecuente:** Usar `any` o `React.FC`. Configurar `tsconfig.json` con `strict: true` desde el inicio.

**Bloque 3 — ADR + Workflow `revisar-pr` (25 min)**
1. Cada equipo redacta 1 ADR sobre una decisión técnica del proyecto (15 min).
2. Demo y ejecución del workflow `revisar-pr` sobre un PR real del equipo (10 min).

**Bloque 4 — Demo final + Retrospectiva (35 min)**
1. Demo de 5 min por equipo: mostrar UC-001 → test → código → componente React (trazabilidad). (15-20 min).
2. Retrospectiva facilitada: ¿qué funcionó bien? ¿qué cambiarían? Documentar en `docs/retro.md` (15 min).

**Cierre (10 min)**
- Retroalimentación global del docente.
- Instrucciones para entrega del repositorio.

**Checklist de cierre Día 2:**
- [ ] AC-02 y AC-03 del UC-001 cubiertos con TDD; cobertura ≥ 70%.
- [ ] Componente React funcional sin `any`, con estado async discriminated union.
- [ ] 1 ADR completo en `docs/adr/`.
- [ ] Reporte de `revisar-pr` adjunto en al menos 1 PR.
- [ ] Demo funciona; retrospectiva en `docs/retro.md`.

---

## 3. Cómo dar feedback usando los workflows agentic

### workflow `validar-uc`

Ejecutar sobre los casos de uso del equipo. El reporte generado incluye:
- ¿Tiene los 6 escenarios mínimos?
- ¿Los ACs son observables y en formato GWT correcto?
- ¿Hay trazabilidad con historias de usuario?

**Cómo usarlo en clase:** Proyectar el reporte del equipo y discutir los ítems marcados como ⚠️ o ❌.

### workflow `validar-cobertura`

Analiza la cobertura de pruebas del backend. Úsalo después de cada sesión de TDD para mostrar el progreso del equipo.

### workflow `revisar-pr`

El más importante. Ejecutarlo sobre cada PR antes del merge. El reporte incluye:
- ¿Los cambios tienen pruebas correspondientes?
- ¿Se respetan las capas de arquitectura?
- ¿Hay violaciones SOLID detectables?
- ¿Se usaron dependencias no justificadas?

**Regla del docente:** ningún PR se mergea sin el reporte de `revisar-pr` adjunto en los comentarios.

### workflow `validar-dependencias`

Ejecutar cuando un equipo propone agregar una librería OSS. El reporte ayuda a evaluar si el ADR del equipo es suficiente.

---

## 4. Preguntas frecuentes de estudiantes

**¿Por qué tengo que escribir la prueba antes del código si es más lento?**
> Porque TDD no es solo una técnica de testing: es una técnica de diseño. La prueba es la especificación ejecutable del comportamiento esperado. Escribirla primero obliga a pensar en el contrato público antes de la implementación. Véase: *Test-Driven Development: By Example* — Kent Beck (2002).

**¿Por qué no puedo usar `axios` si es más fácil que `fetch`?**
> Por el principio de "dependencias mínimas y justificadas". Si `fetch` nativo resuelve el problema, agregar `axios` es deuda técnica gratuita. Si el equipo puede justificar con criterios técnicos que `axios` aporta algo que `fetch` no da, lo documenta en un ADR y el docente lo aprueba.

**¿Por qué Copilot me genera código diferente al estándar aunque tengo las Instructions?**
> Las Instructions son probabilísticas, no deterministas. Por eso existen los Prompts, los Agents y los Workflows agentic: cada capa agrega precisión. Un Prompt bien escrito genera resultados más predecibles que solo Instructions.

**¿Por qué los identificadores deben ser en español?**
> Para que el código sea legible por cualquier miembro del equipo en el contexto del dominio del proyecto. Es una convención del taller. En proyectos reales, la convención del equipo prevalece.

**¿Puedo usar `useEffect` para hacer fetch?**
> Sí, mientras se encapsule en un custom hook `useRecurso<T>()` con el patrón discriminated union. Nunca `useEffect` suelto con `setState` directamente en el componente.

---

## 5. Historial de cambios

| Versión | Fecha | Cambios |
|---|---|---|
| academic-1.0 | 2026-07-06 | Creación de la guía docente para el Taller de Desarrollo con GitHub Copilot |
