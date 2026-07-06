---
id: UC-###
title: <Título corto y descriptivo del caso de uso>
status: borrador | aprobado | implementado | deprecado
owner: <nombre del Product Owner o dueño funcional>
tech_lead: <nombre del Tech Lead o dueño técnico>
related_stories: [US-###]
related_ac: [AC-01, AC-02]
tags: [dominio, subdominio, tag-libre]
version: 0.1
last-reviewed: YYYY-MM-DD
---

# UC-### · <Título del caso de uso>

> **Uso:** un caso de uso vive en `docs/use-cases/UC-###-<nombre>.md` y actúa como **contrato ejecutable**: alimenta las pruebas unitarias, guía a Copilot y sirve de referencia para revisión de código.

---

## 1. Historia de usuario

**Como** *<rol del actor primario>*
**Quiero** *<capacidad concreta que necesita>*
**Con el fin de** *<beneficio de negocio o valor esperado>*

---

## 2. Actores

- **Primario:** *<actor que inicia el caso de uso>*
- **Secundarios:** *<otros actores o sistemas involucrados>*

---

## 3. Precondiciones

*Condiciones que deben cumplirse antes de iniciar el caso de uso.*

- *…*
- *…*

---

## 4. Flujo básico (happy path)

1. *Paso 1 — acción del actor.*
2. *Paso 2 — respuesta del sistema.*
3. *Paso 3 — …*
4. *Paso N — resultado final.*

---

## 5. Flujos alternos y excepciones

| Código | Situación | Comportamiento esperado |
|---|---|---|
| 5a | *Ej. entidad inexistente* | *Ej. error 404 con mensaje descriptivo* |
| 5b | *Ej. sin resultados* | *Ej. lista vacía + código 200* |
| 5c | *…* | *…* |

---

## 6. Criterios de aceptación (formato GWT)

> **Regla:** un escenario = una regla verificable. Resultados **observables** (código HTTP, mensaje exacto, evento).
> **Cobertura mínima obligatoria:** los 6 escenarios de la sección 6.7.

### AC-01 · <Nombre corto del escenario>

**Dado** *<contexto inicial>*
**Y** *<contexto adicional si aplica>*
**Cuando** *<acción o evento>*
**Entonces** *<resultado observable>*
**Y** *<verificación adicional si aplica>*

### AC-02 · <Nombre corto>

**Dado** *…*
**Cuando** *…*
**Entonces** *…*

### AC-03 · <…>

*…*

### 6.7 Escenarios mínimos obligatorios

Este UC debe cubrir al menos un AC por cada categoría:

- [ ] **Éxito** (happy path)
- [ ] **Validación de entrada** (parámetros faltantes, formato inválido)
- [ ] **Autenticación / autorización** (401, 403)
- [ ] **No encontrado / vacío** (404, o 200 con lista vacía)
- [ ] **Duplicidad / idempotencia** (doble envío, reintento)
- [ ] **Fallo de dependencia externa** (5xx, timeout)

---

## 7. Postcondiciones

*Estado del sistema después de ejecutar el caso de uso.*

- *…*
- *…*

---

## 8. Reglas de negocio aplicables

- *Referencia a regla de negocio 1 (con enlace si existe).*
- *Referencia a regla de negocio 2.*

---

## 9. Trazabilidad

| Artefacto | Enlace |
|---|---|
| Historia de usuario | `../stories/US-###.md` |
| Pruebas unitarias | `tests/UC-###/*` |
| Endpoint (si aplica) | `<Método> <ruta>` |
| Componente frontend (si aplica) | `src/features/<feature>/…` |
| ADRs relacionados | `[ADR-###]` |

---

## 10. Notas y decisiones

*Cualquier decisión, supuesto o pregunta abierta relevante para implementar este caso de uso.*

- *…*

---

## 11. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | YYYY-MM-DD | Por definir | Versión inicial |