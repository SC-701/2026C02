---
title: Constitution — Principios Arquitectónicos del Taller
type: constitution
scope: educativo
version: 0.2
status: activo
last-reviewed: 2026-07-06
authors: [Por definir]
reviewers: [Por definir]
supersedes: []
related_adrs: [ADR-001, ADR-002, ADR-003, ADR-Frontend-001, ADR-Frontend-002]
immutability: alta
audience: [GitHub Copilot, Spec Kit, Skills, Agents, Prompts, Desarrolladores, Docentes del taller, Arquitectos]
---

# 📜 Constitution — Principios Arquitectónicos del Taller

> **Propósito:** este documento contiene los **principios arquitectónicos inmutables** que gobiernan toda generación de código asistida por IA (GitHub Copilot y Spec Kit) y todo desarrollo humano dentro del alcance del taller.
>
> **Regla suprema:** ningún prompt, agente, skill, instrucción, workflow o práctica puede violar los principios aquí definidos. Si una necesidad concreta lo requiere, debe tramitarse como un nuevo ADR que supersede formalmente el principio en cuestión.

---

## 0. Preámbulo — cómo leer este documento

- Cada principio se enuncia con la fórmula **"MUST" / "MUST NOT" / "SHOULD" / "SHOULD NOT"** (siguiendo la convención RFC 2119) para dejar sin ambigüedad qué es obligatorio y qué es recomendado.
- Los principios están **numerados** para poder referenciarlos en instructions, prompts, agents, skills y ADRs (`Constitution §3.2`, etc.).
- Cada principio incluye su **fundamento** (por qué existe) y su **verificación** (cómo se comprueba).
- Este documento es **inmutable en su intención**. Los ajustes se hacen creando un ADR que lo modifica o supersede.
- Está escrito para ser **consumible por Copilot como contexto de generación**. Por eso mantiene estructura simple, oraciones cortas y ejemplos concretos.

---

## 1. Principios rectores generales

### 1.1 Estándares de industria
El código y la documentación **MUST** basarse en estándares reconocidos (React docs, Microsoft Learn, Clean Architecture, SOLID, C4, ADR, Spec Kit, TDD Red-Green-Refactor). Toda excepción **MUST** justificarse en un ADR.

### 1.2 Fundamentación explícita
Toda decisión relevante **MUST** referenciar un estándar externo o una política interna vigente. Las decisiones "porque sí" están prohibidas.

### 1.3 Documento como artefacto ejecutable
Todo documento del ciclo de vida (UC, AC, ADR, spec) **MUST** alimentar directamente pruebas, prompts, workflows o revisión de código. Se prohíbe el "documento de vitrina".

### 1.4 Único punto de verdad
La fuente primaria de la especificación **MUST** residir en la carpeta `docs/` del repositorio, versionada en Git. Las Wikis y otros sistemas **MUST** ser *front doors* que apuntan al repositorio, no fuentes primarias.

### 1.5 Mínimo suficiente
Solo se documenta y se implementa lo que aporta valor accionable. La sobre-documentación y el over-engineering **MUST NOT** aceptarse.

### 1.6 Trazabilidad end-to-end
La cadena **US → UC → AC → Prueba → Código → Commit → PR** **MUST** ser reconstruible en todo momento. Cada eslabón referencia al anterior.

### 1.7 Dependencias mínimas
Toda dependencia externa **MUST** estar en el catálogo de librerías justificadas con ADR. Las excepciones **MUST** aprobarse conjuntamente por Arquitectura y docente del taller.

---

## 2. Principios del flujo de desarrollo (SDD + TDD)

### 2.1 Spec antes que código
Ningún cambio productivo **MUST** iniciarse sin un caso de uso (UC) con criterios de aceptación (AC) en formato GWT (`Dado / Cuando / Entonces`). Las únicas excepciones son cambios cosméticos puros (formato, comentarios, renombres).

### 2.2 Test antes que implementación (TDD)
El ciclo obligatorio es **🔴 RED → 🟢 GREEN → 🔵 REFACTOR**:

1. **RED** — escribir la prueba que falla derivada del AC.
2. **GREEN** — escribir el código mínimo que hace pasar la prueba.
3. **REFACTOR** — aplicar SOLID + Clean Code sin romper las pruebas.

Ningún código productivo **MUST** existir sin una prueba que lo respalde.

### 2.3 Relación 1 a 1 entre AC, pruebas y código
- 1 AC **MUST** tener 1 o más pruebas unitarias.
- 1 prueba unitaria **MUST** validar 1 unidad pública de código.
- 1 unidad de código **MUST** estar cubierta por 1 o más pruebas.

### 2.4 Cobertura mínima
El proyecto **MUST** definir cobertura mínima en CI. **MUST NOT** usarse `--passWithNoTests` ni equivalentes que oculten ausencia de pruebas.

### 2.5 Escenarios mínimos obligatorios por UC
Todo caso de uso **MUST** cubrir con AC los 6 escenarios siguientes cuando apliquen:

1. Éxito (happy path).
2. Validación de entrada.
3. Autenticación / autorización.
4. No encontrado / vacío.
5. Duplicidad / idempotencia.
6. Fallo de dependencia externa.

### 2.6 Nomenclatura de pruebas
Los nombres de las pruebas **MUST** seguir el patrón `Metodo_Escenario_ResultadoEsperado`. La prueba debe leerse como una afirmación verificable.

### 2.7 Trazabilidad en el commit y PR
Todo commit o PR de código productivo **MUST** referenciar el AC que atiende (`AC-##`) y la historia de usuario (`US-###`). El PR **MUST** demostrar la trazabilidad AC ↔ Test ↔ Código.

---

## 3. Principios de arquitectura backend (C# API)

### 3.1 Arquitectura por capas
Toda solución backend **MUST** organizarse en 6 capas con responsabilidades separadas:

| Capa | Responsabilidad única |
|---|---|
| **Abstracciones** | Modelos + interfaces. **MUST NOT** contener implementación. |
| **API** | Recibir HTTP, validar shape, delegar a Flujo. **MUST NOT** contener lógica de negocio. |
| **Flujo** | Orquestar el caso de uso (transacciones, secuencia). |
| **Reglas** | Reglas de negocio puras. **MUST NOT** hacer I/O. |
| **Servicios** | Adaptadores a servicios externos. |
| **AccesoDatos** | Acceso a base de datos. **MUST NOT** contener lógica de negocio. |

### 3.2 Regla de dependencia (Dependency Rule)
Las dependencias **MUST** apuntar siempre hacia adentro: hacia `Abstracciones`. Ninguna capa **MUST** depender de detalles concretos de otra capa; solo de interfaces publicadas en `Abstracciones`.

### 3.3 Composition Root único
La composición de dependencias (DI container, wiring de servicios) **MUST** realizarse exclusivamente en la capa `API` (composition root). Ninguna otra capa **MUST** construir instancias concretas de otras capas.

### 3.4 Un proyecto de pruebas por capa
Cada capa **MUST** tener su propio proyecto de pruebas espejado en la carpeta `tests/`. La suite **MUST** poder ejecutarse completa desde CI.

### 3.5 Controllers "thin"
Los controllers **MUST** limitarse a: recibir la petición HTTP, validar el shape del payload, invocar al Flujo (`Flujo`) y mapear la respuesta. Todo lo demás **MUST** vivir en capas inferiores.

### 3.6 Reglas de negocio puras
La capa `Reglas` **MUST NOT** hacer llamadas a base de datos, servicios externos, IO de archivos ni logs. **MUST** ser determinística y unit-testeable en aislamiento.

### 3.7 Nomenclatura de proyectos
Los proyectos **MUST** seguir la nomenclatura `<Prefijo>.<Producto>.<Capa>` (ej. `Producto.Api`, `Producto.Flujo`, `Producto.Abstracciones`).

---

## 4. Principios de arquitectura frontend (SPA React + TypeScript)

### 4.1 Solo componentes funcionales + hooks
Todo componente **MUST** ser una función. `class extends React.Component` **MUST NOT** usarse. **Única excepción:** `ErrorBoundary` (limitación técnica de React).

### 4.2 Toda lógica reutilizable en custom hooks
Cuando una lógica (fetching, cálculo, estado derivado) se necesite en más de un componente, **MUST** extraerse a un custom hook con prefijo `use`.

### 4.3 TypeScript estricto
`tsconfig.json` **MUST** activar como mínimo:

- `strict: true`
- `noUncheckedIndexedAccess: true`
- `noImplicitReturns: true`
- `noUnusedLocals: true`
- `noUnusedParameters: true`
- `exactOptionalPropertyTypes: true`
- `forceConsistentCasingInFileNames: true`

`any` **MUST NOT** usarse. Cuando el tipo sea desconocido, **MUST** usarse `unknown` con estrechamiento explícito.

### 4.4 Tipado de props
Los props **MUST** tipar-se con `interface` en la firma de la función. `React.FC` **MUST NOT** usarse (limitaciones con genéricos y `children` implícito).

### 4.5 Estados asíncronos como discriminated unions
Todo estado asíncrono **MUST** modelarse como una discriminated union con al menos los 4 casos: `inicial | cargando | exito | error`. TypeScript **MUST** obligar a manejar todos los casos en el render.

### 4.6 Estructura feature-based
El código **MUST** organizarse por **features** (dominios funcionales) y no por tipo de archivo. Cada feature agrupa sus `components/`, `hooks/`, `services/`, `types/`, `views/` y `routes.ts`.

### 4.7 Manejo de HTTP, formularios y grids
- HTTP **MUST** hacerse vía el custom hook useRecurso<T>() del proyecto.
- Formularios **MUST** usar el useState + useReducer nativo.
- Grids **MUST** usar el componente de tabla HTML nativa o componente propio.
- `axios`, `fetch` directo en componentes, `formik`, `react-hook-form`, librerías de grid externas, etc. **MUST NOT** usarse.

### 4.8 Estado global
El estado global **MUST** manejarse con `useState` + `useReducer` + `useContext`. Librerías externas de estado (`redux`, `zustand`, `mobx`, `recoil`, `jotai`) **MUST NOT** usarse sin ADR de excepción.

### 4.9 Tamaño de componente
Un componente **MUST** vivir en un solo archivo y **SHOULD** no exceder ~150 líneas. Si excede, **MUST** refactorizarse en componentes menores o custom hooks.

### 4.10 Dependencias del SPA
Solo **MUST** usarse dependencias del catálogo de librerías justificadas (ver `ADR-Frontend-002`). `package.json` **MUST** usar versiones exactas (prohibido `^` y `~`), `package-lock.json` **MUST** estar versionado, y `.npmrc` **MUST** apuntar al npm registry.

---

## 5. Principios de nomenclatura y estilo

### 5.1 Idioma
Los identificadores de dominio (clases, métodos, variables, props, componentes) **MUST** escribirse en **español**. Las palabras reservadas del lenguaje, frameworks y librerías **MUST** mantenerse en su idioma original.

### 5.2 Nomenclatura frontend

| Elemento | Convención |
|---|---|
| Archivos de componente | PascalCase (`ListaTitulares.tsx`) |
| Hooks, services, utils | kebab-case (`use-consulta-titulares.ts`) |
| Componentes | PascalCase en español |
| Custom hooks | prefijo `use` obligatorio |
| Props booleanas | prefijo `es`, `tiene`, `debe` |
| Handlers internos | prefijo `maneje` |
| Props de callback | prefijo `al` (`alGuardar`, `alCambiar`) |
| Constantes globales | UPPER_SNAKE_CASE |
| Types / Interfaces | PascalCase |

### 5.3 Nomenclatura backend

| Elemento | Convención |
|---|---|
| Clases | PascalCase en español |
| Métodos públicos | PascalCase (C# estándar) |
| Métodos privados | PascalCase (C# estándar) |
| Interfaces | Prefijo `I` + PascalCase |
| Variables locales | camelCase |
| Constantes | PascalCase o UPPER_SNAKE_CASE según convención del proyecto |
| Pruebas | `Metodo_Escenario_ResultadoEsperado` |

### 5.4 Commits
Los mensajes de commit **MUST** seguir **Conventional Commits** en imperativo (`feat: agregar consulta de titulares`, no `agregando` ni `agregado`). Los tipos válidos son: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `hotfix`.

---

## 6. Principios SOLID (aplicables a backend y frontend)

Cada PR **MUST** verificar el cumplimiento de los 5 principios como parte del refactor:

### 6.1 SRP — Single Responsibility Principle
Cada clase / componente / hook **MUST** tener una única razón para cambiar.

### 6.2 OCP — Open/Closed Principle
Las unidades **MUST** ser extensibles sin modificar su código existente. Usar composición, estrategias y polimorfismo.

### 6.3 LSP — Liskov Substitution Principle
Las implementaciones **MUST** ser sustituibles por su abstracción sin romper el comportamiento esperado.

### 6.4 ISP — Interface Segregation Principle
Las interfaces **MUST** ser pequeñas y cohesivas. Preferir muchas interfaces específicas antes que una gigante.

### 6.5 DIP — Dependency Inversion Principle
Las dependencias **MUST** apuntar a abstracciones, nunca a concreciones.

---

## 7. Principios de Clean Code

### 7.1 Legibilidad primero
El código **MUST** priorizar legibilidad sobre concisión. Un desarrollador nuevo **MUST** poder entender el propósito de un método sin ejecutar el debugger.

### 7.2 Nombres descriptivos
Nombres de variables, métodos y clases **MUST** expresar intención. Nombres genéricos (`data`, `info`, `manager`, `helper`, `util`) **MUST NOT** usarse cuando exista un nombre más específico.

### 7.3 Métodos cortos
Los métodos **SHOULD** tener ≤ 20 líneas. Los métodos que excedan **MUST** revisarse para posible extracción.

### 7.4 Sin números mágicos
Los valores literales significativos **MUST** extraerse a constantes con nombre.

### 7.5 Sin niveles profundos de anidamiento
Los métodos **SHOULD** limitarse a 2 niveles de anidamiento. Preferir *early returns* y *guard clauses*.

### 7.6 Sin código muerto
Código comentado que "puede servir después" **MUST NOT** vivir en `main`. El historial de Git es la memoria del proyecto.

### 7.7 Comentarios cuando aportan
Los comentarios **MUST** explicar el *por qué*, no el *qué*. Si un comentario describe *qué hace* el código, el código debería reescribirse para ser autoexplicativo.

---

## 8. Principios de seguridad

### 8.1 Sin secretos en el repositorio
Credenciales, tokens, cadenas de conexión con contraseñas y llaves privadas **MUST NOT** vivir en el código ni en la configuración versionada. Usar el gestor de secretos aprobado.

### 8.2 Validación de entradas
Toda entrada externa (usuario, API, archivos, colas) **MUST** validarse antes de procesarse. La validación **MUST** ocurrir lo más cerca posible del borde del sistema.

### 8.3 Principio de menor privilegio
Los servicios, cuentas y componentes **MUST** operar con los mínimos privilegios necesarios para su función.

### 8.4 Cadena de suministro
Solo **MUST** usarse dependencias del catálogo de librerías justificadas. El escaneo de vulnerabilidades **MUST** ejecutarse en CI. Los hallazgos críticos y altos **MUST** resolverse antes del merge.

### 8.5 MCP con guardarraíles
Los servidores MCP conectados a Copilot **MUST** estar en el catálogo autorizado por docente del taller. Por defecto **MUST** operar en modo *read-only*.

---

## 9. Principios de personalización de Copilot

### 9.1 Instructions siempre activas
El repositorio **MUST** incluir un `.github/copilot-instructions.md` con las reglas mínimas. Este archivo **MUST NOT** exceder 4.000 caracteres.

### 9.2 Prompts como macros gobernadas
Los prompts del taller **MUST** vivir en `.github/prompts/` con frontmatter que declare `mode`, `description`, `tools`, `owner`, `version`. Un prompt **MUST** tener un único objetivo homogéneo.

### 9.3 Agentes con límites explícitos
Los agentes en `.github/agents/` **MUST** documentar sus 6 secciones obligatorias: comandos ejecutables, testing, estructura, estilo, git workflow, límites ("never touch").

### 9.4 Skills como procedimientos gobernados
Los Skills del taller **MUST** vivir en `.github/skills/*.skill.md` (o en el hub central `academia/docs/skills/`) con frontmatter que declare `id`, `name`, `description`, `scope`, `inputs`, `outputs`, `used_by_agents`, `used_by_prompts`, `owner`, `version`. Cada Skill **MUST** contener las 9 secciones obligatorias: Propósito · Cuándo usarlo · Cuándo NO usarlo · Entradas · Pasos · Validaciones · Salidas · Ejemplos · Referencias.

Un Skill **MUST** representar un procedimiento **repetible y componible**. Un Skill **MAY** invocar a otros Skills. Un Skill **MUST NOT** invocar Agents (regla anti-ciclo). Si una necesidad puede resolverse con un Prompt puntual o una Instruction siempre activa, **MUST NOT** crearse un Skill.

### 9.5 Workflows con Safe Outputs
Los workflows agentic **MUST** usar Safe Outputs para toda escritura. **MUST NOT** escribir directamente a issues, PRs o ramas sin buffer + validación humana.

### 9.6 MCP bajo aprobación explícita
Ningún MCP **MUST** conectarse a sistemas productivos sin aprobación de docente del taller y sin estar en el catálogo de librerías justificadas.

---

## 10. Principios de gobierno y ciclo de vida

### 10.1 Cambios a la Constitution
La Constitution **MUST** modificarse únicamente mediante un ADR que la referencie explícitamente y describa el principio afectado. El ADR **MUST** ser aprobado por la coordinación del taller.

### 10.2 Ciclo de vida de artefactos
Todo artefacto del taller (Instructions, Prompts, Agents, Skills, MCP, Workflows, Templates) **MUST** pasar por: propuesta (PR) → taller documentado → feedback abierto → aprobación → publicación → revisión periódica → deprecación con ADR de sustitución si aplica.

### 10.3 Revisión periódica
La Constitution **MUST** revisarse al menos una vez por trimestre y al final del taller. Los hallazgos **MUST** alimentar la versión 1.0.

### 10.4 Excepciones documentadas
Toda excepción a un principio **MUST** documentarse como ADR con contexto, decisión, alternativas y consecuencias. Excepciones no documentadas **MUST NOT** aceptarse.

---

## 11. Verificación y cumplimiento

Los mecanismos de verificación de esta Constitution son:

| Nivel | Mecanismo |
|---|---|
| Generación | `copilot-instructions.md` + `instructions/*.instructions.md` + `prompts/*.prompt.md` + `skills/*.skill.md` alimentados por esta Constitution |
| Local | Linter, formatter, pre-commit hooks |
| Continuo | Workflows CI (build, test, cobertura, SCA, Sonar) |
| Agentic | Workflows agentic (validar UC, validar dependencias, validar arquitectura por capas) con Safe Outputs |
| Humano | Revisión de código obligatoria por al menos 1 par |
| Taller | Retrospectivas del taller + auditoría trimestral del catálogo de librerías justificadas |

---

## 12. Resumen ejecutivo

Los 12 mandatos que resumen esta Constitution:

1. 📜 **Especificar antes de codificar** (UC + AC en GWT).
2. 🧪 **Probar antes de implementar** (Red-Green-Refactor).
3. 🔗 **Trazar de punta a punta** (US → UC → AC → Test → Código → PR).
4. 🏛️ **Respetar la arquitectura por capas** en backend.
5. ⚛️ **Solo funciones + hooks + TypeScript estricto** en frontend.
6. 📦 **Solo dependencias del catálogo de librerías justificadas**.
7. 🏗️ **SOLID en cada refactor**.
8. 🧹 **Clean Code sin excepciones**.
9. 🔒 **Seguridad como principio no negociable**.
10. 🤖 **Copilot gobernado por Instructions, Prompts, Agents, Skills y Workflows**.
11. 📚 **Documento como artefacto ejecutable** — nada de "vitrina".
12. 🗳️ **Excepciones solo vía ADR** — nunca por decisión ad-hoc.

---

## 13. Referencias

- **ADRs vigentes:** `ADR-001` (polirrepo), `ADR-002` (SDD+TDD), `ADR-003` (Skills como 8° elemento de personalización), `ADR-Frontend-001` (React funcional), `ADR-Frontend-002` (dependencias).
- **Documento maestro:** `academia/docs/copilot-estrategia.md`.
- **Estándares externos:** Robert C. Martin (Clean Architecture, Clean Code, SOLID), Kent Beck (TDD), Martin Fowler (Refactoring), React docs, TypeScript Handbook, Michael Nygard (ADR), Simon Brown (C4), GitHub Spec Kit, GitHub Copilot Customization Handbook, OWASP, OpenSSF Scorecard, Microsoft Secure Future Initiative.

---

## 14. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |
| 0.2 | 2026-07-06 | Por definir | Incorporación de Skills como procedimientos gobernados (nuevo §9.4). Renumeración: §9.4 Workflows → §9.5; §9.5 MCP → §9.6. Actualización de §10.2 (ciclo de vida incluye Skills). Actualización de §11 (verificación menciona Skills). Actualización de §12 mandato 10 (Skills incluidos). Actualización de audience del frontmatter. Actualización de §13 (agregado ADR-003). Bump 0.1 → 0.2. |

---

*Constitution versión 0.2 · Taller · Este documento gobierna sobre prompts, agents, skills, instructions y workflows.*