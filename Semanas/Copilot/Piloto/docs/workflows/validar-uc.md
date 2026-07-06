---
workflow_id: validar-uc
name: Validar Casos de Uso
description: Se ejecuta en cada PR que modifica archivos bajo docs/use-cases/. Invoca el Skill validar-uc para verificar que cada UC modificado cumple la plantilla, tiene las 11 secciones obligatorias, cubre los 6 escenarios mínimos y expone trazabilidad completa. Usa Safe Outputs; comenta en el PR pero nunca bloquea directamente.
type: agentic
version: 0.1
status: activo
scope: transversal
owner: Por definir
governs_by: constitution.md §9.5, §2.5, ADR-002, ADR-003
composes_skills: [validar-uc]
safe_outputs: true
---

# 🧠 Workflow agentic · Validar Casos de Uso

## 1. Propósito

Ejecutar automáticamente el Skill `validar-uc` sobre cualquier UC que se cree o modifique en un PR, para que el reviewer humano reciba un reporte estructurado sin tener que invocarlo manualmente.

## 2. Disparadores

- `pull_request` → `opened`, `synchronize`, `reopened`.
- **Paths:** `docs/use-cases/**/*.md`.

## 3. Permisos requeridos

- `contents: read`
- `pull-requests: write` (solo para comentar; no para aprobar ni mergear).
- `issues: write` (solo para comentar).

**Prohibido:**
- `contents: write`
- `pull-requests: write` para approve/dismiss.
- Modificar ramas o archivos del repo.

## 4. Flujo del workflow

```
Trigger (PR sobre docs/use-cases/**)
        ↓
Detectar UCs modificados en el diff
        ↓
Para cada UC modificado:
    ↓
    Invocar Skill validar-uc
    ↓
    Recolectar reporte (secciones, escenarios, observaciones, decisión)
        ↓
Consolidar reportes de todos los UCs
        ↓
Publicar comentario resumen en el PR (Safe Output)
        ↓
Etiquetar el PR según decisión agregada
```

## 5. Detalle de los pasos

### 5.1 Detectar UCs modificados

Comparar `base` vs `head` del PR y extraer archivos que:
- Existen en `docs/use-cases/`.
- Tienen extensión `.md`.
- Empiezan con `UC-###`.

### 5.2 Invocar Skill `validar-uc`

Para cada UC modificado, ejecutar el Skill con:
- `ucPath` = ruta relativa del archivo.

Recolectar del Skill:
- `reporteValidacion`
- `checklistEscenarios`
- `observaciones`
- `decision`

### 5.3 Consolidar

Agregar por UC:
- Total de observaciones críticas / altas / medias / bajas.
- Decisión individual.

Determinar **decisión agregada del workflow:**
- `Válido` — todos los UCs válidos.
- `Requiere ajustes` — al menos un UC con altas o medias sin resolver.
- `Rechazado` — al menos un UC con críticas o secciones faltantes.

### 5.4 Publicar comentario (Safe Output)

Formato del comentario:

```markdown
## 🧠 Reporte automático · Validar UC

Decisión agregada: **<Válido | Requiere ajustes | Rechazado>**

| UC | Decisión | Críticas | Altas | Medias | Bajas |
|---|---|---|---|---|---|
| UC-001 | Válido | 0 | 0 | 1 | 2 |
| UC-002 | Rechazado | 2 | 1 | 0 | 0 |

<details>
<summary>Observaciones detalladas</summary>

### UC-001
- (media) Sección 8 vacía.
- (baja) Frontmatter sin `last-reviewed`.

### UC-002
- (crítica) Falta sección 6 (Criterios de aceptación).
- (crítica) AC-01 sin `Entonces` observable.
- (alta) Falta AC para escenario "no encontrado".

</details>

> Este reporte es informativo. La revisión humana es obligatoria.
```

### 5.5 Etiquetar el PR

Aplicar automáticamente una etiqueta según la decisión:

| Decisión | Etiqueta |
|---|---|
| Válido | `uc-valido` |
| Requiere ajustes | `uc-requiere-ajustes` |
| Rechazado | `uc-rechazado` |

Al re-ejecutarse, remover etiquetas previas y aplicar la nueva.

## 6. Salidas seguras (Safe Outputs)

Este workflow **SOLO** puede:
- ✅ Publicar UN comentario en el PR (o actualizar el existente).
- ✅ Aplicar / remover etiquetas del PR.
- ✅ Escribir logs en Actions.

Este workflow **NUNCA** debe:
- ❌ Modificar archivos del repositorio.
- ❌ Aprobar ni rechazar el PR.
- ❌ Mergear ni cerrar el PR.
- ❌ Escribir en issues distintos del PR.
- ❌ Llamar a APIs externas fuera del `github.com` allowlist.

## 7. Manejo de errores

- Si el Skill `validar-uc` falla → publicar comentario informando el fallo con el mensaje de error y **NO** aplicar ninguna etiqueta.
- Si un UC referenciado por el diff no existe → registrar en log y continuar con los demás.
- Si no hay UCs modificados → salir sin comentar (no ruido).

## 8. Idempotencia

- El workflow busca un comentario previo con el marcador `<!-- validar-uc-report -->`.
- Si existe, lo **actualiza** en lugar de crear uno nuevo.
- Las etiquetas se sincronizan (remover previa, aplicar nueva).

## 9. Referencias

- Constitution §2.5, §9.5.
- Skill: `validar-uc`.
- ADR-002 (SDD + TDD), ADR-003 (Skills).
- Template UC: `academia/docs/templates/UC-template.md`.

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |