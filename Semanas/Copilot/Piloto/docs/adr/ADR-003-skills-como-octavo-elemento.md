---
adr_id: ADR-003
title: Adopción de Skills como 8° elemento de personalización de GitHub Copilot
status: propuesto
date: 2026-07-06
authors: [Por definir]
reviewers: [Por definir]
tags: [copilot, personalizacion, skills, gobernanza, arquitectura]
supersedes: []
superseded_by: []
---

# ADR-003 · Skills como 8° elemento de personalización

## 1. Estado

`propuesto` — pendiente de aprobación en la sesión de inicio del taller.

---

## 2. Contexto

La versión inicial del Taller identificó **7 elementos de personalización de GitHub Copilot**: Instructions, Prompts, Agents, MCP, Workflows, Templates y Documentación MD. En la práctica, al materializar los primeros artefactos del taller del taller (agentes `programador-mapi` y `programador-spa-react` + prompts críticos), quedó en evidencia un vacío:

- Los **Prompts** están diseñados como macros invocadas por el usuario ("hacé esto una vez").
- Los **Agents** representan personas con propósito, herramientas y límites.
- Ninguno de los dos captura correctamente los **procedimientos repetibles y componibles** que un Agent necesita ejecutar múltiples veces (ej. aplicar SOLID sistemáticamente, auditar cobertura, revisar un PR contra la Constitution).

Sin un elemento dedicado, estos procedimientos terminan:

- Duplicados dentro de múltiples Prompts.
- Enterrados como pasos ad-hoc en Agents (haciendo a los Agents largos y difíciles de mantener).
- No auditables ni reutilizables entre Agents distintos.
- Sin gobernanza clara (¿quién los mantiene? ¿cómo se versionan?).

La comunidad y el ecosistema Copilot han comenzado a usar el término **Skill** para exactamente este espacio semántico: un procedimiento formalizado, repetible, componible desde Agents o Prompts, con entradas y salidas declaradas.

---

## 3. Decisión

Se adopta **Skills** como el **8° elemento** de personalización de GitHub Copilot dentro del Taller.

### 3.1 Detalle de la decisión

**Definición del taller:**
Un Skill es un procedimiento **repetible y componible**, con entradas y salidas declaradas, invocable por Agents o Prompts, gobernado por la Constitution.

**Ubicación:**
- Por repositorio: `.github/skills/<nombre>.skill.md`.
- Copia canónica en el hub: `academia/docs/skills/<nombre>.skill.md`.

**Nomenclatura:**
`<verbo>-<sustantivo>.skill.md` en kebab-case (ej. `refactor-solid.skill.md`, `analisis-cobertura.skill.md`).

**Frontmatter obligatorio:**
`id`, `name`, `description`, `scope`, `inputs`, `outputs`, `used_by_agents`, `used_by_prompts`, `owner`, `version`, `status`.

**Estructura obligatoria (9 secciones):**
1. Propósito
2. Cuándo usarlo
3. Cuándo NO usarlo
4. Entradas
5. Pasos
6. Validaciones
7. Salidas
8. Ejemplos
9. Referencias

**Reglas de composición:**
- Un Skill **PUEDE** invocar a otros Skills.
- Un Skill **NO PUEDE** invocar Agents (regla anti-ciclo).
- Un Skill **PUEDE** ser invocado por Agents, Prompts o Workflows.
- El contenido de un Skill **NO PUEDE** modificarse desde un Agent o Prompt en tiempo de ejecución.

**Regla de decisión "¿es Prompt, Agent o Skill?":**

| Situación | Elemento correcto |
|---|---|
| Tarea puntual iniciada por el usuario | Prompt |
| Persona con propósito, tools y límites | Agent |
| Procedimiento repetible que otros componen | **Skill** |

### 3.2 Alcance

- **Aplica a:** todos los repositorios del taller y todos los Agents/Prompts nuevos.
- **No aplica a:** procedimientos aún no formalizados (se ejecutan manualmente y se sugiere su creación como Skill si son repetibles).

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| **A. No introducir Skills** | Mantener solo 7 elementos | Menos artefactos que gobernar | Duplicación en Prompts, Agents largos, sin reutilización | Insostenible a mediano plazo |
| **B. Meter procedimientos como Prompts encadenados** | Un Prompt llama a otro | Reutiliza infraestructura existente | Prompts pensados como tarea puntual del usuario — usarlos como procedimiento es desviarlos del propósito | Ambigüedad semántica |
| **C. Meter procedimientos dentro de Agents** | El Agent contiene todos los pasos | Todo autocontenido | Agents muy largos · sin reutilización cruzada · violación de SRP a nivel de artefacto | Escalabilidad |
| **D. Adoptar Skills como 8° elemento** ✅ | Skills con estructura propia y gobierno independiente | Reutilización · composición · gobierno claro · alineado con la industria | Un elemento más de gobernar (mitigable con la matriz RACI) | **Elegida** |

---

## 5. Consecuencias

### 5.1 Positivas

- Reutilización de procedimientos entre Agents distintos y entre Prompts.
- Agents más pequeños y mantenibles (delegan a Skills).
- Trazabilidad y auditoría por Skill.
- Alineación con la evolución del ecosistema Copilot y la comunidad.
- Base para futuros Workflows agentic que compongan Skills.

### 5.2 Negativas / Costos

- Un elemento más que gobernar (nueva fila en RACI, catálogo, ciclo de vida).
- Curva de aprendizaje para autores de Agents y Prompts.
- Riesgo de proliferación descontrolada de Skills si no se aplica la regla del "mínimo suficiente".

### 5.3 Neutrales / Observaciones

- La regla de decisión Prompt/Agent/Skill debe socializarse activamente para evitar clasificaciones erróneas.
- El catálogo de Skills debe mantenerse curado — sin él, se pierde el beneficio de reutilización.

---

## 6. Cumplimiento y verificación

- **Instructions Copilot** referencian Skills disponibles cuando aplican.
- **Agents** declaran en su frontmatter (`composes_skills`) los Skills que componen.
- **Workflow (opcional)** que valide en PRs sobre `.github/skills/**` la presencia de las 9 secciones obligatorias.
- **Auditoría trimestral** del catálogo de Skills junto con los demás catálogos.

---

## 7. Excepciones

- Un Skill puede ser propuesto por cualquier Docente del taller o Tech Lead vía PR con las 9 secciones completas.
- Un Skill puede ser deprecado con un ADR de sustitución.
- Casos donde un procedimiento aparente no es realmente repetible → se ejecuta manualmente en el Agent (no se fuerza a Skill).

---

## 8. Referencias

- Constitution §9.4 (Skills como procedimientos gobernados).
- Documento maestro §4.4 (Los 8 elementos de personalización).
- GitHub Copilot Customization Handbook — evolución de Agents.
- ADRs relacionados: `ADR-001` (polirrepo), `ADR-002` (SDD+TDD).

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| 2026-07-06 | propuesto | Por definir | Versión inicial del taller |