---
adr_id: ADR-Frontend-001
title: Adopción de React funcional con hooks y TypeScript estricto para SPA
status: propuesto
date: 2026-07-06
authors: [Por definir]
reviewers: [Por definir]
tags: [frontend, react, typescript, arquitectura]
supersedes: []
superseded_by: []
---

# ADR-Frontend-001 · React funcional + TypeScript estricto para SPA

## 1. Estado

`propuesto` — pendiente de aprobación en la sesión de inicio del taller.

---

## 2. Contexto

Los nuevos desarrollos frontend adoptarán el modelo **Single Page Application (SPA)** con React. Existe una decisión pendiente sobre el paradigma de componentes:

- **Componentes de clase** — API tradicional con `class extends React.Component`.
- **Componentes funcionales + hooks** — introducidos en React 16.8 (2019) y consolidados como el modelo recomendado por el equipo de React.

Adicionalmente, es necesario definir el nivel de rigor de TypeScript. Un tipado laxo (con `any` ubicuo) reduce el valor de TS a poco más que documentación opcional; un tipado estricto captura defectos en tiempo de compilación.

La combinación paradigma + tipado determina la calidad estructural del código, la reutilización de lógica y la superficie de defectos que llegará a producción.

---

## 3. Decisión

Se adoptan como estándar del taller para todo SPA:

1. **Componentes funcionales + hooks** como único paradigma permitido.
2. **TypeScript en modo estricto** para todos los archivos `.ts` y `.tsx`.

### 3.1 Detalle de la decisión

**Sobre componentes:**

- Todo componente es una función. Prohibido `class extends React.Component`.
- **Única excepción:** `ErrorBoundary` (limitación técnica de React que aún requiere clase).
- Prohibido `React.FC`: los props se tipan con `interface` en la firma de la función.
- Toda lógica reutilizable se extrae en **custom hooks** con prefijo `use`.

**Sobre TypeScript:**

`tsconfig.json` mínimo obligatorio:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

- Prohibido `any` — usar `unknown` + estrechamiento de tipos.
- Estados asíncronos modelados como **discriminated unions** (`inicial | cargando | exito | error`).
- Props tipados con `interface` en PascalCase.

### 3.2 Alcance

- **Aplica a:** todo SPA nuevo y a nuevos features/refactors de SPAs existentes en el taller.
- **No aplica a:** SPAs legacy con componentes de clase — su migración es opcional y se evalúa caso a caso.

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| **A. Componentes de clase** | Modelo tradicional | Familiar para desarrolladores con background OO | Ceremonia con `this`/`bind` · lifecycle disperso · más código · nuevas features de React solo llegan a hooks | No es el modelo recomendado desde 2019 |
| **B. Mixto (clases + funcionales)** | Coexistencia | Flexibilidad | Inconsistencia · dos mentales para mantener · dificulta revisión | Divergencia de estilo |
| **C. Funcionales + hooks** ✅ | Modelo moderno | Menos código · reutilización vía custom hooks · futuro-compatible · alineado con React docs | Curva de aprendizaje para hooks (ciclo `useEffect`, dependencias) | **Elegida** |
| **D. TypeScript laxo (`any` permitido)** | Tipado como documentación | Baja fricción inicial | Pierde el valor de TS · runtime errors evitables | Descartada — anula el propósito |
| **E. TypeScript estricto** ✅ | `strict: true` + reglas adicionales | Captura defectos en compile-time · autocompletado real · refactor seguro | Mayor esfuerzo inicial de tipado | **Elegida** |

---

## 5. Consecuencias

### 5.1 Positivas

- Menos código y menor superficie de defectos.
- Reutilización efectiva de lógica vía custom hooks.
- Compatibilidad con las nuevas features de React (Suspense, Server Components) que solo llegan al modelo funcional.
- Defectos capturados en tiempo de compilación.
- Autocompletado y navegación de código mucho más útiles.
- Refactor con red de seguridad tipográfica.

### 5.2 Negativas / Costos

- Curva de aprendizaje para desarrolladores acostumbrados a clases.
- Mayor tiempo inicial de tipado (recupera costo en refactors posteriores).
- Requiere disciplina para no caer en `any` como escape.

### 5.3 Neutrales / Observaciones

- La adopción de hooks también obliga a comprender el ciclo de re-render y las dependencias de `useEffect`.
- La discriminated union para estados asíncronos requiere manejo exhaustivo — TS lo obliga (positivo).

---

## 6. Cumplimiento y verificación

- **`copilot-instructions.md` del SPA** con las reglas duras que refuerzan el paradigma.
- **Instructions path-specific** (`applyTo: "src/**/*.tsx"`) que prohíben `class` y `any`.
- **Linter** con reglas equivalentes en pre-commit y en CI.
- **Workflow** que rechaza PRs con `class` (excepto `ErrorBoundary`) o `any`.
- **Revisión de código** obligatoria por al menos 1 par que valide adherencia.

---

## 7. Excepciones

- `ErrorBoundary` — única clase permitida por limitación técnica.
- Casos puntuales de integración con librerías legacy pueden requerir `unknown` con casteo controlado — nunca `any` — y deben estar documentados en el archivo.

---

## 8. Referencias

- React Docs — *Introducing Hooks* y *Function Components*.
- TypeScript Handbook — *strict mode* y *narrowing*.
- Bitovi Blog — *Function components vs class components*.
- Kent C. Dodds — *When to use useReducer over useState*.
- Documento maestro del Taller — sección 6 (Tema 4).
- ADRs relacionados: `ADR-Frontend-002` (dependencias).

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| 2026-07-06 | propuesto | Por definir | Versión inicial del taller |