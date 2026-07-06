---
workflow_id: validar-cobertura
name: Validar Cobertura y Escenarios Mínimos
description: Se ejecuta en cada PR que modifica src/ o tests/. Invoca el Skill analisis-cobertura para auditar cobertura vs umbral y validar que los 6 escenarios mínimos por UC están cubiertos. Usa Safe Outputs; nunca bloquea directamente.
type: agentic
version: 0.1
status: activo
scope: transversal
owner: Por definir
governs_by: constitution.md §2.3, §2.4, §2.5, §9.5, ADR-002
composes_skills: [analisis-cobertura]
safe_outputs: true
---

# 📊 Workflow agentic · Validar Cobertura

## 1. Propósito

Ejecutar automáticamente el Skill `analisis-cobertura` sobre los archivos del PR y publicar un reporte estructurado que audite:

- Cobertura de línea y rama vs umbral definido en CI.
- Cobertura de los 6 escenarios mínimos por UC referenciado.
- Relación 1 a 1 entre AC ↔ pruebas ↔ código.

## 2. Disparadores

- `pull_request` → `opened`, `synchronize`, `reopened`.
- **Paths:** `src/**`, `tests/**`, `package.json`, `*.csproj`.

## 3. Permisos requeridos

- `contents: read`
- `pull-requests: write` (solo comentario y labels).
- `checks: write` (para reportar el status check).

**Prohibido:** modificar archivos, aprobar/mergear PRs.

## 4. Flujo del workflow

```
Trigger (PR sobre src/, tests/, package.json, *.csproj)
        ↓
Detectar stack (backend / frontend)
        ↓
Ejecutar suite con cobertura
    ↓
    Backend:  dotnet test --collect:"XPlat Code Coverage"
    Frontend: npm run test -- --coverage
        ↓
Detectar UCs referenciados en el PR (título, cuerpo, commits)
        ↓
Invocar Skill analisis-cobertura
    ↓
    Recolectar: reporteCobertura, checklistEscenarios, gaps, decision
        ↓
Publicar comentario resumen (Safe Output)
        ↓
Aplicar etiqueta según decisión
        ↓
Reportar status check no bloqueante
```

## 5. Detalle de los pasos

### 5.1 Detectar stack

Buscar en la raíz del repo:
- `*.sln` → **backend C#**.
- `package.json` con `react` en `dependencies` → **frontend React**.
- Ambos → ejecutar ambos flujos.

### 5.2 Ejecutar cobertura

**Backend:**
```bash
dotnet test --configuration Release \
  --collect:"XPlat Code Coverage" \
  --results-directory ./coverage
```

**Frontend:**
```bash
npm ci
npm run test -- --coverage
```

Si la suite falla → el workflow reporta el fallo y **no** invoca el Skill (la cobertura no tiene sentido sobre suite roja).

### 5.3 Invocar Skill `analisis-cobertura`

Para el conjunto de archivos modificados, ejecutar el Skill con:
- `alcance` = archivos del diff.
- `ucId` = UC(s) referenciados en el PR.
- `umbralMinimo` = tomado del CI del repo.

### 5.4 Publicar comentario (Safe Output)

Formato:

```markdown
## 📊 Reporte automático · Validar Cobertura

Decisión: **<Aprobado | Requiere aprobación explícita | Bloquea PR>**

### Cobertura global
| Métrica | Actual | Umbral | Estado |
|---|---|---|---|
| Línea | 87% | 80% | ✅ |
| Rama | 71% | 75% | ⚠️ |

### Escenarios mínimos por UC

**UC-001**
| Escenario | AC | Prueba | Estado |
|---|---|---|---|
| Éxito | AC-01 | ✅ | ✅ |
| Validación | AC-02 | ✅ | ✅ |
| Auth | AC-03 | ❌ | ⚠️ gap |
| No encontrado | AC-04 | ✅ | ✅ |
| Idempotencia | AC-05 | N/A justificado | ➖ |
| Fallo dep. externa | AC-06 | ✅ | ✅ |

### Gaps detectados
- **Alta:** `AC-03` sin prueba. Recomendación: agregar `Consulte_SinRolSupervisor_Retorna403`.
- **Media:** cobertura de rama en `ConsultorTitulares.Consulte` por debajo del umbral.

> Este reporte es informativo. La revisión humana es obligatoria.
```

### 5.5 Etiquetar el PR

| Decisión | Etiqueta |
|---|---|
| Aprobado | `cobertura-ok` |
| Requiere aprobación explícita | `cobertura-atencion` |
| Bloquea PR | `cobertura-bloqueada` |

### 5.6 Status check no bloqueante

Publicar un **check** informativo con el mismo estado. **No configurar como required** — la decisión de mergear la toma el reviewer humano con base en el reporte.

## 6. Salidas seguras (Safe Outputs)

**SOLO:**
- ✅ Un comentario en el PR (marcador `<!-- validar-cobertura-report -->`).
- ✅ Labels del PR.
- ✅ Status check no bloqueante.
- ✅ Logs en Actions.

**NUNCA:**
- ❌ Modificar archivos.
- ❌ Aprobar / rechazar / mergear el PR.
- ❌ Modificar la configuración del CI ni el umbral.

## 7. Manejo de errores

- Si la suite falla → reportar el fallo y salir sin ejecutar el Skill.
- Si no hay UCs referenciados en el PR → correr solo cobertura global y omitir el checklist de escenarios.
- Si el Skill falla → comentar el error y no aplicar etiqueta.

## 8. Idempotencia

Actualiza el comentario existente (marcador HTML) y sincroniza labels en cada re-ejecución.

## 9. Referencias

- Constitution §2.3, §2.4, §2.5, §9.5.
- Skill: `analisis-cobertura`.
- ADR-002 (SDD + TDD).

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |