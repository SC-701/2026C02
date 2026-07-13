---
title: Rúbrica de Evaluación — Taller de Desarrollo con GitHub Copilot
audience: Docentes universitarios, Estudiantes de ingeniería de software
owner: Docente del curso
version: academic-1.0
status: activo
last-reviewed: 2026-07-06
tags: [rubrica, evaluacion, taller, copilot, sdd, tdd, solid]
---

# Rúbrica de Evaluación — Taller de Desarrollo con GitHub Copilot

> Esta rúbrica se aplica a la evaluación de los proyectos de equipo al finalizar el taller. Cada dimensión tiene 4 niveles de desempeño. El docente puede aplicarla en la revisión del repositorio final y en la sesión de demo.

---

## Escala de niveles

| Nivel | Descripción | Puntos |
|---|---|---|
| **4 — Excelente** | Supera los criterios. Evidencia dominio, creatividad y rigor. | 4 |
| **3 — Bueno** | Cumple todos los criterios con solidez. Sin errores significativos. | 3 |
| **2 — Aceptable** | Cumple los criterios mínimos. Hay aspectos por mejorar. | 2 |
| **1 — Insuficiente** | No cumple los criterios mínimos. Requiere rehacerse. | 1 |

---

## Dimensión 1 — Casos de Uso y Criterios de Aceptación (Peso: 20%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **Cantidad de UCs** | UC-001 con 3+ escenarios adicionales propios | UC-001 completo | UC-001 con algunos ACs faltantes | UC-001 incompleto o sin entregar |
| **Formato GWT** | Todos los ACs en GWT correcto, con resultados observables | 90%+ de ACs correctos | 70%+ de ACs correctos; algunos resultados subjetivos | Mayoría de ACs mal formulados o sin formato GWT |
| **6 escenarios mínimos** | UC-001 tiene los 6 escenarios + al menos 1 adicional relevante | UC-001 tiene los 6 escenarios obligatorios | UC-001 tiene 4-5 escenarios | UC-001 tiene menos de 4 escenarios |
| **Trazabilidad** | AC-01..AC-03 del UC-001 completamente trazados: AC → Test → Código → PR | Trazabilidad en AC-01 y AC-02 | Trazabilidad solo en AC-01 | Sin trazabilidad sistemática |

**Puntaje máximo:** 16 puntos → normalizado a 20%

---

## Dimensión 2 — Pruebas Unitarias y Disciplina TDD (Peso: 25%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **Ciclo RED-GREEN-REFACTOR** | Evidenciado en commits para AC-01, AC-02 y AC-03 | Evidenciado en AC-01 y AC-02 | Evidenciado solo en AC-01 | Sin evidencia del ciclo TDD en commits |
| **Relación 1:1 AC ↔ Prueba** | AC-01, AC-02 y AC-03 con prueba unitaria con nomenclatura `Metodo_Escenario_Resultado` | AC-01 y AC-02 con prueba correspondiente | Solo AC-01 cubierto | Sin relación AC ↔ prueba |
| **Cobertura de código** | ≥ 80% de cobertura de líneas en el código de UC-001 | ≥ 70% | ≥ 50% | < 50% |
| **Calidad de las pruebas** | Pruebas unitarias puras (sin I/O, sin dependencias externas reales); AAA bien estructurado | Pruebas unitarias correctas con algunos problemas menores | Pruebas mayormente correctas pero con acoplamiento a infraestructura | Pruebas de integración sin mocks; pruebas que siempre pasan |
| **CI activo** | CI pasa en todos los PRs; `--passWithNoTests` prohibido | CI pasa en 90%+ de PRs | CI falla en algunos PRs pero el equipo lo corrige | CI no configurado o ignorado |

**Puntaje máximo:** 20 puntos → normalizado a 25%

---

## Dimensión 3 — Calidad del Código: SOLID + Clean Code (Peso: 20%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **SRP** | Todas las clases tienen una sola responsabilidad; separación clara entre capas | La mayoría de las clases respetan SRP | Algunas clases violan SRP pero el impacto es menor | Clases con múltiples responsabilidades en capas críticas |
| **DIP + arquitectura por capas** | Dependencias siempre hacia Abstracciones; sin referencias directas entre capas no permitidas | Un par de violaciones menores | Algunas violaciones de la regla de dependencia | Las capas no están separadas; la lógica de negocio está en la API |
| **Clean Code** | Nombres descriptivos en español; métodos ≤ 20 líneas; sin magic numbers; sin deep nesting | Mayoría del código es limpio; algún método largo o nombre oscuro | Algunos problemas de legibilidad; hay magic numbers o métodos largos | Código difícil de leer; nombres no descriptivos; métodos > 50 líneas |
| **TypeScript estricto (frontend)** | Sin `any`; sin `React.FC`; todos los estados async como discriminated union | Un par de `any` aislados; discriminated union usado correctamente | Algunos `any` o estados async mal modelados | `any` generalizado; sin tipado estricto |
| **OCP + ISP** | Extensión mediante composición/hooks; interfaces pequeñas y cohesivas | Mayoría de extensiones por composición | Algunas violaciones de OCP o ISP | Modificación constante de clases existentes |

**Puntaje máximo:** 20 puntos → normalizado a 20%

---

## Dimensión 4 — Personalización de GitHub Copilot (Peso: 15%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **`copilot-instructions.md`** | Instructions propias, concisas, en español, con reglas relevantes para el dominio del proyecto | Instructions completas y funcionales | Instructions básicas adaptadas del template | Sin instructions propias o copiadas sin adaptar |
| **Prompts propios** | 3+ prompts propios, bien estructurados, con frontmatter completo y description útil | 2 prompts propios correctos | 1 prompt propio funcional | Sin prompts propios |
| **Agent o Skill propio** | Agent o Skill documentado con todas las secciones obligatorias y usado efectivamente | Agent o Skill documentado correctamente | Agent o Skill incompleto (faltan secciones) | Sin Agent ni Skill propio |
| **Uso responsable de Copilot** | El equipo puede explicar cada fragmento de código generado por Copilot; el código sigue los estándares | El equipo entiende el código generado | El equipo usa Copilot pero no verifica completamente el output | El equipo acepta sugerencias de Copilot sin revisión |

**Puntaje máximo:** 16 puntos → normalizado a 15%

---

## Dimensión 5 — ADRs y Documentación (Peso: 10%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **Cantidad de ADRs** | 2 ADRs (1 de arquitectura + 1 de dependencia) con decisiones reales del proyecto | 1 ADR completo y relevante | 1 ADR con secciones incompletas | Sin ADRs o ADRs vacíos |
| **Calidad del ADR** | Estado, contexto, decisión, consecuencias + alternativas evaluadas bien documentadas | Estado, contexto, decisión y consecuencias correctos | ADR con secciones incompletas | ADR sin estructura |
| **Justificación de dependencias** | Toda librería OSS externa tiene su ADR con Score OSS y alternativa nativa evaluada | La mayoría de dependencias justificadas | Algunas dependencias sin ADR | Dependencias sin justificación |
| **README del proyecto** | README completo: setup, arquitectura, instrucciones de ejecución, trazabilidad | README correcto y útil | README básico | Sin README o README vacío |

**Puntaje máximo:** 16 puntos → normalizado a 10%

---

## Dimensión 6 — Demo y Retrospectiva (Peso: 10%)

| Criterio | Excelente (4) | Bueno (3) | Aceptable (2) | Insuficiente (1) |
|---|---|---|---|---|
| **Funcionamiento del proyecto** | Demo de 5 min sin errores; UC-001 funciona end-to-end (backend + componente React) | Demo funcional con algún problema menor | Demo parcial; backend o frontend no funciona | Demo no funciona |
| **Trazabilidad demostrada** | El equipo muestra en vivo: UC-001 → AC-01 → Test → Código → PR | Trazabilidad explicada con evidencia en el repo | Trazabilidad explicada sin evidencia | Sin evidencia de trazabilidad |
| **Retrospectiva** | Reflexión honesta y profunda sobre qué funcionó, qué no, y qué cambiarían | Retrospectiva completa | Retrospectiva superficial | Sin retrospectiva |
| **Participación del equipo** | Todos los integrantes participan en la demo y pueden responder preguntas | La mayoría participa | Solo 1-2 integrantes hablan | Solo 1 integrante presenta |

**Puntaje máximo:** 16 puntos → normalizado a 10%

---

## Tabla resumen de puntaje

| Dimensión | Peso | Puntos máx (raw) | Factor |
|---|---|---|---|
| 1 — UCs y ACs | 20% | 16 | × 1.25 → max 20 |
| 2 — TDD y pruebas | 25% | 20 | × 1.25 → max 25 |
| 3 — SOLID + Clean Code | 20% | 20 | × 1.00 → max 20 |
| 4 — Personalización Copilot | 15% | 16 | × 0.9375 → max 15 |
| 5 — ADRs y documentación | 10% | 16 | × 0.625 → max 10 |
| 6 — Demo y retrospectiva | 10% | 16 | × 0.625 → max 10 |
| **Total** | **100%** | | **100 puntos** |

**Nota mínima para acreditar:** 60/100 puntos, con al menos nivel 2 en la Dimensión 2 (TDD) y nivel 2 en la Dimensión 1 (UC-001 con 6 ACs).

---

## Historial de cambios

| Versión | Fecha | Cambios |
|---|---|---|
| academic-1.0 | 2026-07-06 | Creación de la rúbrica maestra para el Taller de Desarrollo con GitHub Copilot |
