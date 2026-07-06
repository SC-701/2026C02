---
adr_id: ADR-002
title: Adopción de Spec-Driven Development y Test-Driven Development como práctica obligatoria
status: propuesto
date: 2026-07-06
authors: [Por definir]
reviewers: [Por definir]
tags: [proceso, backend, testing, arquitectura, calidad]
supersedes: []
superseded_by: []
---

# ADR-002 · Adopción de SDD + TDD como práctica obligatoria

## 1. Estado

`propuesto` — pendiente de aprobación en la sesión de inicio del taller.

---

## 2. Contexto

La adopción de GitHub Copilot como asistente de desarrollo introduce el riesgo de "vibe-coding": generación de código sin especificación previa ni pruebas que lo respalden, dando lugar a soluciones difíciles de validar, mantener y auditar.

Al mismo tiempo, la práctica histórica de escribir pruebas *después* del código (o no escribirlas) ha derivado en:

- Baja cobertura efectiva.
- Casos borde no cubiertos.
- Pruebas acopladas a la implementación (no al comportamiento).
- Dificultad para evolucionar el sistema sin regresiones.

Se requiere un flujo del taller que **transforme cada requisito en una especificación ejecutable** y **cada criterio de aceptación en una prueba** antes de que exista una sola línea de código productivo.

Esto es especialmente crítico en un contexto donde la IA generativa puede producir código a gran velocidad: sin pruebas por delante, la velocidad se convierte en deuda técnica.

---

## 3. Decisión

Se adopta el flujo **Spec-Driven Development (SDD) + Test-Driven Development (TDD)** como **práctica obligatoria** para todo desarrollo de nuevas funcionalidades y refactors en los proyectos del taller.

### 3.1 Detalle de la decisión

**Flujo obligatorio:**

```
Historia de usuario (US)
       ↓
Caso de uso (UC) + Criterios de aceptación (AC en formato GWT)
       ↓
🔴 RED    → Prueba unitaria que falla (derivada del AC)
       ↓
🟢 GREEN  → Código mínimo que hace pasar la prueba
       ↓
🔵 REFACTOR → Aplicar SOLID + Clean Code sin romper pruebas
       ↓
Commit + PR (con referencia AC-##)
```

**Reglas obligatorias:**

1. **No hay código sin AC** que lo motive.
2. **No hay código sin prueba** que lo respalde (previa o al menos en el mismo commit del ciclo Red-Green).
3. **Relación 1 a 1**:
   - 1 AC → 1+ pruebas unitarias (1:N)
   - 1 prueba → 1 unidad pública de código (1:1)
   - 1 unidad → 1+ pruebas (1:N)
4. **Nomenclatura de pruebas:** `Metodo_Escenario_ResultadoEsperado`.
5. **Trazabilidad en el commit/PR:** debe referenciar el AC (`AC-01`, `AC-02`, …) del UC correspondiente.
6. **Escenarios mínimos por UC:** éxito, validación de entrada, autenticación/autorización, no encontrado/vacío, duplicidad/idempotencia, fallo de dependencia externa.
7. **Cobertura:** el proyecto debe tener cobertura mínima definida en CI y **prohibido `--passWithNoTests`** o equivalentes.
8. **Documentos previos según complejidad:**
   - Trivial (bugfix) → UC + AC.
   - Estándar (feature) → UC + AC + `spec.md` + `tasks.md`.
   - Arquitectónica → + Visión + Arquitectura C4 + ADRs + Constitution.

### 3.2 Alcance

- **Aplica a:** todo desarrollo nuevo (features, endpoints, componentes) y refactors sustantivos en los proyectos del taller.
- **No aplica a:** cambios cosméticos (formato, comentarios, renombres puros) — que igualmente deben cumplir revisiones estándar.

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| **A. Escribir pruebas después del código** | Práctica histórica | Menor fricción inicial | Cobertura efectiva baja · pruebas acopladas a implementación · casos borde no cubiertos | No resuelve el problema central |
| **B. Solo TDD, sin SDD** | Pruebas primero pero sin UC formal | Ciclo Red-Green preservado | Sin especificación, cada dev interpreta el requisito de forma distinta | Insuficiente en contexto de IA generativa |
| **C. SDD + TDD** ✅ | Especificación como contrato → pruebas → código | Trazabilidad end-to-end · gobierno claro · Copilot con contexto rico | Curva de aprendizaje · disciplina requerida | **Elegida** |
| **D. Behavior-Driven Development (BDD) completo con Gherkin ejecutable** | Escenarios ejecutados directamente | Muy expresivo | Sobrecarga de tooling · complejidad para el taller inicial | Se pospone para evaluación post-taller |

---

## 5. Consecuencias

### 5.1 Positivas

- Trazabilidad end-to-end auditable: US → UC → AC → Prueba → Código → Commit → PR.
- Cobertura efectiva que refleja comportamiento, no implementación.
- Copilot dispone de contexto rico (UC + AC) para generar código pertinente.
- Casos borde cubiertos por diseño (6 escenarios mínimos).
- Refactor seguro: las pruebas actúan como red de seguridad.
- Alineación con Clean Architecture y SOLID (el ciclo lo exige naturalmente).

### 5.2 Negativas / Costos

- Curva de aprendizaje para equipos no habituados a TDD.
- Mayor tiempo aparente en los primeros ciclos (compensado con menor retrabajo).
- Requiere disciplina sostenida — vulnerable si no se mide y refuerza.

### 5.3 Neutrales / Observaciones

- La velocidad percibida cambia: menos código escrito por hora pero más código útil por sprint.
- Los equipos suelen reportar aumento de confianza al modificar código legacy tras adoptar TDD.

---

## 6. Cumplimiento y verificación

- **Instructions Copilot** que refuerzan el flujo Red-Green-Refactor.
- **Workflow agentic** que valida en cada PR:
  - Presencia de UC + AC para el commit.
  - Presencia de pruebas nuevas o modificadas.
  - Ejecución exitosa de la suite completa.
- **Métricas monitoreadas:**
  - Cobertura de línea y de rama.
  - Ratio pruebas/código productivo.
  - Tasa de PRs rechazados por incumplimiento del flujo.
- **Revisión de código obligatoria** por al menos 1 par que valide la trazabilidad AC ↔ Test.

---

## 7. Excepciones

- **Hotfixes de producción críticos** pueden mergear sin ciclo completo, con **compromiso escrito** de completar UC + AC + pruebas en un PR de seguimiento dentro de la sprint siguiente.
- Toda excepción se registra en un log dedicado y se revisa en la retrospectiva del taller.

---

## 8. Referencias

- Kent Beck — *Test-Driven Development: By Example* (2002).
- Martin Fowler — *TestDrivenDevelopment* (bliki).
- GitHub Blog — *Spec-Driven Development with Copilot* (Spec Kit).
- Robert C. Martin — *Clean Architecture* (2017).
- Documento maestro del Taller — sección 5 (Tema 3).
- ADRs relacionados: `ADR-001` (polirrepo).

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| 2026-07-06 | propuesto | Por definir | Versión inicial del taller |