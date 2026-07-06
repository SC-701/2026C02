---
layout: cover
theme: light-icons
title: Ingeniería de Software Asistida por IA con GitHub Copilot
info: Curso piloto · 2 sesiones × 3 horas
author: Curso académico
aspectRatio: '16/9'
fonts:
  sans: Inter
  mono: Fira Code
highlighter: shiki
---

# Ingeniería de Software Asistida por IA con GitHub Copilot

## Cómo construir software profesional con límites gobernados

**Curso piloto · Ingeniería Informática**

Sesión 1 · Fundamentos

<!--
🎤 Presentarse: nombre, experiencia con IA y desarrollo de software.
Mencionar que el curso tiene 2 sesiones de 3 horas: hoy teoría + fundamentos, la próxima sesión práctica hands-on.
Preguntar: ¿quién ya usa Copilot? ¿Con qué frecuencia? ¿Sin guía o con algún sistema?
Objetivo general: al final del curso van a poder gobernar a Copilot con un sistema completo, no solo usarlo libremente.
-->

---

# Agenda del curso

## Sesión 1 · Fundamentos (hoy)

- **Contexto:** modelos de IA, VS Code y GitHub Copilot
- El problema que resolvemos
- Los 8 elementos de personalización de Copilot
- La Constitution: principios inmutables
- Spec-Driven Development + Test-Driven Development
- Arquitectura por capas (backend) y feature-based (frontend)

## Sesión 2 · Práctica

- Setup de un proyecto real
- Ciclo TDD guiado por Copilot
- Workflows agentic automáticos
- Cierre y retrospectiva

<!--
🎤 Dar 2 minutos para que lean la agenda.
Destacado: hoy no vamos a codear, vamos a construir el sistema mental que hace que el código de mañana sea bueno.
Sesión 2 será 100% práctica: van a escribir un feature completo end-to-end usando todo lo de hoy.
Preguntar si hay alguna duda sobre la estructura antes de arrancar.
-->

---

# ¿Qué es un Modelo de IA?

## La capa de inteligencia detrás de Copilot

Los **Large Language Models (LLMs)** son sistemas entrenados en enormes cantidades de texto que aprenden a predecir y generar lenguaje — incluido código.

<div class="grid-2">

<div>

### Cómo funcionan
- Procesan texto como **tokens** (fragmentos de palabras)
- Predicen el siguiente token más probable
- El **contexto** (ventana) determina cuánto “recuerdan”
- La **temperatura** controla creatividad vs. precisión

</div>

<div>

### Para desarrollo de software
- Entienden código como un lenguaje más
- Generan, explican y refactorizan código
- Razonan sobre arquitectura y patrones
- Producen mejores resultados con **contexto claro**

</div>

</div>

<div class="regla">
🎯 Un LLM no “piensa” — <strong>predice</strong>. Por eso el contexto que le damos es tan importante.
</div>

<!--
🎤 Analogía: el LLM es como un autocompletado extremadamente sofisticado — entrenado en todo el código del mundo.
Concepto clave: ventana de contexto — todo lo que le pasás en el prompt (Constitution, UC, historial) entra en esa ventana.
Temperatura: 0 = determinista/preciso (bueno para código), 1 = creativo/variado (bueno para ideas).
No hace falta profundizar más — con esto alcanza para entender por qué el contexto gobernado importa.
-->

---

# El ecosistema de modelos

## Principales proveedores y sus modelos

| Empresa | Modelos destacados | Fortaleza principal |
|---|---|---|
| **OpenAI** | GPT-4o, GPT-4.1, o3 | Versatilidad, razonamiento |
| **Anthropic** | Claude Sonnet 4.5, Claude Opus 4 | Código, instrucciones largas |
| **Google** | Gemini 2.0 Flash, Gemini 2.5 Pro | Multimodal, contexto extenso |
| **Meta** | Llama 3.3, Llama 4 Scout | Open source, personalizable |
| **Mistral** | Mistral Large, Codestral | Eficiencia, especializado en código |
| **DeepSeek** | DeepSeek V3, DeepSeek R1 | Razonamiento, bajo costo |

<div class="regla">
💡 GitHub Copilot te permite elegir el modelo base: GPT-4o, Claude Sonnet, Gemini 2.0 Flash y más desde el selector de modelos.
</div>

<!--
🎤 Mencionar que los modelos evolucionan rápidamente — los de esta tabla son los líderes al momento del curso.
Antropic Claude es el que Copilot usa por defecto en el modo Chat en versiones recientes.
DeepSeek R1 es destacable por ser open source con capacidad de razonamiento similar a o1.
Para este curso usamos el modelo que Copilot tenga configurado — no es necesario cambiarlo.
-->

---

# Modelos en la nube vs. modelos locales

## Dos paradigmas, distintos trade-offs

<div class="grid-2">

<div>

### ☁️ Modelos en la nube
*(OpenAI, Anthropic, Google…)*

- ✅ Máxima capacidad y contexto largo
- ✅ Sin requisitos de hardware
- ✅ Actualizaciones automáticas
- ✅ Multimodal (imagen, voz, código)
- ⚠️ Los datos salen de tu máquina
- ⚠️ Requiere conexión a internet
- ⚠️ Costo por token en uso intensivo
- ⚠️ Latencia variable

</div>

<div>

### 🖥️ Modelos locales
*(Ollama, LM Studio, llama.cpp…)*

- ✅ Los datos **nunca salen** del equipo
- ✅ Sin costo por uso (solo hardware)
- ✅ Funciona sin internet
- ✅ Latencia predecible
- ⚠️ Capacidad limitada por la GPU/RAM
- ⚠️ Modelos más pequeños (7B–70B)
- ⚠️ Requiere configuración inicial
- ⚠️ Sin multimodalidad avanzada

</div>

</div>

<div class="regla">
🔒 <strong>Regla de oro:</strong> código propietario o datos sensibles → modelo local. Productividad general → nube con plan corporativo.
</div>

<!--
🎤 Herramientas locales más usadas: Ollama (el más simple — `ollama run llama3`) y LM Studio (interfaz gráfica).
Modelos locales recomendados para código: Codestral (Mistral), Qwen2.5-Coder, DeepSeek-Coder-V2.
GitHub Copilot con modelo local: desde VS Code se puede apuntar Copilot Chat a un servidor Ollama local vía extensión.
Caso de uso real: empresa con restricciones legales (salud, finanzas) que no puede mandar código a servidores externos.
Pregunta al grupo: ¿su empresa tiene política de uso de IA en la nube? ¿Saben si el código que mandan a Copilot se usa para entrenamiento?
-->

---

# Visual Studio Code

## El entorno del curso

<div class="grid-2">

<div>

### Áreas de la interfaz
- **Activity Bar** — Explorer, Git, Extensiones, Copilot
- **Editor** — área principal de código (tabs mútiples)
- **Panel inferior** — Terminal, Problemas, Salida
- **Status Bar** — rama Git, errores, extensiones activas

### Atajos esenciales
| Atajo | Acción |
|---|---|
| `Ctrl+P` | Abrir archivo rápido |
| `Ctrl+Shift+P` | Paleta de comandos |
| `` Ctrl+` `` | Abrir terminal |
| `Ctrl+Shift+X` | Panel de extensiones |

</div>

<div>

### Extensiones necesarias para el curso

- 🤖 **GitHub Copilot** — completado inline + chat
- 💬 **GitHub Copilot Chat** — agentes y prompts
- 🔵 **C# Dev Kit** — soporte .NET 8
- ⚡ **ESLint** — linting TypeScript/React
- 📊 **GitLens** — historial y anotaciones Git

<br>

Verificar instalación: `Ctrl+Shift+X` → buscar cada extensión.

</div>

</div>

<!--
🎤 Mostrar la interfaz de VS Code en pantalla y señalar cada área mientras se describe.
Destacado: la Activity Bar tiene un ícono nuevo de Copilot — desde ahí se accede al chat y al modo agentes.
Paleta de comandos (`Ctrl+Shift+P`): todo lo que se puede hacer en VS Code está aquí — incluyendo comandos de Copilot.
Verificar en vivo que todos tengan las extensiones instaladas antes de avanzar.
-->

---

# GitHub Copilot

## Tu par de programación con IA

<div class="grid-3">

<div class="fase blue">
<strong>✏️ Completado inline</strong><br>
Sugerencias automáticas mientras escribís. <code>Tab</code> para aceptar, <code>Esc</code> para rechazar, <code>Alt+]</code> para ver la siguiente.
</div>

<div class="fase green">
<strong>💬 Chat lateral</strong><br>
Preguntas en lenguaje natural. Contexto persistente. Activá con <code>Ctrl+Alt+I</code> o el ícono de la Activity Bar.
</div>

<div class="fase" style="border-left-color: #8B5CF6">
<strong>🤖 Agentes</strong><br>
Modos especializados: <code>@workspace</code> (repo completo), <code>@terminal</code> (shell), agentes personalizados.
</div>

</div>

<div class="grid-2" style="margin-top:1rem">

<div class="fase">
<strong>✏️ Edición inline</strong> — <code>Ctrl+I</code><br>
Modificá código seleccionado con una instrucción directa en el editor.
</div>

<div class="fase" style="border-left-color: #F59E0B">
<strong>📦 Copilot Edits</strong><br>
Cambios coordinados en múltiples archivos a la vez con un solo prompt.
</div>

</div>

<!--
🎤 Hacer una demo rápida de cada modo: escribir una función y mostrar el completado inline, luego abrir el chat.
Atajo más importante: `Ctrl+I` para edición inline — seleccioná código + Ctrl+I + instrucción = cambio directo.
Copilot Edits es el modo más potente para refactorizaciones que tocan múltiples archivos.
Recordar: en este curso vamos a usar principalmente Chat (agentes) y Prompts (/comandos) — los modos más gobernables.
-->

---

# Eligiendo el modelo en Copilot

## El selector de modelos en VS Code

<div class="grid-2">

<div>

### Cómo cambiar el modelo
1. Abrir el **Chat lateral** de Copilot
2. Hacer clic en el selector de modelos (esquina superior)
3. Elegir el modelo según la tarea

### Guía rápida de elección
| Tarea | Modelo recomendado |
|---|---|
| Código cotidiano | GPT-4o · Claude Sonnet |
| Razonamiento complejo | o3 · Claude Opus |
| Respuestas rápidas | Gemini 2.0 Flash |
| Contexto muy largo | Gemini 2.5 Pro |

</div>

<div>

### Para este curso
Usaremos el **modelo por defecto** configurado en Copilot — generalmente Claude Sonnet o GPT-4o.

Lo importante **no es el modelo** sino:
- El contexto que le pasamos (Constitution, UC, AC)
- Las instrucciones que lo gobiernan
- Los prompts y skills que estructuran el pedido

<div class="regla">
💡 Un buen sistema de gobernanza funciona bien con cualquier modelo capaz.
</div>

</div>

</div>

<!--
🎤 Mostrar el selector de modelos en vivo en VS Code.
Mencionar que los modelos disponibles dependen del plan de Copilot (Individual, Business, Enterprise).
Mensaje clave: la gobernanza (Constitution, Instructions, Prompts) es más importante que qué modelo usar.
Esto conecta directamente con el resto del curso — construimos el sistema que funciona bien con cualquier LLM.
-->

---
layout: center
---

# Una sola regla

<div class="regla">
💬 Ante conflicto entre lo que Copilot sugiere y lo que la <strong>Constitution</strong> dice, la Constitution siempre gana.
</div>

Copilot es una herramienta poderosa, pero necesita **límites**.

Este curso te enseña a **construir esos límites**.

<!--
🎤 Repetir la regla en voz alta con el grupo: "la Constitution siempre gana".
Pedir que la anoten o fotografíen: van a volver a esta regla muchas veces durante el curso.
Énfasis: Copilot no es el problema — la falta de límites sí lo es. Esta regla es el ancla de todo el sistema.
No pasar de aquí sin que todos entiendan qué es la Constitution (la veremos pronto).
-->

---

# ¿Por qué gobernar a Copilot?

## El problema del "vibe-coding"

Copilot genera código a gran velocidad. Sin límites, esa velocidad se convierte en **deuda técnica**.

<div class="grid-2">

<div>

### Problemas frecuentes
- Código sin pruebas
- Arquitectura inconsistente
- Dependencias innecesarias
- Pérdida de contexto

</div>

<div>

### La solución
Gobernanza estructurada:
- Instructions siempre activas
- Prompts como macros
- Agents con límites
- Skills reutilizables
- Workflows agentic

</div>

</div>

<div class="actividad">
Pregunta al grupo: ¿Alguna vez aceptaste código de Copilot sin entenderlo del todo? ¿Qué pasó después?
</div>

<!--
🎤 Anécdota propia si tenés: un bug introducido por código aceptado sin revisión, o deuda técnica acumulada.
Esperar 2-3 respuestas del grupo antes de pasar — es importante que lo conecten con su experiencia.
Conclusion: velocidad sin gobernanza = deuda técnica. La solución no es usar menos Copilot, sino usarlo con sistema.
Mencionar que cada elemento del lado derecho lo van a ver en detalle hoy.
-->

---

# El sistema que vamos a estudiar

## Un paquete completo de gobernanza

```mermaid {scale: 0.75}
graph LR
  A([Constitution]) --> B([ADRs])
  B --> C([Instructions])
  C --> D(["Agents & Prompts<br/>Skills & MCP"])
  D --> E(["Templates<br/>UCs & US"])
  E --> F([Código + Tests])
  F --> G([Workflows agentic])
  style A fill:#1E3A8A,color:#fff,stroke:#1E3A8A
  style G fill:#10B981,color:#fff,stroke:#10B981
```

**Regla mental:** ante duda, la Constitution siempre gana. Todo lo demás sirve a ella.

<!--
🎤 Leer el diagrama de izquierda a derecha: Constitution → ADRs → Instructions → Agents/Prompts/Skills → Templates → Código → Workflows.
Cada nodo depende del anterior — si la Constitution cambia todo debería revisarse.
Pregunta rápida: ¿cuántos de estos elementos conocían antes del curso? Medir la línea base del grupo.
Destacado: el verde (Workflows agentic) es la meta final — automatización que verifica todo el pipeline.
-->

---

# ¿Qué es Spec-Driven Development?

## El enfoque que gobierna todo el curso

En lugar de pedirle a Copilot *"escribí este código"*, primero **especificamos** lo que queremos construir, luego Copilot trabaja *dentro de ese marco*.

<div class="grid-2">

<div class="fase blue">
<strong>Sin SDD</strong><br>
Prompt libre → Copilot adivina → código que puede no encajar → deuda técnica acumulada
</div>

<div class="fase green">
<strong>Con SDD</strong><br>
Spec (UC + AC) → Copilot con contexto → código trazable → calidad predecible
</div>

</div>

<div class="regla">
🎯 La especificación no es burocracia — es el <strong>contrato</strong> entre el equipo y la IA.
<br>
Cada artefacto (UC, AC, ADR) es leído por Copilot como contexto de cada solicitud.
</div>

<!--
🎤 Ejemplo concreto: sin SDD → "Copilot, hacé un endpoint de registro" → resultado aleatorio.
Con SDD → Copilot tiene el UC con los 6 AC, sabe exactamente qué espera cada escenario.
Analogía: es como darle a un contratista los planos arquitectónicos vs decirle "hacé una casa".
Pregunta: ¿qué es primero, el test o el spec? El spec (UC+AC) → luego el test → luego el código.
-->

---

# Los 8 elementos: el kit de gobernanza

## Por qué necesitamos 8 piezas, no solo prompts

Copilot puede recibir instrucciones de **8 formas distintas**, cada una con un propósito diferente. Conocerlas te permite elegir la herramienta correcta para cada situación:

- Algunas van **siempre activas** (Instructions) — como las reglas de un contrato
- Otras se **invocan a demanda** (Prompts, Skills) — como comandos o procedimientos
- Otras **observan y reaccionan** (Workflows) — como sensores automáticos
- Otras **conectan sistemas externos** (MCP, Agents) — como integraciones

<div class="regla">
💡 Usar el elemento equivocado es el error más frecuente al empezar.<br>
Ejemplo: poner en un Prompt algo que debería ser una Instruction = se olvida en la próxima sesión.
</div>

<!--
🎤 Analogía del carpintero: tener 8 herramientas no significa usarlas todas — significa elegir la correcta para cada trabajo.
Error más común: usar Prompts para todo. Los Prompts son efímeros; las Instructions son permanentes.
Mencionar: en la Sesión 2 van a usar Agents, Prompts y Skills en la práctica real.
Destacar que Skills es el elemento más nuevo (ADR-003) y el que más diferencia hace en equipos.
-->

---

# Los 8 elementos de personalización

## Un mapa mental esencial

| # | Elemento | Analogía |
|---|---|---|
| 1 | Instructions | Reglas siempre activas (constitución del país) |
| 2 | Prompts | Atajo de teclado (comando puntual) |
| 3 | Agents | Persona con rol (piloto, copiloto) |
| 4 | **Skills** | Manual de procedimiento (receta) |
| 5 | MCP | Cable de conexión a otros sistemas |
| 6 | Workflows | Sensor automático (dispara ante evento) |
| 7 | Templates | Molde de partida |
| 8 | Documentación MD | Memoria del equipo |

<div class="actividad">
Cada estudiante escribe en 1 oración qué es cada elemento con sus palabras (3 min).
</div>

<!--
🎤 Dar exactamente 3 minutos para la actividad — usar temporizador visible.
Luego pedir 2-3 voluntarios que lean su oración para Instructions, Prompts y Skills.
Corregir gentilmente si confunden Agent con Skill — es el error más común.
No avanzar hasta que la distinción entre Instructions (siempre activo) y Prompt (a demanda) esté clara.
-->

---

# Regla de decisión: ¿Prompt, Agent o Skill?

## El error más frecuente al empezar

```
¿Es una tarea puntual que el usuario invoca?         → Prompt
¿Es una persona con propósito, tools y límites?      → Agent
¿Es un procedimiento repetible que otros componen?   → Skill
¿Es una regla siempre activa?                        → Instructions
¿Es una conexión a un sistema externo?               → MCP
¿Es una automatización disparada por evento?         → Workflow
```

### Ejemplos pedagógicos

- *"Generar un caso de uso"* → **Prompt** (`/generar-caso-de-uso`)
- *"Programador experto en React"* → **Agent** (`@programador-spa-react`)
- *"Aplicar SOLID a esta clase"* → **Skill** (`refactor-solid`)

<!--
🎤 Repasar el árbol de decisión con un ejemplo rápido del grupo: pedir un caso y que todos digan si es Prompt, Agent o Skill.
Énfasis: el árbol de decisión no es exhaustivo — con práctica se vuelve intuitivo en segundos.
Anticipo: en la Sesión 2 van a invocar `/generar-caso-de-uso` (Prompt) y el skill `refactor-solid` en vivo.
-->

---
layout: center
---

# ☕ Break

## 10 minutos

<!--
🎤 Anunciar el break: 10 minutos exactos. Al volver arrancamos con la pieza central: la Constitution.
Sugerir: usar el tiempo para reflexionar sobre cuál de los 8 elementos les parece más útil para su trabajo actual.
-->

---

# La Constitution — Ley suprema

## ¿Qué es una Constitution?

- Documento **inmutable** con principios arquitectónicos
- Escrito en **formato RFC 2119**: `MUST` / `MUST NOT` / `SHOULD` / `SHOULD NOT`
- Está **numerado** (§2.1, §3.2, …) para que Prompts, Agents, Skills y Workflows la referencien
- Solo se modifica vía **ADR aprobado**
- Es leída por Copilot como contexto en cada request

<div class="regla">
📚 <strong>Referencia académica:</strong> el concepto viene de <em>Spec Kit</em> (GitHub) — evolución de la ingeniería especificada.
</div>

<!--
🎤 Mostrar RFC 2119 brevemente: MUST = obligatorio sin excepciones, SHOULD = fuertemente recomendado, MAY = opcional.
Ejemplo real: "§2.1 — Todo endpoint MUST tener al menos un test de integración" es distinto a "SHOULD tener".
El numerado (§2.1, §3.2) es clave: permite que Prompts y Agents la referencien sin ambigüedad.
Pregunta: ¿qué pasa si el equipo quiere cambiar un MUST? → Necesita un ADR aprobado por el equipo.
-->

---

# Los 12 mandatos de la Constitution

## Resumen ejecutivo

<div class="grid-2">

<div>

1. 📜 **Especificar antes de codificar** (UC + AC en GWT)
2. 🧪 **Probar antes de implementar** (Red-Green-Refactor)
3. 🔗 **Trazar de punta a punta**
4. 🏛️ **Arquitectura por capas** en backend
5. ⚛️ **Funciones + hooks + TS estricto** en frontend
6. 📦 **Solo dependencias del catálogo blanco**

</div>

<div>

7. 🏗️ **SOLID en cada refactor**
8. 🧹 **Clean Code sin excepciones**
9. 🔒 **Seguridad no negociable**
10. 🤖 **Copilot gobernado**
11. 📚 **Documento como artefacto ejecutable**
12. 🗳️ **Excepciones solo vía ADR**

</div>

</div>

<!--
🎤 Leer todos en 90 segundos — son el contrato del equipo.
Pregunta clave para el grupo: ¿cuál les parece más difícil de cumplir en su proyecto actual? Esperar 2-3 respuestas.
Destacado: mandato 11 es el más ignorado — "documenta como artefacto ejecutable" significa que los docs generan código, no que existen para nadie.
Mandato 9 (seguridad) es no negociable: OWASP Top 10 aplicado en cada PR, no solo al final del sprint.
-->

---

# ADRs — Architecture Decision Records

## La memoria del equipo

Formato creado por **Michael Nygard** (2011). Cada decisión estructural se documenta:

<div class="grid-2">

<div>

- **Contexto** — qué problema resolvemos
- **Decisión** — qué elegimos
- **Alternativas** — qué evaluamos
- **Consecuencias** — qué compromiso asumimos

</div>

<div>

**Inmutables**: nunca se editan; se supersedan con otro ADR.

Ejemplos:
- ADR-001 — Polirrepo por producto
- ADR-002 — SDD + TDD obligatorio
- ADR-003 — Skills como 8° elemento

</div>

</div>

<div class="regla">
🎯 <strong>Regla:</strong> "sin ADR, no hay decisión". Toda excepción a la Constitution vive como ADR.
</div>

<!--
🎤 Mostrar el formato Nygard en pantalla si es posible: Contexto → Decisión → Alternativas → Consecuencias.
Ejemplo real ADR-002: "Decidimos SDD+TDD obligatorio. Alternativa evaluada: solo TDD. Consecuencia: los specs son leídos por Copilot como contexto."
Regla de oro: los ADRs son INMUTABLES. Si cambias de decisión, creas un ADR nuevo que supersede al anterior.
Pregunta: ¿alguien usa ADRs en su proyecto hoy? ¿Cómo documentan las decisiones de arquitectura actualmente?
-->

---

# Spec-Driven Development (SDD)

## La especificación como contrato ejecutable

- Cada historia de usuario genera un **caso de uso (UC)** en Markdown
- Cada UC contiene **criterios de aceptación (AC)** en formato **Given-When-Then (GWT)**
- El UC **NO es papel** — es leído por Copilot para generar pruebas y código

```markdown
### AC-01 · Registrar postal nueva
Dado un usuario autenticado
Cuando invoca POST /api/v1/postales con {numero:123}
Entonces el sistema responde HTTP 201
Y el cuerpo contiene {numero:123, estado:"poseida"}
```

<div class="regla">
📚 <strong>Referencia académica:</strong> viene de BDD (Behavior-Driven Development) de Dan North.
</div>

<!--
🎤 Leer el AC de ejemplo en voz alta como si fuera una historia: "Dado un usuario autenticado, cuando invoca POST..."
Destacado: el formato GWT (Given-When-Then) no es burocracia — es el input exacto que Copilot usará para generar los tests.
Pregunta: ¿en su equipo escriben criterios de aceptación? ¿En qué formato? ¿Los usa Copilot o quedan en Jira?
Mencionar: en la Sesión 2 van a ver cómo `/generar-prueba-desde-ac` lee este archivo y genera el test automáticamente.
-->

---

# Los 6 escenarios mínimos por UC

## Cobertura obligatoria de casos

| # | Escenario | Ejemplo |
|---|---|---|
| 1 | Éxito (happy path) | Registro correcto |
| 2 | Validación de entrada | Datos malformados → 400 |
| 3 | Autenticación / autorización | Sin token → 401 |
| 4 | No encontrado / vacío | Recurso inexistente → 404 |
| 5 | Duplicidad / idempotencia | Doble envío coherente |
| 6 | Fallo de dependencia externa | DB caída → 503 |

<div class="actividad">
Cada equipo escribe 6 AC para "Reservar un libro en la biblioteca" (10 min).
</div>

<!--
🎤 Formar grupos de 2-3 personas para la actividad. Dar exactamente 10 minutos.
Mientras trabajan, circular y verificar: ¿tienen los 6 escenarios? El más difícil suele ser AC-05 (idempotencia) y AC-06 (fallo externo).
Al finalizar, pedir a un grupo que comparta sus 6 AC y discutir el AC de fallo de dependencia externa.
Clave: si no pueden escribir el AC-06 es porque no pensaron en qué pasa cuando la base de datos se cae.
-->

---

# Test-Driven Development (TDD)

## El ciclo obligatorio

<div class="grid-3">

<div class="fase red">
<h2 style="margin:0">🔴 RED</h2>
Escribir una prueba que <strong>falla</strong>
</div>

<div class="fase green">
<h2 style="margin:0">🟢 GREEN</h2>
Escribir el código <strong>mínimo</strong> que hace pasar la prueba
</div>

<div class="fase blue">
<h2 style="margin:0">🔵 REFACTOR</h2>
Aplicar <strong>SOLID + Clean Code</strong> sin romper la prueba
</div>

</div>

## Regla 1 a 1

- 1 AC → 1+ pruebas
- 1 prueba → 1 unidad pública
- 1 unidad → 1+ pruebas

**Nomenclatura:** `Metodo_Escenario_ResultadoEsperado`

<div class="regla">
📚 Kent Beck, <em>Test-Driven Development: By Example</em> (2002).
</div>

<!--
🎤 Enfatizar el ciclo: ROJO → VERDE → AZUL. Nunca saltear el rojo — si el test pasa sin haber escrito el código, el test está mal.
Regla 1 a 1: un AC genera una prueba. Una prueba verifica una unidad pública. No más, no menos.
Nomenclatura: `Metodo_Escenario_ResultadoEsperado` — el nombre del test es la documentación.
En la Sesión 2 van a ver este ciclo en acción: escribimos el test que falla, luego el código mínimo, luego refactorizamos con SOLID.
-->

---
layout: center
---

# ☕ Break

## 10 minutos

<!--
🎤 Segundo break. 10 minutos. Al volver: arquitectura — la parte más visual de la sesión.
Sugerencia: durante el break, intentar recordar las 6 capas del backend de memoria.
-->

---

# Arquitectura por capas (backend)

## Las 6 capas

```
        ┌─────────────────┐
        │  Abstracciones  │  ← núcleo: modelos + interfaces
        └─────────────────┘
              ↑    ↑    ↑
         ┌────┴┐ ┌─┴──┐ ┌┴───┐
         │ BC  │ │ SG │ │ DA │
         │Reglas│ │Serv│ │Datos│
         └─────┘ └────┘ └────┘
              ↑    ↑    ↑
              ┌────┴────┐
              │   BW    │  ← Flujo (orquestador)
              └─────────┘
                   ↑
              ┌────┴────┐
              │   API   │  ← Controllers
              └─────────┘
```

<div class="regla">
📚 <strong>Regla de dependencia</strong> (Robert C. Martin): las dependencias siempre apuntan <strong>hacia adentro</strong>.
</div>

<!--
🎤 Dibujar el diagrama en el pizarrón si hay uno disponible — ayuda mucho la visualización manual.
Leer las capas de adentro hacia afuera: ABS (núcleo) → BC/SG/DA → BW → API.
Regla de dependencia de Robert C. Martin: ABS no conoce a nadie. API conoce a todos. Si API depende de BC está bien; si BC depende de DA, está MAL.
Pregunta: ¿alguien puede identificar una violación de la regla de dependencia en un proyecto propio?
-->

---

# Responsabilidades por capa

## Cada capa hace una cosa

| Capa | ✅ Sí hace | ❌ No hace |
|---|---|---|
| **ABS** | Modelos, interfaces | Implementación |
| **API** | Recibir HTTP, delegar | Lógica de negocio |
| **BW** | Orquestar el caso de uso | Reglas de negocio |
| **BC** | Reglas de negocio puras | I/O (DB, HTTP, logs) |
| **SG** | Servicios externos | Lógica de negocio |
| **DA** | Base de datos | Lógica de negocio |

<div class="actividad">
<strong>Pregunta para debate:</strong> ¿Por qué la capa BC no puede hacer I/O? ¿Qué beneficio nos da?
</div>

<!--
🎤 Respuesta esperada al debate: BC sin I/O es 100% testeable sin mocks complejos — solo lógica pura.
Si BC puede hacer I/O, los tests necesitan bases de datos reales o mocks pesados → ciclo TDD se vuelve lento.
Ejemplo: `RegistradorPostales.Registre()` no llama a la DB directamente — recibe interfaces que otros inyectan.
Destacado: la capa DA SIEMPRE está detrás de una interfaz definida en ABS — nunca se importa directamente desde BC.
-->

---

# Arquitectura del frontend

## Feature-based (SPA React + TS)

```
src/
├── core/           # config, styles, types globales
├── layouts/        # layouts globales
├── features/       # 1 carpeta = 1 dominio funcional
│   └── <feature>/  # components, hooks, services, types, views
├── shared/         # componentes y hooks reutilizables
├── router.ts
└── main.tsx
```

<div class="regla">
🎯 <strong>Regla:</strong> <em>files that change together live together</em>.
</div>

<!--
🎤 Mostrar la estructura en el IDE si es posible — que vean cómo se ve un feature real.
Regla "files that change together live together": si el componente `FormularioRegistrar` y su hook `useRegistrar` siempre cambian juntos, viven en la misma carpeta.
Contraste con arquitectura técnica (components/, hooks/, services/ globales): si cambias el feature postales tenés que tocar 5 carpetas distintas.
Pregunta: ¿cómo organizan hoy sus proyectos React? ¿Por tipo de archivo o por feature?
-->

---

# Las 11 reglas duras del frontend

<div class="grid-2">

<div>

1. Todo componente es una **función**
2. Prohibido `any` — usar `unknown`
3. Prohibido `React.FC` — props con `interface`
4. Estados async como **discriminated union**
5. Sin imports fuera de lista blanca
6. HTTP solo vía cliente estándar

</div>

<div>

7. Formularios con manejador propio
8. Grids con componente propio
9. Un componente = un archivo (≤150 líneas)
10. Nombres en español (`use`, `maneje`, `al`)
11. Cobertura mínima obligatoria

</div>

</div>

<!--
🎤 Regla más importante de las 11: estados async como discriminated union (regla 4).
Ejemplo de discriminated union: `{ status: 'idle' } | { status: 'loading' } | { status: 'success', data: T } | { status: 'error', error: string }`.
Sin esto: `isLoading`, `isError`, `data`, `error` — estados imposibles como `isLoading=true` y `data` con valor simultáneamente.
Regla 2 (prohibido `any`): Copilot tiene tendencia a generar `any` — las Instructions deben bloquearlo explícitamente.
-->

---

# SOLID + Clean Code

## Los cimientos de todo diseño

<div class="grid-2">

<div>

### SOLID
- **S**RP — una razón para cambiar
- **O**CP — abierto a extensión, cerrado a modificación
- **L**SP — implementaciones sustituibles
- **I**SP — interfaces pequeñas
- **D**IP — depender de abstracciones

</div>

<div>

### Clean Code
- Métodos ≤ 20 líneas
- Máx. 2 niveles de anidamiento
- Sin números mágicos
- Nombres descriptivos
- Comentarios explican *por qué*

</div>

</div>

<div class="regla">
📚 Robert C. Martin — <em>Clean Code</em> (2008) y <em>Clean Architecture</em> (2017).
</div>

<!--
🎤 Ejemplo de SRP: una clase `UsuarioService` que valida, persiste y envía emails viola SRP — tiene 3 razones para cambiar.
Ejemplo de DIP: `RegistradorPostales` recibe `ICatalogoDa` (interfaz) en el constructor, no `CatalogoDaPostgres` (implementación).
Clean Code regla más violada: métodos largos. Si necesitás scroll para leer un método, ya es demasiado largo.
Copilot tiende a generar métodos largos — el skill `refactor-solid` lo detecta y propone splits.
-->

---

# Trazabilidad end-to-end

## Todo se conecta

```
Historia de usuario (US-###)
        ↓
Caso de uso (UC-###) + AC (GWT)
        ↓
🔴 Prueba unitaria
        ↓
🟢 Código mínimo
        ↓
🔵 Refactor
        ↓
Commit + PR (con referencia AC-##)
        ↓
Workflows agentic reportan
        ↓
Revisión humana + Merge
```

<div class="regla">
🎯 Todo eslabón referencia al anterior. Si esa cadena se rompe, el PR se rechaza.
</div>

<!--
🎤 Leer la cadena de arriba a abajo lentamente: cada eslabón tiene una referencia al anterior.
Pregunta clave: ¿qué pasa si un commit no menciona ningún AC? → El workflow `revisar-pr` lo detecta y bloquea.
Esto es el valor real del sistema: no es burocracia — es la red de seguridad que Copilot verifica automáticamente.
Mencionar: en la Sesión 2 van a ver esta cadena completa en acción, desde US-001 hasta el merge.
-->

---

# Cierre Sesión 1 — Preguntas de reflexión

## Debate en grupo (10 min)

1. ¿Cuál de los **12 mandatos** te parece más difícil de cumplir en tu experiencia actual? ¿Por qué?

2. ¿Por qué crees que la Constitution es **inmutable**? ¿Qué pasaría si se pudiera modificar libremente?

3. ¿Qué diferencia hay entre **Prompt, Agent y Skill**? Explicalo en tus palabras.

4. ¿Cuáles son las **6 capas del backend**? ¿Cuál es la regla de dependencia?

<div class="actividad">
<strong>Preparación para la Sesión 2:</strong>
<ul>
<li>Tener GitHub Copilot activo en el editor</li>
<li>Tener .NET 8 SDK y Node.js LTS instalados</li>
<li>Descargar el repositorio del curso</li>
</ul>
</div>

<!--
🎤 Dar 10 minutos para el debate grupal — circular entre grupos y escuchar.
Pregunta 1: el mandato más difícil suele ser TDD o trazabilidad — normalizar esa dificultad.
Pregunta 2: Constitution inmutable → si se cambia libremente pierde su autoridad, igual que una constitución nacional.
Pregunta 4: las 6 capas en orden: ABS → BC/SG/DA → BW → API. La regla: dependencias siempre hacia ABS.
Recordar para la Sesión 2: GitHub Copilot activo, .NET 8 SDK y Node.js LTS instalados.
-->

---
layout: cover
---

# Sesión 2

## Manos a la obra

### Construyamos un producto real usando el sistema completo

**3 horas · Práctica end-to-end**

<!--
🎤 Bienvenida a la Sesión 2. Hoy escriben código real.
Mensaje motivador: todo lo que vieron en la Sesión 1 — Constitution, SDD, TDD, 6 capas — lo van a usar hoy.
Preguntar si todos tienen el entorno listo: Copilot activo, .NET 8, Node.js. Resolver problemas de setup antes de arrancar.
Objetivo concreto: al final de la sesión van a tener un PR mergeable con US-001 completo, backend + frontend + tests.
-->

---

# Agenda Sesión 2

| # | Actividad | Duración |
|---|---|---|
| 1 | Repaso rápido de Sesión 1 | 10 min |
| 2 | Presentación del proyecto: Álbum del Mundial | 10 min |
| 3 | Setup y estructura | 20 min |
| 4 | Historia de usuario, UC y AC | 25 min |
| 5 | Ciclo TDD backend guiado | 45 min |
| 6 | ☕ Break | 10 min |
| 7 | Ciclo TDD frontend guiado | 45 min |
| 8 | Workflows agentic en acción | 15 min |
| 9 | Cierre y retrospectiva | 10 min |

<!--
🎤 Repasar la agenda visualmente. Destacar que las actividades 3-8 son práctica continua en pares.
Aviso: el tiempo está ajustado — si el setup demora más de 20 min, arrancar con los que estén listos y los demás se incorporan.
Mencionar que el break de la actividad 6 es el único — planificarse para estar descansados hasta entonces.
-->

---

# Repaso ultrarrápido

## Lo esencial de la Sesión 1

| Concepto | Regla clave |
|---|---|
| **Constitution** | Inmutable, RFC 2119, ley suprema |
| **ADR** | Formato Nygard, decisiones documentadas |
| **SDD + TDD** | UC + AC (GWT) → Red-Green-Refactor |
| **6 capas backend** | ABS es el núcleo, dependencias hacia adentro |
| **11 reglas frontend** | Funciones + TS estricto + sin OSS externos |
| **8 elementos Copilot** | Instructions, Prompts, Agents, **Skills**, MCP, Workflows, Templates, Docs |

<!--
🎤 Hacer el repaso como quiz rápido: mostrar la columna izquierda y pedir la regla clave.
Si algún concepto genera confusión, dedicar 2 minutos a aclararlo antes de avanzar.
Énfasis: hoy van a usar SDD+TDD en la práctica — los conceptos tienen que estar claros.
No más de 5 minutos en este repaso.
-->

---

# ⚽ Álbum del Mundial

## Control de postales de la colección

<div class="grid-2">

<div>

**Dominio:** coleccionistas del álbum del mundial.

**Funcionalidad:**
- Registrar postales
- Marcar repetidas
- Consultar faltantes
- Ver estadísticas

</div>

<div>

**¿Por qué este ejemplo?**
- Dominio conocido por todos
- Reglas de negocio claras
- Cubre los 6 escenarios mínimos
- Da para 5 historias progresivas

</div>

</div>

<div class="regla">
🎯 <strong>Objetivo de hoy:</strong> implementar <strong>US-001 · Registrar una postal</strong> end-to-end.
</div>

<!--
🎤 Presentar el dominio del álbum del mundial: todos lo conocen, las reglas son claras y naturales.
Reglas de negocio importantes a mencionar: una postal tiene un número único, puede estar poseída (1 vez) o repetida (2+ veces), o faltante.
AC-05 (idempotencia) es el más interesante: si registrás la misma postal dos veces no es error — es repetida.
Este dominio está elegido pedagógicamente: da para 5 historias de usuario progresivas con distintos niveles de complejidad.
-->

---

# Fase 0 — Setup

## Preparar los 2 repositorios

### Pasos

1. Crear repo backend desde `Template.Mapi` → `AlbumMundial.Api`
2. Crear repo frontend desde `Template.Spa` → `AlbumMundial.SPA`
3. Clonar ambos
4. Verificar que `.github/`, `.specify/`, `docs/` traen todo
5. Correr `dotnet test` y `npm run test` — debe estar verde

```bash
git clone <url> AlbumMundial.Api
cd AlbumMundial.Api
dotnet restore && dotnet build && dotnet test
```

<div class="actividad">
Los estudiantes ejecutan el setup <strong>en pares</strong> (15 min).
</div>

<!--
🎤 Circular durante los 15 minutos de setup — los problemas más comunes: versión de .NET incorrecta, falta de permisos en la carpeta, variables de entorno.
Verificar que todos pasen el `dotnet test` verde ANTES de avanzar a la Fase 1.
Los templates ya traen la estructura completa de carpetas, Instructions, Prompts y Skills preconfigurados.
Si alguien tiene problemas de red para clonar, tener los repos descargados en un USB como fallback.
-->

---

# Fase 1 — Documentos previos

## Matriz de decisión por complejidad

| Nivel del cambio | Documentos requeridos |
|---|---|
| **Trivial** (bugfix) | UC + AC |
| **Estándar** (feature) | UC + AC + `spec.md` + `tasks.md` |
| **Arquitectónica** (producto nuevo) | + Visión + C4 + ADRs |

Para el proyecto necesitamos:
- **Visión** (1 página)
- **ADR-004** — Catálogo de postales como semilla

<div class="actividad">
Los equipos redactan una <strong>visión de 1 página</strong> para su proyecto (10 min).
</div>

<!--
🎤 Explicar la matriz de decisión: no todo necesita ADRs y C4 — solo los cambios que afectan la arquitectura.
US-001 es un cambio Estándar: necesita UC + AC + spec.md + tasks.md.
La Visión de 1 página es el documento "por qué existimos" — responde qué problema resolvemos, para quién, y cómo medimos el éxito.
ADR-004 (catálogo de postales como semilla) define que el catálogo viene preloaded en la DB, no se crea por API.
-->

---

# Fase 2 — Historia US-001

## Formato estándar

```markdown
---
id: US-001
title: Registrar una postal en mi colección
status: refinada
size: S
priority: alta
related_uc: [UC-001]
---

Como coleccionista
Quiero registrar una postal que acabo de conseguir
Con el fin de llevar el control preciso de mi colección
```

### Criterios INVEST

Independiente · Negociable · Valiosa · Estimable · Small · Testable

<!--
🎤 Leer la historia de usuario en voz alta: "Como coleccionista, quiero registrar una postal que acabo de conseguir..."
Verificar INVEST con el grupo: ¿es Independiente? ¿Estimable en horas? ¿Small?
El `status: refinada` es importante — solo se implementan historias refinadas. Si está en `borrador`, primero se refina.
Esta historia tiene `size: S` — en la Sesión 2 van a ver qué pasa con historias M y L (más AC, más capas).
-->

---

# Fase 3 — Generar el UC con Copilot

## Demo en vivo

```
@programador-mapi
/generar-caso-de-uso
```

### Parámetros

| Campo | Valor |
|---|---|
| nombreUC | `registrar-postal-poseida` |
| historiaUsuario | `US-001` |
| actor | `Coleccionista autenticado` |
| capacidad | `Registrar una postal por su número` |
| beneficio | `Llevar control preciso de mi álbum` |
| endpoint | `POST /api/v1/colecciones/mias/postales` |

**Salida:** `docs/use-cases/UC-001-registrar-postal-poseida.md` con 11 secciones + 6 AC.

<!--
🎤 Hacer la demo en vivo con el agente `@programador-mapi` y el Prompt `/generar-caso-de-uso`.
Mostrar cómo se completan los parámetros uno a uno en el chat de Copilot.
El agente lee la Constitution y los ADRs antes de generar — si el endpoint viola alguna regla, lo menciona.
Si la demo falla: tener el UC pre-generado en el repo como fallback para no perder tiempo.
-->

---

# Los 6 AC generados

## El contrato ejecutable

| AC | Escenario | Resultado esperado |
|---|---|---|
| AC-01 | Éxito — registro nuevo | 201 + `{estado: poseida, cantidad: 1}` |
| AC-02 | Validación — fuera de rango | 400 |
| AC-03 | Autenticación — sin token | 401 |
| AC-04 | No encontrado — fuera del catálogo | 404 |
| AC-05 | **Idempotencia — segunda inserción** | **200 + `{estado: repetida, cantidad: 2}`** |
| AC-06 | Fallo dep. externa — DB caída | 503 |

<div class="actividad">
<strong>Discusión (5 min):</strong> ¿por qué AC-05 retorna 200 y no 409?
</div>

<!--
🎤 Pregunta clave AC-05: 409 Conflict implica que la segunda inserción es un error. Pero no lo es — es el comportamiento esperado de un coleccionista que tiene dos de la misma postal.
Respuesta correcta: 200 + estado repetida = idempotencia semántica. El cliente puede llamar 2 veces y el sistema responde de forma coherente.
409 se usaría si fuera realmente un duplicado no permitido (ej: registrar el mismo usuario dos veces).
Este debate suele durar más de 5 min — tenerlo bajo control, el objetivo es el ciclo TDD.
-->

---

# Validar el UC antes de codear

## Un skill en acción

```
@programador-mapi invocá el skill validar-uc sobre docs/use-cases/UC-001-registrar-postal-poseida.md
```

### Salida esperada

- ✅ Estado por sección (11/11)
- ✅ Checklist de los 6 escenarios (6/6)
- ✅ Decisión: **Válido**

<div class="regla">
🎯 El mismo skill correrá <strong>automáticamente</strong> cuando abramos el PR (workflow agentic).
</div>

<!--
🎤 Mostrar el skill `validar-uc` en acción: invocar en el chat y leer el output.
Las 11 secciones del UC son: Identificación, Resumen, Actores, Precondiciones, Flujo principal, Flujos alternativos, 6 AC, Reglas de negocio, Consideraciones de seguridad, Dependencias, Historial.
Si el skill reporta 10/11 secciones, identificar cuál falta y completarla antes de avanzar.
Destacado: el mismo skill corre en el workflow `validar-uc` al abrir el PR — lo que ven aquí es exactamente lo que verán en la revisión automática.
-->

---

# Fase 4 — Ciclo TDD backend (AC-01)

## 🔴 RED — Prueba que falla

```
/generar-prueba-desde-ac
```

Parámetros: `ucId: UC-001`, `acId: AC-01`, `stack: backend`, `sut: RegistradorPostales.Registre`, `ubicacion: Bc`.

**Salida:** `tests/AlbumMundial.Bc.Tests/RegistradorPostalesTests.cs` con:
- Nomenclatura correcta: `Registre_ConPostalDelCatalogoYSinPoseerla_RetornaRegistroPoseida`
- Estructura AAA explícita
- Uso de `NSubstitute` para mocks

```bash
dotnet test --filter "FullyQualifiedName~Registre_ConPostal..."
# ❌ Falla (no existe la clase)
```

<!--
🎤 El test rojo es la evidencia de que el comportamiento no existe todavía — no un error, es el punto de partida.
Mostrar el test generado en el IDE: estructura AAA (Arrange-Act-Assert) explícita y bien separada.
Nomenclatura: leer `Registre_ConPostalDelCatalogoYSinPoseerla_RetornaRegistroPoseida` — el nombre del test es la especificación.
Preguntar: ¿cómo saben si el test está bien escrito antes de tener el código? → Si el nombre describe exactamente el AC-01, está bien.
-->

---

# 🟢 GREEN — Código mínimo

## Implementar sin excederse

```
/implementar-para-pasar-prueba
```

Copilot creará:
- `Abstracciones/Modelos/PostalPoseida.cs`
- `Abstracciones/Interfaces/ICatalogoDa.cs`, `IColeccionesDa.cs`
- `Bc/RegistradorPostales.cs`

```bash
dotnet test
# ✅ Verde
```

<div class="regla">
🎯 El código solo hace lo <strong>mínimo</strong>.
<br>
<strong>No adelantar</strong> implementación para futuros AC.
</div>

<!--
🎤 Mostrar el código mínimo en el IDE — debe ser lo más simple posible para pasar AC-01.
Error común: implementar más de lo que el test pide. Si el test solo verifica AC-01, el código solo hace AC-01.
Mencionar: las interfaces `ICatalogoDa` e `IColeccionesDa` viven en ABS — BC depende de abstracciones, no implementaciones.
El `dotnet test` debe estar completamente verde antes de avanzar al refactor.
-->

---

# 🔵 REFACTOR

## Aplicar SOLID sistemáticamente

```
@programador-mapi invocá el skill refactor-solid sobre src/AlbumMundial.Bc/RegistradorPostales.cs
```

### El skill hace

1. Ejecuta la suite (verde antes de empezar)
2. Aplica SRP, OCP, LSP, ISP, DIP en orden
3. Re-ejecuta la suite después de cada principio
4. Devuelve checklist antes/después

<div class="actividad">
Los estudiantes ejecutan el <strong>ciclo completo</strong> Red-Green-Refactor para AC-01 (25 min).
</div>

<!--
🎤 Mostrar el skill `refactor-solid` en acción: invocar sobre `RegistradorPostales.cs` y leer el checklist.
El skill verifica en orden SRP → OCP → LSP → ISP → DIP. Si viola SRP, lo menciona antes de verificar los demás.
Importante: el refactor NO cambia el comportamiento — si los tests fallan después del refactor, hubo un error.
Circular durante los 25 minutos: verificar que todos pasen por los 3 colores antes del break.
-->

---
layout: center
---

# ☕ Break

## 10 minutos

<!--
🎤 Break merecido — ya hicieron el ciclo TDD completo para AC-01.
Al volver: cubrir los 5 AC restantes y luego arrancar con el frontend.
Sugerencia: revisar mentalmente cuáles de los 5 AC les parece más desafiante implementar.
-->

---

# Cubrir los AC restantes

## Repetir el ciclo

| AC | Capa donde vive | Notas |
|---|---|---|
| AC-02 · Validación | `Bc` | `PostalFueraDeRangoException` + constante |
| AC-03 · Autenticación | `Api` | `[Authorize]` + test de integración |
| AC-04 · No existe | `Bc` | `catalogo.Existe()` retorna false |
| AC-05 · Idempotencia | `Bc` | Cantidad → 2, estado → repetida |
| AC-06 · Fallo dep. externa | `Bw` | Flujo mapea excepciones |

<div class="regla">
🎯 Las capas aparecen <strong>por necesidad</strong>, no por adelantado.
</div>

<!--
🎤 Énfasis: las capas BC, SG, DA no se crean todas desde el principio — aparecen cuando el AC las necesita.
AC-02 (validación): `PostalFueraDeRangoException` es una excepción de dominio — vive en BC, no en API.
AC-03 (autenticación): `[Authorize]` es un concern de API — BC no sabe nada de autenticación.
AC-06 (fallo externo): el `Bw` (flujo) captura la excepción de DA y la mapea a 503 — BC no maneja errores de infraestructura.
-->

---

# Auditar cobertura antes del PR

## El skill que evita rebotes

```
@programador-mapi invocá el skill analisis-cobertura contra UC-001
```

### Salida esperada

- ✅ Cobertura línea 94%
- ✅ Cobertura rama 88%
- ✅ Los 6 escenarios cubiertos
- ✅ Decisión: **Aprobado**

<!--
🎤 Mostrar el skill `analisis-cobertura` en acción antes de crear el PR — evita rebotes.
Cobertura de línea 94%: el 6% restante puede ser paths imposibles o código de infraestructura — aceptable.
Cobertura de rama 88%: verificar que los branches de error (catch, else) estén cubiertos.
Si la cobertura está por debajo del umbral, el skill lista los archivos con menos cobertura para priorizar.
-->

---

# Fase 6 — Frontend

## Ahora la SPA

### Pasos

1. Crear rama `feature/US-001-registrar-postal`
2. Crear estructura `src/features/postales/` con subcarpetas
3. 🔴 Test del hook con `renderHook`
4. 🟢 Generar el hook: `/generar-custom-hook` (tipo `estado-async`)
5. Generar el componente: `/generar-componente-funcional`
6. Generar la vista que compone hook + componente
7. Registrar la ruta en `router.ts`

<div class="actividad">
Los estudiantes ejecutan el flujo frontend <strong>en pares</strong> (30 min).
</div>

<!--
🎤 El ciclo TDD en frontend es igual que en backend: test del hook → implementar hook → componente → vista → ruta.
El hook usa discriminated union: `{ status: 'idle' } | { status: 'loading' } | { status: 'success', data } | { status: 'error', error }`.
`/generar-custom-hook` recibe el tipo `estado-async` y genera el hook completo con los 4 estados.
Circular durante los 30 minutos — el punto de traba más común es el `renderHook` de React Testing Library.
-->

---

# Estructura final del frontend

## El feature completo

```
src/features/postales/
├── components/
│   └── FormularioRegistrarPostal.tsx
├── hooks/
│   └── use-registrar-postal.ts     ← discriminated union
├── services/
│   └── postales.service.ts
├── types/
│   └── postal.types.ts
├── views/
│   └── VistaRegistrarPostal.tsx    ← compone hook + componente
└── routes.ts
```

<div class="regla">
🎯 <em>files that change together live together</em>.
</div>

<!--
🎤 Mostrar la estructura en el IDE — que vean cómo queda un feature completo en una sola carpeta.
Nota importante: `routes.ts` dentro del feature exporta las rutas que luego se agregan al `router.ts` global.
El `VistaRegistrarPostal.tsx` es la única vista pública — compone el hook y el componente, sin lógica propia.
Mencionar: el skill `analisis-cobertura` también corre sobre el frontend — verifica los 4 estados del hook.
-->

---

# Fase 7 — Abrir el PR

## Momento de la verdad

```bash
git push -u origin feature/US-001-registrar-postal
gh pr create --fill --base main
```

### En la descripción del PR

- Referencia `US-001` y los 6 `AC-##`
- Link al UC
- Tipo `feat`

<div class="regla">
🚀 Los 5 workflows agentic corren automáticamente en paralelo.
</div>

<!--
🎤 Mostrar el comando `gh pr create --fill` — el `--fill` usa el último commit message como título y body.
La descripción del PR debe mencionar `US-001`, los 6 `AC-##` y el link al UC.
Si no tienen `gh` instalado: crear el PR desde la UI de GitHub y completar la descripción manualmente.
Una vez creado el PR, abrir GitHub en el navegador y mostrar la pestaña Actions mientras corren los workflows.
-->

---

# Los 5 workflows en acción

## Reportes automáticos en tu PR

| Workflow | Qué reporta |
|---|---|
| `validar-uc` | UC cumple plantilla, 6 escenarios cubiertos |
| `validar-cobertura` | Cobertura vs umbral, mapeo AC ↔ Test |
| `validar-dependencias` | Paquetes contra lista blanca |
| `validar-arquitectura` | Regla de dependencia, capas correctas |
| `revisar-pr` | **Consolida** todo + adherencia a Constitution |

<div class="regla">
🎯 Todos usan <strong>Safe Outputs</strong> — comentan y sugieren, <strong>nunca aprueban ni mergean</strong>.
</div>

<!--
🎤 Mostrar los 5 workflows corriendo en paralelo en la pestaña Actions de GitHub.
Safe Outputs es un principio de seguridad: los agentes automáticos nunca toman decisiones irreversibles.
Si `validar-dependencias` falla: hubo un paquete nuevo no autorizado — revisar el ADR de catálogo blanco.
Si `validar-arquitectura` falla: hay una importación que viola la regla de dependencia — el workflow muestra el archivo y la línea exacta.
-->

---

# Ejemplo del reporte consolidado

## Lo que ves en tu PR

```
🔍 Reporte consolidado · Revisar PR

Decisión sugerida: Aprobar ✅

| Dimensión       | Estado |
|-----------------|--------|
| Trazabilidad    | ✅     |
| UC              | ✅     |
| Cobertura       | ✅ 94% |
| Dependencias    | ✅     |
| Arquitectura    | ✅     |
| SOLID/CleanCode | ✅     |
| Seguridad       | ✅     |
| Commits         | ✅     |
| CI              | ✅     |
```

<!--
🎤 Leer el reporte consolidado como si fuera un revisor humano — dimension por dimension.
Destacado: la decisión es una SUGERENCIA — el revisor humano tiene la última palabra.
Si todas las dimensiones son ✅, el tiempo de revisión humana se reduce de 45 min a 10 min.
Pregunta al grupo: ¿qué dimensión les parece más valiosa de las 9? Probable respuesta: trazabilidad o cobertura.
-->

---

# ¿Qué pasaría si el PR estuviera mal?

## Ejemplo de PR bloqueado

```
Decisión sugerida: Bloquear ❌

Observaciones críticas:

- src/AlbumMundial.Bc/RegistradorPostales.cs:42
  → DateTime.Now directo en Bc (violación §3.6 Bc puro).
  Recomendación: inyectar IReloj.

- package.json introduce `axios@1.6.0`
  → prohibido por ADR-002. Usar fetch nativo.

- Sin referencia a US-### ni AC-## en la descripción del PR.
```

<div class="regla">
🎯 Los workflows <strong>explican</strong> por qué rechazan y <strong>sugieren</strong> la corrección.
</div>

<!--
🎤 Leer las observaciones críticas como las vería el desarrollador — son accionables y referencian §.
`DateTime.Now` en BC viola §3.6 porque hace el código no determinístico para tests — inyectar `IReloj` lo resuelve.
`axios` viola ADR-002 porque el catálogo blanco solo permite `fetch` nativo para evitar dependencias innecesarias.
Destacado: el workflow no dice "está mal" — dice exactamente QUÉ está mal, EN QUÉ LÍNEA y CÓMO corregirlo.
-->

---

# Revisión humana + Merge

## El cierre del ciclo

1. Un compañero revisa el PR usando el **reporte consolidado**
2. Complementa con su **criterio humano**
3. Aprueba (o solicita cambios)
4. Merge a `main`
5. Se cierra el issue automáticamente

<div class="regla">
🎯 Los workflows <strong>aceleran</strong> la revisión, no la reemplazan.
</div>

<!--
🎤 Enfatizar el punto central: la revisión humana sigue siendo necesaria — los workflows no reemplazan el criterio.
El revisor humano aporta: contexto de negocio, trade-offs no capturados por las reglas, legibilidad para futuros mantenedores.
El issue se cierra automáticamente gracias al `Closes #US-001` en la descripción del PR (si está configurado).
Pregunta: ¿cuánto tiempo les tomó la revisión del PR con el reporte consolidado vs sin él?
-->

---

# Lo que acabamos de lograr

## Un producto real con límites

<div class="grid-2">

<div>

- ✅ Historia documentada
- ✅ UC con 6 AC en formato GWT
- ✅ 6 pruebas 1 a 1 con AC
- ✅ Backend en 6 capas con SOLID
- ✅ Frontend con 11 reglas duras

</div>

<div>

- ✅ Cobertura >90%
- ✅ Cero dependencias fuera del catálogo
- ✅ PR con trazabilidad completa
- ✅ Reportes automáticos verificando todo
- ✅ Merge limpio

</div>

</div>

<div class="regla">
💡 En una industria normal, un producto así tomaría <strong>semanas</strong>.
<br>
Acá lo hicimos en <strong>una sesión</strong> porque tenemos los límites.
</div>

<!--
🎤 Tomarse 2 minutos para celebrar con el grupo — escribieron código de producción real con trazabilidad completa.
Contar los artefactos producidos: 1 UC, 6 AC, 6+ tests, código en 3 capas, 1 feature frontend, 1 PR con reporte.
Mensaje clave: el sistema no frena la velocidad — la hace sostenible. La primera vez es lenta; la décima es automática.
Invitar a aplicar esto en sus proyectos reales — empezando por las Instructions y un UC bien formado.
-->

---

# Retrospectiva de las 2 sesiones

## Formato 3P + 1R (10 min)

<div class="grid-2">

<div class="fase green">
<strong>💪 Positivos</strong>
<br>
¿Qué del sistema les pareció más útil?
</div>

<div class="fase" style="border-left-color: #F59E0B">
<strong>⚠️ Preocupaciones</strong>
<br>
¿Qué les generó duda o resistencia?
</div>

<div class="fase blue">
<strong>💡 Propuestas</strong>
<br>
¿Qué mejorarían?
</div>

<div class="fase red">
<strong>🚧 Riesgos</strong>
<br>
¿Qué haría fracasar este enfoque en un equipo real?
</div>

</div>

<!--
🎤 Dar 10 minutos para la retro en grupos de 4. Formato 3P+1R: cada grupo completa los 4 cuadrantes.
Circular y escuchar — las preocupaciones más comunes: "lleva mucho tiempo", "el equipo no va a adoptar esto", "no tenemos ADRs".
Respuesta a "lleva mucho tiempo": la primera vez sí, la décima vez los Prompts y Skills lo hacen en segundos.
Riesgos reales: rotación del equipo que no conoce la Constitution, presión de plazos que lleva a saltear specs.
-->

---

# Ejercicios propuestos para casa

## Sigue construyendo

### Obligatorios
- **US-002** · Marcar postal como repetida para intercambio
- **US-003** · Consultar postales faltantes (vista con grid)

### Bonus
- **US-004** · Ver estadísticas de progreso (dashboard)

### Avanzados (opcional)
- **Skill propio** — Detectar un procedimiento repetible y proponerlo con las 9 secciones obligatorias
- **ADR propio** — Redactar sobre una decisión estructural de tu proyecto personal

<div class="regla">
📤 <strong>Entrega:</strong> por Pull Request al repo del curso.
</div>

<!--
🎤 Dar las instrucciones de entrega claramente: PR al repo del curso, descripción con US-### y AC-##.
US-002 (postal repetida) y US-003 (faltantes) son las dos obligatorias — son la consolidación del ciclo TDD.
US-004 (estadísticas) es Bonus — para los que quieran explorar el frontend con datos agregados.
El Skill y ADR propios (avanzados) son los ejercicios más valiosos: obligan a reflexionar sobre su propio proceso.
-->

---

# Bibliografía esencial

## Para seguir profundizando

### 📚 Libros clásicos
- Robert C. Martin — *Clean Code* (2008)
- Robert C. Martin — *Clean Architecture* (2017)
- Kent Beck — *Test-Driven Development* (2002)
- Martin Fowler — *Refactoring* (2018)
- Hunt & Thomas — *The Pragmatic Programmer* (2019)
- Eric Evans — *Domain-Driven Design* (2003)

### 📄 Artículos fundacionales
- Michael Nygard — *Documenting Architecture Decisions* (2011)
- Simon Brown — *The C4 Model*
- Dan North — *Introducing BDD*

<!--
🎤 Recomendar para empezar: Clean Code (Robert C. Martin) + TDD by Example (Kent Beck) — son los más accesibles.
Clean Architecture es más denso — leerlo después de tener experiencia con TDD y SOLID.
Dan North — Introducing BDD: artículo corto y gratuito online, lectura de 20 minutos muy recomendada.
Mencionar que el repo del curso tiene links a los artículos fundacionales en el README.
-->

---
layout: cover
---

# Cierre

### "La IA generativa no reemplaza al ingeniero de software.
### Multiplica al que sabe pensar en principios."

<br>

## Los 3 aprendizajes clave

1. **Especificá antes de codear**
2. **Pruebas primero**
3. **Gobernanza sobre velocidad**

<br>

**¡Gracias! Preguntas finales.**

<!--
🎤 Leer la cita en voz alta — pausa dramática después de cada línea.
Los 3 aprendizajes: repetirlos juntos con el grupo como cierre.
Abrir para preguntas — las más frecuentes: ¿cómo convencer al equipo? ¿por dónde empiezo mañana? ¿hay un template del repositorio disponible?
Mensaje final: no hay que implementar todo el sistema desde el día 1 — empezar por Instructions + un UC bien formado, el resto viene solo.
-->

