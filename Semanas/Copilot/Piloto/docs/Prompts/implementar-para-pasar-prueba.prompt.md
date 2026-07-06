---
mode: agent
description: Fase GREEN del ciclo TDD. Genera el código mínimo que hace pasar una prueba unitaria previamente escrita (fase RED), respetando la arquitectura por capas y SOLID.
tools: [codebase, editFiles, runCommands]
owner: Por definir
version: 0.1
status: activo
scope: transversal
governs_by: constitution.md §2.2, §3, §4, §6, §7, ADR-002
---

# Prompt · Implementar para pasar la prueba (fase 🟢 GREEN)

## Objetivo
Escribir el **código mínimo necesario** para que una prueba unitaria que actualmente falla pase, sin agregar funcionalidad no cubierta por la prueba (YAGNI).

## Entradas
- **Archivo de prueba objetivo:** `${input:archivoPrueba:Ruta relativa al archivo de test, ej. tests/Producto.Bc.Tests/ConsultorTitularesTests.cs}`
- **Nombre del test específico:** `${input:nombreTest:Nombre del método/it que debe pasar}`
- **Stack:** `${input:stack:backend|frontend}`
- **Capa destino (backend) o ubicación (frontend):** `${input:ubicacion:Ej. Bc, Bw, Api, features/titulares}`

## Contexto obligatorio a considerar
- Constitution §2.2 (Red-Green-Refactor), §3 (arquitectura backend), §4 (arquitectura frontend), §6 (SOLID), §7 (Clean Code).
- Copilot instructions del stack correspondiente (`.github/copilot-instructions.md`).
- Instructions path-specific (`.github/instructions/*-layer.instructions.md`).
- Código existente en la capa destino para reutilizar patrones y evitar duplicación.

## Instrucciones para Copilot

1. **Leé el archivo de prueba** `${input:archivoPrueba}` para entender:
   - La unidad bajo prueba (SUT) y su firma esperada.
   - Las dependencias que se están sustituyendo (mocks / substitutes).
   - El resultado observable que la prueba espera.
   - El AC que la prueba referencia en su comentario.

2. **Determiná qué capa y qué archivo** hay que crear o modificar:
   - **Backend:**
     - Si la SUT es una regla de negocio → `src/Producto.Bc/`.
     - Si es un flujo/orquestador → `src/Producto.Bw/`.
     - Si es un controller → `src/Producto.Api/Controllers/`.
     - Si es un adaptador a servicio externo → `src/Producto.Sg/`.
     - Si es acceso a datos → `src/Producto.Da/`.
     - Las interfaces y DTOs correspondientes van en `src/Producto.Abstracciones/`.
   - **Frontend:** en el feature correspondiente (`src/features/<feature>/hooks/`, `services/`, `components/`, etc.).

3. **Escribí solo el código necesario** para que el test pase:
   - **No agregues** métodos, propiedades o casos que la prueba no cubre.
   - **No optimices prematuramente** — el refactor es una fase separada.
   - **Sí crea** las interfaces necesarias en `Abstracciones` (backend) para respetar el DIP.

4. **Respetá la arquitectura por capas** (Constitution §3):
   - `BC` no hace I/O.
   - `Api` no contiene lógica de negocio (solo delega).
   - `DA` no contiene lógica de negocio.
   - Todas las dependencias apuntan a `Abstracciones`.

5. **Respetá SOLID** (Constitution §6):
   - Inyectar dependencias por constructor.
   - Depender de interfaces, no de concreciones.
   - Interfaces pequeñas y cohesivas.

6. **Frontend específico** (Constitution §4):
   - Todo componente es función; sin `class`.
   - Sin `any`; usar `unknown` + estrechamiento.
   - Props con `interface` en la firma.
   - Estados asíncronos como discriminated union de 4 casos.
   - HTTP vía el useRecurso (custom hook del proyecto).

7. **Ejecutá la suite de pruebas** del proyecto/paquete afectado y **confirmá que el test pasa**:
   - Backend: `dotnet test <proyecto>`.
   - Frontend: `npm run test -- <archivo>`.

8. **Mostrá al final:**
   - Los archivos creados / modificados.
   - El resultado de la ejecución del test (verde ✅).
   - Sugerencias de refactor pendientes para la fase 🔵 (SRP, extracción de método, nombres mejorables).

## Reglas duras
- **No modificar la prueba** para que pase — la prueba es la especificación.
- **No agregar comentarios "TODO"** o código muerto.
- **Nombres en español** conforme Constitution §5.
- **Sin números mágicos:** extraer a constantes con nombre.
- **Métodos ≤ 20 líneas** — si excede, refactorizar antes de completar.
- **Sin dependencias fuera del catálogo de librerías justificadas.**
- **Prohibido** usar `any` (frontend) o `object` sin justificación (backend).

## Salida esperada
- Código productivo mínimo en la capa correcta.
- Interfaces / DTOs actualizados en `Abstracciones` si aplica.
- Confirmación de que la prueba pasa.
- Lista de sugerencias de refactor para la fase siguiente.

## Referencias
- `academia/docs/constitution.md` §2.2, §3, §4, §6, §7
- `academia/docs/adr/ADR-002-sdd-tdd.md`
- `.github/copilot-instructions.md`
- `.github/instructions/*-layer.instructions.md`