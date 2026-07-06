---
workflow_id: revisar-pr
name: Revisión Consolidada de PR
description: Workflow orquestador que se ejecuta al abrir o actualizar un PR. Invoca el Skill revisar-pr (que a su vez compone validar-uc y analisis-cobertura) y consolida los reportes de los demás workflows en un único comentario resumen. Usa Safe Outputs.
type: agentic
version: 0.1
status: activo
scope: transversal
owner: Por definir
governs_by: constitution.md (íntegra), §9.5, ADR-003
composes_skills: [revisar-pr]
safe_outputs: true
depends_on_workflows: [validar-uc, validar-cobertura, validar-dependencias, validar-arquitectura]
---

# 🔍 Workflow agentic · Revisar PR (orquestador)

## 1. Propósito

Consolidar en un único reporte todos los hallazgos de los workflows especializados y del Skill `revisar-pr`, entregándoselo al reviewer humano como **punto de partida** de su revisión.

No sustituye la revisión humana — la acelera, estandariza y hace más rigurosa.

## 2. Disparadores

- `pull_request` → `opened`, `ready_for_review`, `synchronize`.
- `workflow_run` → completado de: `validar-uc`, `validar-cobertura`, `validar-dependencias`, `validar-arquitectura`.

## 3. Permisos requeridos

- `contents: read`
- `pull-requests: write` (solo comentario y labels).
- `checks: read` (para leer los status checks de los otros workflows).

**Prohibido:** modificar archivos, aprobar/mergear.

## 4. Flujo del workflow

```
Trigger (PR abierto/actualizado o workflow_run completado)
        ↓
Recolectar reportes de los workflows dependientes:
    - validar-uc
    - validar-cobertura
    - validar-dependencias
    - validar-arquitectura
        ↓
Invocar Skill revisar-pr con prId y repoContext
    ↓
    El Skill compone internamente validar-uc y analisis-cobertura
    (idempotencia: usa los reportes ya cacheados si están disponibles)
        ↓
Consolidar dimensión por dimensión
        ↓
Determinar decisión sugerida agregada
        ↓
Publicar comentario resumen consolidado (Safe Output)
        ↓
Aplicar etiqueta y status check no bloqueante
```

## 5. Detalle de los pasos

### 5.1 Recolectar reportes

Buscar en el PR los comentarios con marcadores:
- `<!-- validar-uc-report -->`
- `<!-- validar-cobertura-report -->`
- `<!-- validar-dependencias-report -->`
- `<!-- validar-arquitectura-report -->`

Si alguno no existe, marcarlo como `pendiente` en la sección correspondiente.

### 5.2 Invocar Skill `revisar-pr`

Ejecutar el Skill con:
- `prId` = número del PR.
- `repoContext` = URL del repo.

El Skill:
- Valida trazabilidad `US-###` y `AC-##`.
- Verifica arquitectura, SOLID, Clean Code, seguridad, commits, CI.
- Compone internamente `validar-uc` y `analisis-cobertura` (para producir su propio reporte).

### 5.3 Consolidar

Agregar por dimensión:

| Dimensión | Fuente | Estado |
|---|---|---|
| Trazabilidad | Skill `revisar-pr` | ✅ / ⚠️ / ❌ |
| UC | Workflow `validar-uc` + Skill | ✅ / ⚠️ / ❌ |
| Cobertura | Workflow `validar-cobertura` | ✅ / ⚠️ / ❌ |
| Dependencias | Workflow `validar-dependencias` | ✅ / ⚠️ / ❌ |
| Arquitectura | Workflow `validar-arquitectura` | ✅ / ⚠️ / ❌ |
| SOLID / Clean Code | Skill `revisar-pr` | ✅ / ⚠️ / ❌ |
| Seguridad | Skill `revisar-pr` | ✅ / ⚠️ / ❌ |
| Commits | Skill `revisar-pr` | ✅ / ⚠️ / ❌ |
| CI | Actions runs | ✅ / ⚠️ / ❌ |

### 5.4 Decisión agregada

| Regla | Decisión |
|---|---|
| Cualquier dimensión ❌ | **Bloquear** |
| Alguna dimensión ⚠️ y ninguna ❌ | **Solicitar cambios** |
| Todas ✅ | **Aprobar** |

### 5.5 Publicar comentario resumen (Safe Output)

```markdown
## 🔍 Reporte consolidado · Revisar PR

Decisión sugerida: **<Aprobar | Solicitar cambios | Bloquear>**

### Resumen por dimensión

| Dimensión | Estado | Detalle |
|---|---|---|
| Trazabilidad | ✅ | US-123, AC-01..AC-06 referenciados |
| UC | ✅ | Válido (ver reporte de validar-uc) |
| Cobertura | ⚠️ | Rama 71% < 75% umbral |
| Dependencias | ✅ | Sin nuevas fuera del catálogo |
| Arquitectura | ❌ | Bc con DateTime.Now directo (§3.6) |
| SOLID / Clean Code | ⚠️ | 2 métodos > 20 líneas |
| Seguridad | ✅ | Sin secretos, entradas validadas |
| Commits | ✅ | Conventional Commits OK |
| CI | ✅ | Verde |

### Observaciones críticas
- `src/Producto.Bc/ConsultorTitulares.cs:42` — `DateTime.Now` directo. Ver Constitution §3.6.

### Observaciones altas
- Cobertura de rama por debajo del umbral. Ver reporte de validar-cobertura.
- `TitularesController.Get` de 34 líneas (>20). Ver §7.3.

### Enlaces a reportes detallados
- #issuecomment-123
- #issuecomment-124
- #issuecomment-125
- #issuecomment-126

> Este reporte es una **sugerencia** para el reviewer humano. La aprobación final es humana.
```

### 5.6 Etiquetar y status check

**Labels agregados según decisión:**
| Decisión | Etiqueta |
|---|---|
| Aprobar | `revision-sugerida-aprobar` |
| Solicitar cambios | `revision-sugerida-cambios` |
| Bloquear | `revision-sugerida-bloquear` |

**Status check no bloqueante** con el mismo estado — informativo.

## 6. Salidas seguras

**SOLO:**
- ✅ Un comentario resumen (marcador `<!-- revisar-pr-report -->`).
- ✅ Labels.
- ✅ Status check no bloqueante.
- ✅ Logs.

**NUNCA:**
- ❌ Aprobar el PR.
- ❌ Mergear.
- ❌ Cerrar el PR.
- ❌ Modificar código.
- ❌ Sobrescribir reportes de otros workflows.

## 7. Manejo de errores

- Si un workflow dependiente aún no completó → indicar en el comentario "pendiente" y re-ejecutar al recibir el `workflow_run` completado.
- Si el Skill `revisar-pr` falla → publicar comentario informando el fallo y no aplicar labels de decisión.
- Si el PR está en modo `draft` → salir sin comentar hasta que pase a `ready_for_review`.

## 8. Idempotencia

- Actualiza el comentario existente (marcador HTML) en cada re-ejecución.
- Sincroniza labels (remueve las de decisión previa, aplica la nueva).
- No duplica comentarios.

## 9. Referencias

- Constitution (íntegra) — el skill `revisar-pr` la audita completa.
- Constitution §9.5 (Safe Outputs).
- Skills compuestos: `revisar-pr`, `validar-uc`, `analisis-cobertura`.
- Workflows relacionados: `validar-uc`, `validar-cobertura`, `validar-dependencias`, `validar-arquitectura`.
- ADR-003 (Skills como 8° elemento).

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |