---
agent: true
description: Fase RED del ciclo TDD. Genera la prueba unitaria que falla desde un criterio de aceptación (AC) en formato GWT, siguiendo nomenclatura y estructura AAA.
tools: [codebase, editFiles]
owner: Por definir
version: 0.1
status: activo
scope: transversal
governs_by: constitution.md §2.2, §2.6, ADR-002
---

# Prompt · Generar prueba desde AC (fase 🔴 RED)

## Objetivo
Crear una prueba unitaria **que falla** derivada directamente de un criterio de aceptación, respetando la relación 1 a 1 y la nomenclatura del taller.

## Entradas
- **Caso de uso:** `${input:ucId:ID del UC, ej. UC-001}`
- **Criterio de aceptación:** `${input:acId:ID del AC, ej. AC-01}`
- **Stack objetivo:** `${input:stack:backend|frontend}`
- **Unidad bajo prueba (SUT):** `${input:sut:Método, clase, componente o hook a probar}`
- **Capa (backend) o feature (frontend):** `${input:ubicacion:Ej. Reglas, Flujo, Api o features/titulares}`

## Contexto obligatorio a considerar
- El archivo `docs/use-cases/${input:ucId}*.md` — leé el AC `${input:acId}` textualmente.
- Constitution §2.2 (ciclo Red-Green-Refactor), §2.3 (relación 1 a 1), §2.6 (nomenclatura de pruebas).
- Estructura de proyectos de pruebas existente en `tests/`.
- Convenciones de nomenclatura en `academia/docs/constitution.md` §5.

## Instrucciones para Copilot

1. **Localizá y leé** el UC `${input:ucId}` para extraer el contexto completo del AC `${input:acId}`: `Dado`, `Cuando`, `Entonces`.

2. **Determiná la ubicación del archivo de prueba** según el stack:
   - **Backend:** `tests/Producto.${input:ubicacion}.Tests/<NombreSut>Tests.cs`.
   - **Frontend:** `tests/features/<feature>/<nombreSut>.test.ts` o `.test.tsx`.

3. **Generá una prueba que fracase** (la implementación aún no existe):
   - **Nombre del test (Constitution §2.6):** `Metodo_Escenario_ResultadoEsperado`.
   - **Estructura AAA explícita** con comentarios `// Arrange`, `// Act`, `// Assert`.
   - **Referencia al AC en el comentario superior** del test: `// AC-##: <título del escenario>`.
   - **Un test = una aserción lógica** (puede tener varias `.Should()`/`expect()` sobre el mismo resultado).

4. **Backend (C# + xUnit + FluentAssertions + NSubstitute):**
   - Marcar el test con `[Fact]` o `[Theory]` según corresponda.
   - Usar `Substitute.For<I...>()` para dependencias.
   - Nombres en español.
   - Aserciones con FluentAssertions (`.Should().Be(...)`, `.Should().Throw<...>()`).

5. **Frontend (Vitest + @testing-library/react):**
   - Usar `describe` + `it` con nombres en español descriptivos.
   - Para hooks: `renderHook` de `@testing-library/react`.
   - Para componentes: `render` + `screen` + `userEvent`.
   - Modelar estados asíncronos como discriminated union (Constitution §4.5).

6. **Verificar** que el test compila pero **falla** al ejecutarse (la implementación aún no existe).

7. **No implementar** la unidad bajo prueba — eso es responsabilidad del prompt `implementar-para-pasar-prueba`.

## Reglas duras
- **Un solo AC por invocación.** Para cubrir más AC, invocar el prompt de nuevo.
- **Nada de placeholders:** todos los valores de arrange/act/assert deben ser concretos.
- **Nombres en español** siguiendo Constitution §5.
- **Sin `Thread.Sleep`, sin `await new Promise(setTimeout)`** para sincronización.
- **Sin `[Ignore]` / `it.skip`.**
- **Prohibido `--passWithNoTests`** — el test debe existir y ejecutarse.

## Salida esperada
- Archivo de prueba nuevo (o método nuevo en archivo existente) que:
  - Compila.
  - Falla al ejecutarse.
  - Referencia claramente el AC en su comentario.
- Mensaje final en el chat con el comando para ejecutar la prueba y confirmar que efectivamente falla.

## Referencias
- `academia/docs/constitution.md` §2.2, §2.3, §2.6
- `academia/docs/adr/ADR-002-sdd-tdd.md`
- `.github/instructions/tests.instructions.md`