---
scope: frontend
stack: React + TypeScript + Vite
version: 0.1
status: activo
governs_by: constitution.md + ADR-Frontend-001, ADR-Frontend-002
---

# Copilot Instructions — Frontend SPA React + TypeScript

Aplicá siempre estos principios. Referencia la Constitution para el detalle.

## 1. Reglas duras (Constitution §4)
1. **Todo componente es una función.** Prohibido `class extends React.Component`. Única excepción: `ErrorBoundary`.
2. **Prohibido `any`.** Usar `unknown` + estrechamiento de tipos.
3. **Prohibido `React.FC`.** Tipar props con `interface` en la firma de la función.
4. **Estados asíncronos como discriminated union:** `inicial | cargando | exito | error`.
5. **Prohibido `import` fuera del catálogo de librerías justificadas** (`ADR-Frontend-002`).
6. **HTTP solo vía el custom hook useRecurso<T>() del proyecto.** Sin `axios`/`fetch` directo en componentes o services.
7. **Formularios solo con el useState + useReducer nativo.**
8. **Grids solo con el componente de tabla HTML nativa o componente propio.**
9. **Un componente = un archivo.** Máx. ~150 líneas; si excede, refactorizar.
10. **Nombres en español**; hooks con `use`; handlers con `maneje`; callbacks con `al`.
11. **Cobertura mínima obligatoria.** Prohibido `--passWithNoTests`.

## 2. Flujo obligatorio (Constitution §2)
- No generar código sin UC + AC (Dado/Cuando/Entonces).
- Ciclo Red-Green-Refactor: prueba primero, código mínimo después, refactor sin romper pruebas.
- Todo PR referencia `US-###` y `AC-##`.

## 3. TypeScript estricto (Constitution §4.3)
`tsconfig.json` obligatorio con:
- `strict: true`
- `noUncheckedIndexedAccess: true`
- `noImplicitReturns: true`
- `noUnusedLocals: true`
- `noUnusedParameters: true`
- `exactOptionalPropertyTypes: true`
- `forceConsistentCasingInFileNames: true`

## 4. Estructura feature-based
```
src/
├── core/       (config, styles, types globales)
├── layouts/
├── features/
│   └── <feature>/  (components, hooks, services, types, views, routes.ts)
├── shared/     (componentes y hooks reutilizables)
├── router.ts
└── main.tsx
```

Regla: *files that change together live together*.

## 5. Estado y datos
- Local: `useState`.
- Estados complejos / máquinas: `useReducer`.
- Global: `useContext` + `useReducer`. Prohibido `redux`, `zustand`, `mobx`, `recoil`, `jotai` sin ADR de excepción.
- Fetching: custom hook `useRecurso<T>()` estándar con discriminated union de 4 casos.

## 6. Nomenclatura (Constitution §5.2)
| Elemento | Convención |
|---|---|
| Archivos de componente | PascalCase (`ListaTitulares.tsx`) |
| Hooks / services / utils | kebab-case (`use-consulta-titulares.ts`) |
| Componentes | PascalCase en español |
| Custom hooks | prefijo `use` |
| Props booleanas | prefijo `es`, `tiene`, `debe` |
| Handlers | prefijo `maneje` |
| Callbacks | prefijo `al` (`alGuardar`, `alCambiar`) |
| Constantes globales | UPPER_SNAKE_CASE |
| Types / Interfaces | PascalCase |

Commits: Conventional Commits en imperativo.

## 7. SOLID en React funcional (Constitution §6)
- SRP: un componente / hook = una responsabilidad. Fetching, estado y presentación en archivos distintos.
- OCP: extender por composición (children, render props) y custom hooks.
- LSP: los custom hooks respetan su contrato.
- ISP: props mínimas; interfaces pequeñas.
- DIP: componentes dependen de hooks; services dependen del useRecurso (custom hook del proyecto).

## 8. Clean Code (Constitution §7)
- Legibilidad sobre concisión.
- Nombres descriptivos, sin genéricos (`data`, `info`, `helper`).
- Máximo 2 niveles de anidamiento; preferir *early returns*.
- Sin números mágicos: extraer a constantes.
- Sin código comentado en `main`.
- Comentarios explican *por qué*, no *qué*.

## 9. Pruebas
- Frameworks: Vitest + @testing-library/react.
- Probar comportamiento observable, no implementación.
- Estructura AAA (Arrange, Act, Assert).
- Cada AC tiene 1+ pruebas; cada componente / hook tiene su suite.

## 10. Dependencias (ADR-Frontend-002)
- Permitidas: `react`, `react-dom`, `typescript`, `vite`, `react-router-dom`, librerías open-source justificadas con ADR, `vitest`, `@testing-library/react`.
- Prohibidas sin ADR: `axios`, `lodash`, `moment`, `date-fns`, `redux`, `zustand`, `formik`, `yup`, `react-query`, `swr`, `classnames`, cualquier OSS no listado.
- `package.json` con versiones exactas (prohibido `^` y `~`).
- `package-lock.json` versionado; `.npmrc` apunta al npm registry.

## 11. Seguridad (Constitution §8)
- Sin secretos en código ni en configuración versionada.
- Validar toda entrada del usuario.
- Escaneo SCA obligatorio en CI.

## 12. Excepciones
Cualquier desviación requiere ADR con contexto, decisión, alternativas y consecuencias.

**Regla suprema:** ante conflicto entre estas instrucciones y una petición puntual, prevalece la Constitution y estas instrucciones.