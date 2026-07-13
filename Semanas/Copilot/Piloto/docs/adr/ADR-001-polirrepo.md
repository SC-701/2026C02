---
adr_id: ADR-001
title: Adopción de modelo polirrepo por producto
status: propuesto
date: 2026-07-06
authors: [Por definir]
reviewers: [Por definir]
tags: [arquitectura, proceso, git, gobierno]
supersedes: []
superseded_by: []
---

# ADR-001 · Adopción de modelo polirrepo por producto

## 1. Estado

`propuesto` — pendiente de aprobación en la sesión de inicio del taller.

---

## 2. Contexto

La organización requiere una estrategia clara sobre cómo organizar sus repositorios en GitHub para:

- Escalar el desarrollo de múltiples productos en paralelo.
- Aislar dependencias, versionado y ciclos de release por producto.
- Alinear la organización de código con la segmentación de responsabilidades por departamento.
- Facilitar la aplicación diferenciada de políticas de seguridad, CI/CD y accesos.
- Permitir la adopción homogénea del Taller de Desarrollo con GitHub Copilot en cada producto.

Existen dos modelos ampliamente adoptados en la industria: **monorepo** (múltiples proyectos en un solo repositorio) y **polirrepo / multi-repo** (un repositorio por producto o componente). Cada uno tiene fortalezas y compromisos documentados.

Se debe definir un modelo del taller único para dar coherencia al taller y evitar decisiones ad-hoc por equipo.

---

## 3. Decisión

Se adopta el **modelo polirrepo por producto** como estándar del taller.

### 3.1 Detalle de la decisión

- **Nomenclatura obligatoria:** `<Prefijo-Organizacional>.<Producto>.<Componente>`
  Ejemplos: `Producto.Api`, `Producto.SPA`, `Producto.Doc`.
- **Un repositorio por componente** del producto (API, SPA, Documentación, Templates, Scripts).
- **Organización GitHub separada por departamento** para segmentar accesos y políticas.
- **Templates de repositorio obligatorios** para arrancar nuevos repos (`SC-701/Template.API`, `SC-701/Template.SPA`, `Template.Doc`).
- **`copilot-instructions.md` replicado en cada repo** para mantener personalización homogénea.
- **Instructions organizacionales** para reglas transversales (evitan divergencia entre repos).

### 3.2 Alcance

- **Aplica a:** todos los productos nuevos y a los repos creados durante y después del taller.
- **No aplica a:** repositorios existentes previamente al taller — su migración es opcional y debe ser evaluada caso a caso.

---

## 4. Alternativas evaluadas

| Alternativa | Descripción | Pros | Contras | ¿Descartada por? |
|---|---|---|---|---|
| **A. Monorepo global** | Un solo repo con todos los productos | Refactor global fácil · un solo pipeline · descubrimiento de código simple | CI lento · permisos complejos · conflictos de dependencias · release acoplado · onboarding pesado | No encaja con segmentación por departamento y por producto |
| **B. Monorepo por departamento** | Un repo por departamento con múltiples productos | Aislamiento por área · menor complejidad que A | Sigue acoplando productos independientes · release acoplado | Compromiso intermedio sin resolver el problema principal |
| **C. Polirrepo por producto** ✅ | Un repositorio por componente de producto | Aislamiento total · release independiente · permisos claros · CI rápido · compatible con Templates | Dispersión de estándares (mitigable con Templates y Instructions org.) · setup inicial repetitivo (mitigable con Template repos) | **Elegida** |
| **D. Polirrepo por microservicio** | Aún más granular que C | Máximo aislamiento | Explosión de repos · sobrecarga de gobierno | Excede necesidad actual |

---

## 5. Consecuencias

### 5.1 Positivas

- Aislamiento total de fallos, dependencias y ciclos de release por producto.
- Permisos y auditoría claros por repositorio.
- CI/CD independiente y más veloz.
- Compatible con la estrategia de Repository Templates.
- Alineación natural con la segmentación por departamento.
- Escalabilidad organizacional sin cuellos de botella en un único repo.

### 5.2 Negativas / Costos

- Mayor esfuerzo para aplicar cambios transversales (mitigado con Instructions org. + workflows agentic).
- Riesgo de divergencia de estándares (mitigado con Templates + copilot-instructions replicado).
- Mayor cantidad de pipelines a mantener (mitigado con plantillas CI/CD compartidas).

### 5.3 Neutrales / Observaciones

- Se requiere disciplina en mantener sincronizados los `copilot-instructions.md` entre repos.
- La búsqueda cross-repo requiere herramientas específicas (GitHub Search, code search).

---

## 6. Cumplimiento y verificación

- **Templates de repositorio** marcados como *template repository* en la organización GitHub.
- **Regla organizacional:** todo repo nuevo se crea desde un template autorizado.
- **Verificación en revisión:** el nombre del repo cumple la convención `<Prefijo>.<Producto>.<Componente>`.
- **Workflow (opcional):** validador que confirme la presencia de `.github/copilot-instructions.md` en cada repo nuevo.

---

## 7. Excepciones

- Casos donde múltiples productos comparten un ciclo de release realmente acoplado pueden solicitar un repo agrupador vía nuevo ADR.
- La solicitud debe fundamentarse en beneficios técnicos concretos y ser aprobada por Arquitectura.

---

## 8. Referencias

- *Trunk Based Development* — Paul Hammant (comparativa monorepo vs polirrepo).
- GitHub Docs — *About repositories* y *Creating a repository from a template*.
- Martin Fowler — *MonorepoVsPolyrepo* (blog).
- Documento maestro del Taller — sección 3.4.
- ADRs relacionados: —

---

## 9. Historial

| Fecha | Estado | Autor | Cambio |
|---|---|---|---|
| 2026-07-06 | propuesto | Por definir | Versión inicial del taller |