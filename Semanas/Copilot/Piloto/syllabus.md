---
title: Syllabus — Taller de Desarrollo con GitHub Copilot
audience: Docentes universitarios, Estudiantes de ingeniería de software
owner: Docente del curso
version: academic-1.0
status: activo
last-reviewed: 2026-07-06
tags: [syllabus, taller, copilot, sdd, tdd, react, csharp]
---

# Syllabus — Taller de Desarrollo con GitHub Copilot

## 1. Identificación del curso

| Campo | Valor |
|---|---|
| **Nombre** | Taller de Desarrollo con GitHub Copilot |
| **Modalidad** | Presencial / Híbrido |
| **Duración** | 2 días × 3 horas por sesión (6 horas total) |
| **Nivel** | Tercer a quinto año de Ingeniería Informática o afines |
| **Prerrequisitos** | Programación orientada a objetos, fundamentos de desarrollo web, Git básico |
| **Herramientas** | VS Code, GitHub Copilot (licencia Education), .NET 8, Node.js 20+, React 18+ |

---

## 2. Descripción del taller

El taller introduce a los estudiantes en el desarrollo de software moderno asistido por IA generativa. A través de un proyecto integrador, los equipos aplican de forma práctica:

- **Spec-Driven Development (SDD)**: diseñar primero como especificación viva.
- **Test-Driven Development (TDD)**: ciclo 🔴 RED → 🟢 GREEN → 🔵 REFACTOR.
- **Clean Architecture** y **SOLID** en backend C# .NET.
- **React funcional** con TypeScript estricto.
- **Gobernanza de IA generativa** mediante los 8 elementos de personalización de Copilot.

El taller NO enseña a "pedirle código a Copilot". Enseña a construir guardarraíles que hacen que la IA genere código correcto, trazable y mantenible.

---

## 3. Objetivos de aprendizaje

Al finalizar el taller, el estudiante será capaz de:

1. Redactar casos de uso y criterios de aceptación en formato GWT verificables y trazables.
2. Aplicar el ciclo TDD (Red-Green-Refactor) con disciplina y consistencia.
3. Diseñar backends C# .NET con arquitectura por capas (Abstracciones/API/Flujo/Reglas/Servicios/AccesoDatos) respetando la regla de dependencia.
4. Construir SPAs React con TypeScript estricto, sin paquetes OSS injustificados.
5. Configurar los 8 elementos de personalización de GitHub Copilot (Instructions, Prompts, Agents, Skills, MCP, Workflows, Templates, Documentación).
6. Documentar decisiones arquitectónicas mediante ADRs.
7. Revisar código de pares con criterios objetivos basados en SOLID y Clean Code.
8. Justificar el uso de cualquier dependencia externa con criterios de ingeniería.

---

## 4. Contenidos por tema

### Tema 1 — Casos de uso y estructura del repositorio

- Casos de uso en Markdown con frontmatter YAML.
- Criterios de aceptación en formato GWT (Dado/Cuando/Entonces).
- Escenarios mínimos obligatorios (6 por UC).
- Modelo polirrepo por proyecto de equipo.
- Trazabilidad: Historia → UC → AC → Test → Código → PR.

**Referencia:** *Spec Kit* (GitHub), *Clean Architecture* — Robert C. Martin (cap. 16-17).

### Tema 2 — Los 8 elementos de personalización de Copilot

- Instructions (organizacionales, de repositorio, path-específicas).
- Prompts: macros invocables bajo demanda.
- Agents: personas especializadas con límites explícitos.
- Skills: procedimientos reutilizables y componibles.
- MCP: conexión a sistemas externos.
- Workflows: automatización con guardarraíles.
- Templates: Repository Templates y Content Templates.
- Documentación en Markdown como artefacto ejecutable.

**Referencia:** *GitHub Copilot Documentation* — docs.github.com/copilot.

### Tema 3 — SDD + TDD (Backend C#)

- Flujo obligatorio: UC → AC → 🔴 RED → 🟢 GREEN → 🔵 REFACTOR.
- Relación 1:1 AC ↔ Prueba ↔ Unidad de código.
- Arquitectura por capas (Abstracciones, API, Flujo, Reglas, Servicios, AccesoDatos).
- Regla de dependencia (Robert C. Martin).
- Checklist SOLID pre-commit.
- Política de dependencias: ADR obligatorio para toda librería OSS.

**Referencia:** *Test-Driven Development: By Example* — Kent Beck (2002). *Clean Architecture* — Robert C. Martin (2017).

### Tema 4 — Frontend SPA React + TypeScript

- Solo funciones + hooks. Prohibido `class extends React.Component`.
- TypeScript estricto (`strict: true`, sin `any`, sin `React.FC`).
- Estado async como discriminated union de 4 casos.
- Fetching con `fetch` nativo en custom hook propio.
- Las 11 reglas duras del `copilot-instructions.md` del SPA.
- Política de dependencias: justificación con ADR.

**Referencia:** *React documentation* — react.dev. *TypeScript Handbook* — typescriptlang.org.

---

## 5. Cronograma del taller (2 días × 3 horas)

### Día 1 (3 horas) — Especificación, TDD y personalización de Copilot

| Bloque | Duración | Contenido | Entregable |
|---|---|---|---|
| Apertura + Setup | 20 min | Presentación, equipos, repo desde template, `copilot-instructions.md` propio | Repo creado con structure base |
| Tema 1 — UC + GWT | 40 min | Casos de uso, criterios de aceptación GWT, 6 escenarios mínimos | UC-001 con 6 ACs en formato correcto |
| Tema 2 — Personalización Copilot | 30 min | Instructions, Prompts y Agents: demo en vivo + práctica guiada | 2 prompts propios en `.github/prompts/` |
| Tema 3 — TDD intro + RED | 50 min | Flujo SDD → TDD; ciclo 🔴 RED: primera prueba unitaria derivada de AC-01 | Primera prueba en RED (falla) |
| GREEN + REFACTOR + Cierre Día 1 | 40 min | 🟢 GREEN: código mínimo que pasa la prueba; 🔵 REFACTOR: SRP aplicado | AC-01 cubierto con TDD; commit con referencia AC-01 |

### Día 2 (3 horas) — Frontend, ADRs, integración y demo

| Bloque | Duración | Contenido | Entregable |
|---|---|---|---|
| Recap + AC-02 y AC-03 en TDD | 30 min | Completar escenarios de validación y error del UC-001 con TDD | AC-02 y AC-03 cubiertos; cobertura ≥ 70% |
| Tema 4 — React + TypeScript | 50 min | Componente funcional, estado async discriminated union, custom hook `useRecurso<T>()` | Componente del UC-001 funcional con prueba |
| ADR + Skill propio | 25 min | Redactar 1 ADR de decisión técnica; documentar 1 Skill repetible del proyecto | ADR en `docs/adr/`; Skill en `.github/skills/` |
| Integración + workflow `revisar-pr` | 30 min | Conectar backend y frontend; ejecutar reporte de revisión sobre el PR | Reporte de `revisar-pr` adjunto al PR |
| Demo final + retrospectiva | 25 min | Demo de 5 min por equipo: trazabilidad UC → test → código; lecciones aprendidas | Demo funcional; retrospectiva en `docs/retro.md` |

---

## 6. Evaluación

| Componente | Peso | Descripción |
|---|---|---|
| UC-001 con ACs GWT (calidad y trazabilidad) | 25% | UC-001 con mínimo 6 ACs en formato GWT correcto y observables |
| Pruebas unitarias TDD (ciclo y cobertura) | 30% | Commits RED→GREEN→REFACTOR evidentes; cobertura ≥ 70% en UC-001 |
| Calidad del código (SOLID + Clean Code) | 20% | SRP respetado; sin `any`; métodos ≤ 20 líneas |
| Personalización de Copilot | 15% | `copilot-instructions.md` propio + 2 prompts propios |
| ADR + demo funcional | 10% | 1 ADR completo + demo de 5 min con trazabilidad UC→test→código |

---

## 7. Criterios de acreditación

Para acreditar el taller, el equipo debe:

- [ ] Entregar el repositorio completo con la estructura requerida.
- [ ] Tener UC-001 con 6 ACs en formato GWT correcto y observables.
- [ ] Tener ciclo RED→GREEN→REFACTOR evidenciado en el historial de commits.
- [ ] Tener cobertura de pruebas ≥ 70% para UC-001.
- [ ] Tener al menos 1 componente React funcional con estado async correcto.
- [ ] Tener al menos 1 ADR con formato completo.
- [ ] Tener `copilot-instructions.md` propio + 2 prompts en el repositorio.
- [ ] Haber ejecutado el workflow `revisar-pr` sobre al menos 1 PR.

---

## 8. Bibliografía

### Obligatoria

- **Clean Architecture** — Robert C. Martin (2017). *Prentice Hall.*
- **Clean Code** — Robert C. Martin (2008). *Prentice Hall.*
- **Test-Driven Development: By Example** — Kent Beck (2002). *Addison-Wesley.*
- **Refactoring** — Martin Fowler (2018, 2ª ed.). *Addison-Wesley.*
- **React documentation** — [react.dev](https://react.dev) (oficial, actualizada).
- **TypeScript Handbook** — [typescriptlang.org](https://www.typescriptlang.org/docs/) (oficial).
- **GitHub Copilot Documentation** — [docs.github.com/copilot](https://docs.github.com/copilot) (oficial).

### Complementaria

- **The Pragmatic Programmer** — Hunt & Thomas (2019, 20ª ed.). *Addison-Wesley.*
- **Documenting Architecture Decisions** — Michael Nygard (2011). *Blog personal.*
- **The C4 Model** — Simon Brown. [c4model.com](https://c4model.com).
- **Domain-Driven Design** — Eric Evans (2003). *Addison-Wesley.*

---

## 9. Historial de cambios

| Versión | Fecha | Cambios |
|---|---|---|
| academic-1.0 | 2026-07-06 | Creación del syllabus para el Taller de Desarrollo con GitHub Copilot |
