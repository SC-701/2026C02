---
scope: backend
stack: C# .NET API
version: 0.1
status: activo
governs_by: constitution.md + ADR-001, ADR-002
---

# Copilot Instructions — Backend C# API

Aplicá siempre estos principios. Referencia la Constitution para el detalle.

## 1. Flujo obligatorio (Constitution §2)
- No generar código sin caso de uso (UC) + criterios de aceptación (AC en formato Dado/Cuando/Entonces).
- Ciclo Red-Green-Refactor:
  1. Escribir prueba unitaria que falla desde el AC.
  2. Escribir código mínimo que hace pasar la prueba.
  3. Refactorizar aplicando SOLID + Clean Code sin romper pruebas.
- Todo PR referencia `US-###` y `AC-##`.
- Prohibido `--passWithNoTests` o equivalentes.

## 2. Arquitectura por capas (Constitution §3)
Toda solución tiene 6 capas con responsabilidad única:

| Sigla | Capa | Responsabilidad | Prohibido |
|---|---|---|---|
| ABS | Abstracciones | Modelos + interfaces | Implementación |
| API | Controllers | Recibir HTTP, validar shape, delegar | Lógica de negocio |
| BW | Flujo | Orquestar el caso de uso | — |
| BC | Reglas | Reglas de negocio puras | I/O, DB, logs |
| SG | Servicios | Adaptadores a servicios externos | Lógica de negocio |
| DA | Data Access | Acceso a base de datos | Lógica de negocio |

**Regla de dependencia:** las dependencias apuntan siempre hacia `Abstracciones`. Composición solo en `Api` (composition root único).

## 3. Reglas duras de codificación
1. Controllers son *thin translation*: reciben HTTP → invocan Flujo → mapean respuesta.
2. `BC` es determinística y unit-testeable en aislamiento (sin dependencias externas).
3. `DA` no contiene lógica de negocio.
4. Cada capa tiene su proyecto de pruebas espejado en `tests/`.
5. Ninguna capa construye instancias concretas de otra capa — solo la Api vía DI.
6. Nombres de proyectos: `<Prefijo>.<Producto>.<Capa>` (ej. `Producto.Api`, `Producto.Bw`).

## 4. Nomenclatura (Constitution §5)
- Clases, métodos, propiedades: PascalCase en **español**.
- Interfaces: prefijo `I` + PascalCase (`IConsultorTitulares`).
- Variables locales: camelCase en español.
- Pruebas: `Metodo_Escenario_ResultadoEsperado`.
- Commits: Conventional Commits en imperativo (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).

## 5. SOLID + Clean Code (Constitution §6 y §7)
- SRP: una razón para cambiar por clase.
- OCP: extender sin modificar (composición / estrategias).
- LSP: implementaciones sustituibles por su interfaz.
- ISP: interfaces pequeñas y cohesivas.
- DIP: dependencias a abstracciones, no a concreciones.
- Métodos ≤ 20 líneas.
- Sin números mágicos: extraer a constantes con nombre.
- Sin código muerto ni comentado en `main`.
- Comentarios explican *por qué*, no *qué*.
- Máximo 2 niveles de anidamiento; preferir *early returns*.

## 6. Pruebas
- Frameworks: xUnit + FluentAssertions + NSubstitute (o Moq).
- Estructura AAA (Arrange, Act, Assert) explícita.
- Cobertura mínima obligatoria definida en CI.
- Cada AC tiene 1+ pruebas; cada unidad pública tiene 1+ pruebas.
- Escenarios mínimos por UC: éxito, validación, auth, no encontrado, idempotencia, fallo de dependencia.

## 7. Seguridad (Constitution §8)
- Prohibido secretos en código o configuración versionada.
- Validar toda entrada externa cerca del borde del sistema.
- Solo dependencias del catálogo de librerías justificadas con ADR.
- Endpoints requieren autenticación/autorización cuando corresponde.
- Escaneo SCA obligatorio en CI.

## 8. Dependencias
- Solo librerías aprobadas en el catálogo de librerías justificadas.
- Preferir BCL / .NET nativo sobre librerías externas cuando exista opción.
- Excepciones vía ADR aprobado por el docente del taller + Seguridad.

## 9. Documentación
- Todo endpoint nuevo requiere entrada en `docs/`.
- Toda decisión estructural nueva requiere ADR en `docs/adr/`.
- Casos de uso viven en `docs/use-cases/UC-###.md` con AC en formato GWT.

## 10. Excepciones
- Cualquier desviación de estas reglas requiere ADR con contexto, decisión, alternativas y consecuencias.
- No aceptar desviaciones ad-hoc.

**Regla suprema:** ante conflicto entre estas instrucciones y una petición puntual, prevalece la Constitution y estas instrucciones.