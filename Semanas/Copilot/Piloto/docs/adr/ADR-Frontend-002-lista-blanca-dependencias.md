---
adr_id: ADR-Frontend-002
title: Lista blanca de dependencias para SPA
status: propuesto
date: 2026-07-06
authors: [Por definir]
reviewers: [Por definir, docente del taller]
tags: [frontend, seguridad, dependencias, gobernanza, critico]
supersedes: []
superseded_by: []
priority: critica
---

# ADR-Frontend-002 · Lista blanca de dependencias para SPA

## 1. Estado

`propuesto` — **prioridad crítica del taller**. Requiere aprobación del docente del taller de Arquitectura y docente del taller.

---

## 2. Contexto

Los estudios recientes sobre cadena de suministro de software indican que **~90 % del código de una aplicación moderna proviene de dependencias OSS** — lo que constituye la mayor superficie de ataque del ecosistema (typosquatting, dependency confusion, malware inyectado, paquetes deprecados).

Adicionalmente, en el ámbito frontend se observa un fenómeno de **inflación de dependencias**: se instalan librerías populares (axios, lodash, moment, redux, formik, yup, zustand, react-query, etc.) para funcionalidades que la plataforma web moderna resuelve nativamente (`fetch`, `Intl`, `Array.prototype`, `useReducer`, `useContext`, discriminated unions).

Sin una política clara:

- Cada equipo instala dependencias distintas para resolver el mismo problema.
- Aumenta la superficie de ataque y el peso del bundle.
- Se dificulta el escaneo de vulnerabilidades y las actualizaciones coordinadas.
- Se dispersa el conocimiento del equipo (múltiples librerías equivalentes).
- Se debilita la reutilización de librerías open-source justificadas con ADR.

Se requiere una **lista de librerías justificadas con ADR** que defina qué se puede usar, qué no, y cómo pedir excepciones.

---

## 3. Decisión

Se adopta una **lista de librerías justificadas con ADR de dependencias** para todo SPA nuevo o feature nuevo en SPA existentes.

### 3.1 Detalle de la decisión

#### Dependencias PERMITIDAS

**Runtime (aplicación productiva):**

| Categoría | Paquete | Justificación |
|---|---|---|
| Framework | `react`, `react-dom` | Plataforma base |
| Lenguaje | `typescript` | Estándar del taller (ADR-Frontend-001) |
| Ruteo | `react-router-dom` | Excepción documentada — necesario para SPA multi-vista |
| Librerías open-source justificadas con ADR | Los aprobados por Arquitectura + docente del taller (catálogo vivo) | Estándar de la organización |

**Toolchain (build/dev):**

| Categoría | Paquete | Justificación |
|---|---|---|
| Build | `vite` | Toolchain oficial del taller |
| Testing | `vitest`, `@testing-library/react` | Requeridos para TDD (ADR-002) |
| Types | `@types/*` correspondientes | Requeridos por TypeScript estricto |

#### Dependencias PROHIBIDAS sin aprobación explícita

Todas las demás dependencias OSS de terceros, incluyendo (sin ser exhaustivo):

- HTTP clients: `axios`, `ky`, `superagent`, etc. → usar el custom hook useRecurso<T>() del proyecto o `fetch` nativo cuando aplique.
- Utilidades: `lodash`, `underscore`, `ramda` → usar APIs nativas de ES2022+.
- Fechas: `moment`, `date-fns`, `dayjs` → usar `Intl.DateTimeFormat` e `Intl.RelativeTimeFormat`.
- Estado global: `redux`, `zustand`, `mobx`, `recoil`, `jotai` → usar `useState` + `useReducer` + `useContext`.
- Formularios: `formik`, `react-hook-form`, `final-form` → usar el useState + useReducer nativo.
- Validación: `yup`, `zod`, `joi` → validar con funciones puras + TypeScript.
- Data fetching: `react-query`, `swr`, `apollo-client` → usar un custom hook `useRecurso<T>` estándar con discriminated union.
- CSS utilities: `classnames`, `clsx` → template literals o helper local de 3 líneas.

#### Reglas de `package.json`

- **Versiones exactas** obligatorias — prohibido `^` y `~`.
- **`package-lock.json` versionado** en el repositorio.
- **`.npmrc`** apunta al npm registry (no npmjs.org directo).
- **Sin dependencias no listadas** en el catálogo de librerías justificadas.

### 3.2 Alcance

- **Aplica a:** todo SPA nuevo y a **features nuevos** de SPAs existentes durante el taller.
- **No aplica a:** dependencias transitivas de paquetes autorizados (heredadas). Su gestión se atiende con el escaneo de vulnerabilidades estándar.

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| **A. Sin política — libertad total** | Cada equipo decide | Máxima velocidad inicial | Superficie de ataque enorme · divergencia · duplicación · bundle inflado | Riesgo de seguridad inaceptable |
| **B. Lista negra (bloquear lo malo)** | Prohibir paquetes específicos conocidos como riesgosos | Menos fricción | No escalable — aparecen paquetes nuevos constantemente | Enfoque reactivo insuficiente |
| **C. Lista blanca (permitir solo lo aprobado)** ✅ | Solo se usa lo del catálogo | Superficie mínima · gobierno claro · fomenta uso de librerías open-source justificadas con ADR | Requiere mantener el catálogo · fricción para pedir aprobación | **Elegida** — enfoque Zero Trust |
| **D. Solo BCL/plataforma nativa** | Cero dependencias externas | Máxima seguridad | Impráctico — ni siquiera React sería posible | Ambición desalineada con la realidad |

---

## 5. Consecuencias

### 5.1 Positivas

- Superficie de ataque de cadena de suministro drásticamente reducida.
- Bundle más liviano y arranque más rápido.
- Uniformidad — todos los equipos resuelven el mismo problema de la misma forma.
- Fomenta el uso y la mejora de los librerías open-source justificadas con ADR.
- Actualizaciones de seguridad coordinadas y auditables.
- Reduce la deuda técnica por librerías deprecadas.

### 5.2 Negativas / Costos

- Mayor esfuerzo para casos poco comunes (requieren desarrollo propio o solicitud de excepción).
- Curva de adaptación para desarrolladores acostumbrados a instalar libremente.
- Requiere mantenimiento activo del catálogo de librerías justificadas.
- Puede percibirse como restrictivo si el mecanismo de excepción no es ágil.

### 5.3 Neutrales / Observaciones

- La APIs nativas de ES2022+ cubren la mayoría de casos donde antes se usaban librerías (spread, `structuredClone`, `Object.entries`, `Intl.*`).
- La discriminated union para estados asíncronos es suficiente para reemplazar `react-query`/`swr` en la mayoría de escenarios.

---

## 6. Cumplimiento y verificación

- **Instructions Copilot path-specific** que rechazan imports fuera de la lista blanca.
- **Workflow agentic `validar-dependencias`** que en cada PR:
  - Escanea `package.json` para detectar paquetes no autorizados.
  - Escanea imports en `src/**/*.{ts,tsx}` en busca de módulos fuera del catálogo.
  - Comenta en el PR si detecta violaciones.
- **Escaneo de vulnerabilidades** (SCA) obligatorio en CI.
- **Auditoría mensual** del catálogo de librerías justificadas (docente del taller).

---

## 7. Excepciones

**Mecanismo de excepción:**

1. Desarrollador o Docente del taller identifica necesidad de una dependencia no listada.
2. Se abre un PR al catálogo de librerías justificadas (`academia/docs/catalogos/dependencias-autorizadas.md`) con justificación:
   - Problema que resuelve.
   - Alternativas nativas evaluadas y por qué no aplican.
   - Score de seguridad (OpenSSF Scorecard, Snyk Advisor, etc.).
   - Autor/mantenedor y frecuencia de release.
3. **Aprobación conjunta:** Arquitectura + docente del taller.
4. Se registra en el catálogo con la fecha, versión aprobada y responsable.

**Tiempo objetivo de resolución de excepciones:** 5 días hábiles.

---

## 8. Referencias

- Microsoft Secure Future Initiative — *Centralized Feed Service and package integrity*.
- Cloud Security Alliance — *Software Supply Chain Security*.
- OpenSSF Scorecard — criterios de evaluación de OSS.
- MDN Web Docs — `fetch`, `Intl`, `Array.prototype`, `structuredClone`.
- React Docs — *Managing State with useReducer and Context*.
- Documento maestro del Taller — sección 6.2.
- ADRs relacionados: `ADR-Frontend-001` (React funcional + TS estricto).

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| 2026-07-06 | propuesto | Por definir | Versión inicial del taller |