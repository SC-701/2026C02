---
adr_id: ADR-###
title: <Título corto y descriptivo de la decisión>
status: propuesto | aceptado | rechazado | deprecado | supersede-por-ADR-###
date: YYYY-MM-DD
authors: [Por definir]
reviewers: [Por definir]
tags: [arquitectura, backend | frontend | proceso, ...]
supersedes: []
superseded_by: []
---

# ADR-### · <Título de la decisión>

> **Formato:** Michael Nygard — *Documenting Architecture Decisions* (2011).

---

## 1. Estado

`propuesto` | `aceptado` | `rechazado` | `deprecado` | `supersede-por-ADR-###`

*(Marcar el estado vigente. Un ADR aceptado es inmutable; los cambios se hacen con un nuevo ADR que lo supersede.)*

---

## 2. Contexto

*Describir la situación, el problema o la fuerza que motiva la decisión. Debe responder:*

- ¿Cuál es el problema o necesidad que se está atendiendo?
- ¿Qué restricciones técnicas, organizacionales o de negocio aplican?
- ¿Qué se sabe hoy que motive esta decisión ahora?
- ¿Qué pasa si no se decide?

---

## 3. Decisión

*Enunciar la decisión con claridad y en tiempo presente.*

> Se adopta / se establece / se prohíbe / se estandariza…

### 3.1 Detalle de la decisión

*Explicar los elementos concretos que forman parte de la decisión (reglas, componentes, políticas).*

### 3.2 Alcance

- **Aplica a:** *…*
- **No aplica a:** *…*

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| A. | | | | |
| B. | | | | |
| C. | | | | |

---

## 5. Consecuencias

### 5.1 Positivas

- *Beneficio 1*
- *Beneficio 2*

### 5.2 Negativas / Costos

- *Costo o compromiso 1*
- *Costo o compromiso 2*

### 5.3 Neutrales / Observaciones

- *Aspectos a monitorear durante la vigencia de la decisión.*

---

## 6. Cumplimiento y verificación

*¿Cómo se verifica que la decisión se está cumpliendo?*

- Mecanismo de validación automática (workflow, linter, test, …).
- Mecanismo de validación en revisión de código.
- Métrica o indicador que evidencia adopción.

---

## 7. Excepciones

*¿Qué mecanismo existe para solicitar excepciones? ¿Quién las aprueba?*

- Vía: PR al ADR o ADR nuevo con fundamento.
- Aprobador: *…*
- Registro: *…*

---

## 8. Referencias

- Estándar externo 1
- Estándar externo 2
- Documento interno relacionado
- ADRs relacionados: `[ADR-###]`

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| YYYY-MM-DD | propuesto | *Por definir* | Versión inicial |