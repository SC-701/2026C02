---
workflow_id: validar-dependencias
name: Validar Dependencias contra Librerías Justificadas con ADR
description: Se ejecuta en cada PR que modifica manifiestos de dependencias (package.json, *.csproj, Directory.Packages.props). Compara los paquetes contra el catálogo de librerías justificadas y publica un reporte de dependencias nuevas, no autorizadas o con versiones no exactas. Usa Safe Outputs.
type: agentic
version: 0.1
status: activo
scope: transversal
owner: Por definir
governs_by: constitution.md §1.7, §4.10, §8.4, §9.5, ADR-Frontend-002
composes_skills: []
safe_outputs: true
---

# 📦 Workflow agentic · Validar Dependencias

## 1. Propósito

Bloquear (vía comentario y label) la introducción silenciosa de dependencias OSS fuera del catálogo de librerías justificadas con ADR, y detectar violaciones a las reglas de versionado.

## 2. Disparadores

- `pull_request` → `opened`, `synchronize`, `reopened`.
- **Paths:**
  - `package.json`, `package-lock.json`
  - `**/*.csproj`
  - `Directory.Packages.props`
  - `.npmrc`

## 3. Permisos requeridos

- `contents: read`
- `pull-requests: write` (solo comentario y labels).

**Prohibido:** modificar archivos, aprobar/mergear.

## 4. Flujo del workflow

```
Trigger (PR sobre manifiestos de dependencias)
        ↓
Detectar stack y manifiestos afectados
        ↓
Extraer dependencias declaradas
        ↓
Extraer catálogo de librerías justificadas
    (academia/docs/catalogos/catalogo-dependencias-autorizadas.md)
        ↓
Comparar y detectar:
    - Dependencias nuevas fuera del catálogo de librerías justificadas.
    - Versiones con ^ o ~ (prohibido en frontend por ADR-Frontend-002).
    - package-lock.json faltante o desincronizado (frontend).
    - .npmrc apuntando a feed no aprobado.
        ↓
Publicar comentario (Safe Output)
        ↓
Aplicar etiqueta según decisión
```

## 5. Detalle de las validaciones

### 5.1 Detectar dependencias nuevas

Comparar `base` vs `head`:
- `package.json` → nuevas entradas en `dependencies` y `devDependencies`.
- `*.csproj` → nuevas `<PackageReference>`.
- `Directory.Packages.props` → nuevas `<PackageVersion>`.

### 5.2 Cotejar contra catálogo de librerías justificadas

Cargar `academia/docs/catalogos/catalogo-dependencias-autorizadas.md` y validar cada dependencia nueva contra la lista permitida.

Clasificar:
- ✅ **Permitida** — está en el catálogo.
- ⚠️ **No listada** — no aparece; requiere aprobación explícita vía ADR.
- ❌ **Prohibida explícita** — está en la lista negra de ADR-Frontend-002.

### 5.3 Validar reglas de versionado

**Frontend (ADR-Frontend-002):**
- ❌ Versiones con `^` o `~` en `package.json`.
- ❌ `package-lock.json` ausente del PR o no sincronizado con `package.json`.
- ❌ `.npmrc` apuntando a un feed distinto al aprobado.

**Backend:**
- ⚠️ Advertir si `Directory.Packages.props` no gestiona versiones centralmente (recomendación).

### 5.4 Publicar comentario (Safe Output)

```markdown
## 📦 Reporte automático · Validar Dependencias

Decisión: **<Aprobado | Requiere ADR | Bloquea PR>**

### Dependencias nuevas detectadas
| Paquete | Versión | Estado | Recomendación |
|---|---|---|---|
| `axios` | 1.6.0 | ❌ Prohibida | Reemplazar por useRecurso (custom hook del proyecto). Ver ADR-Frontend-002. |
| `react-router-dom` | 6.20.0 | ✅ Permitida | — |

### Reglas de versionado
- ❌ `package.json` usa `^` en `react-router-dom`. Cambiar a versión exacta.
- ✅ `package-lock.json` versionado y sincronizado.
- ✅ `.npmrc` apunta al npm registry.

### Recomendaciones
- Para introducir `axios`: crear ADR con fundamento, alternativas evaluadas y score de seguridad.
- Corregir versionado antes de solicitar review.

> Este reporte es informativo. La revisión humana es obligatoria.
```

### 5.5 Etiquetar el PR

| Decisión | Etiqueta |
|---|---|
| Aprobado | `deps-ok` |
| Requiere ADR | `deps-requiere-adr` |
| Bloquea PR | `deps-bloqueada` |

## 6. Salidas seguras

**SOLO:** un comentario, labels, logs.
**NUNCA:** modificar `package.json`, `*.csproj`, `package-lock.json`, `.npmrc`; aprobar/mergear.

## 7. Manejo de errores

- Si el catálogo de librerías justificadas no se encuentra → reportar el fallo y bloquear (no hay contra qué validar).
- Si el diff no contiene manifiestos → salir sin comentar.

## 8. Idempotencia

Actualiza el comentario existente (marcador `<!-- validar-dependencias-report -->`).

## 9. Referencias

- Constitution §1.7, §4.10, §8.4, §9.5.
- ADR-Frontend-002 (lista blanca de dependencias).
- Catálogo: `academia/docs/catalogos/catalogo-dependencias-autorizadas.md` (pendiente).

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |