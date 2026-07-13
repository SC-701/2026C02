---
workflow_id: validar-arquitectura
name: Validar Arquitectura por Capas
description: Se ejecuta en cada PR de backend C# que modifica src/. Valida que las dependencias entre proyectos respetan la Regla de Dependencia (Constitution §3.2) y que cada capa cumple sus responsabilidades exclusivas. Usa Safe Outputs.
type: agentic
version: 0.1
status: activo
scope: backend
owner: Por definir
governs_by: constitution.md §3, §9.5
composes_skills: []
safe_outputs: true
---

# 🏛️ Workflow agentic · Validar Arquitectura por Capas

## 1. Propósito

Detectar automáticamente violaciones a la Regla de Dependencia y a las responsabilidades por capa antes de que lleguen a la revisión humana, y publicar un reporte con la ubicación exacta del problema.

## 2. Disparadores

- `pull_request` → `opened`, `synchronize`, `reopened`.
- **Paths:** `src/**/*.cs`, `src/**/*.csproj`.

## 3. Permisos requeridos

- `contents: read`
- `pull-requests: write` (solo comentario y labels).

**Prohibido:** modificar archivos, aprobar/mergear.

## 4. Flujo del workflow

```
Trigger (PR sobre src/**)
        ↓
Identificar proyectos afectados y su capa por sufijo del csproj
    (.Abstracciones, .Api, .Flujo, .Reglas, .Servicios, .AccesoDatos)
        ↓
Analizar dependencias declaradas en cada .csproj
        ↓
Verificar Regla de Dependencia (Constitution §3.2):
    - Toda dependencia apunta hacia adentro (hacia Abstracciones).
    - Composition Root único (solo Api compone).
        ↓
Analizar imports/usos por archivo modificado:
    - Reglas no hace I/O (sin using de System.IO, HttpClient, DateTime.Now directo, logs).
    - Api no contiene lógica de negocio (controllers thin).
    - AccesoDatos no contiene lógica de negocio.
        ↓
Consolidar violaciones detectadas
        ↓
Publicar comentario (Safe Output)
        ↓
Aplicar etiqueta según decisión
```

## 5. Detalle de las validaciones

### 5.1 Regla de Dependencia (§3.2)

Extraer del `.csproj` las referencias entre proyectos. Validar que:

| Capa | Puede depender de |
|---|---|
| Abstracciones | — (nadie) |
| API | Abstracciones, Flujo |
| Flujo | Abstracciones, Reglas, Servicios, AccesoDatos |
| Reglas | Abstracciones |
| Servicios | Abstracciones |
| AccesoDatos | Abstracciones |

Cualquier dependencia fuera de esta tabla es **violación crítica**.

### 5.2 Composition Root único (§3.3)

Buscar registraciones DI (`AddScoped`, `AddSingleton`, `AddTransient`) fuera de `Api/`. **Violación alta** si aparecen en otras capas.

### 5.3 Reglas puro (§3.6)

En archivos bajo `src/**/*.Reglas/**/*.cs`, detectar:
- `System.IO`, `File.*`
- `HttpClient`, `HttpRequest`
- `DateTime.Now`, `DateTime.UtcNow`, `Guid.NewGuid()` directos
- `ILogger` inyectado o usado
- `System.Data`, `SqlConnection`

Cada uno es **violación crítica** del principio "reglas de negocio puras".

### 5.4 Controllers thin (§3.5)

En `src/**/*.Api/Controllers/*.cs`, detectar:
- Cuerpos de método con más de ~15 líneas.
- Referencias directas a `.AccesoDatos` desde el controller (debe pasar por `.Flujo`).
- Lógica condicional compleja (sin ifs anidados de negocio).

**Violación alta** si se detectan.

### 5.5 AccesoDatos sin lógica (§3 tabla)

En `src/**/*.AccesoDatos/**/*.cs`, detectar:
- Reglas de negocio (cálculos, validaciones complejas).
- Referencias a `.Reglas` (AccesoDatos no consume Reglas).

**Violación alta.**

### 5.6 Publicar comentario (Safe Output)

```markdown
## 🏛️ Reporte automático · Validar Arquitectura

Decisión: **<Aprobado | Requiere ajustes | Bloquea PR>**

### Violaciones detectadas

| Severidad | Archivo | Línea | Regla | Recomendación |
|---|---|---|---|---|
| Crítica | src/Producto.Reglas/ConsultorTitulares.cs | 42 | §3.6 (Reglas puro) | Reemplazar `DateTime.Now` por dependencia inyectada `IReloj`. |
| Alta | src/Producto.Api/Controllers/TitularesController.cs | 28 | §3.5 (Controllers thin) | Método de 34 líneas. Mover orquestación a `Flujo`. |
| Alta | src/Producto.Flujo/Producto.Flujo.csproj | — | §3.2 (Regla de Dependencia) | Referencia inválida a `Producto.Api`. Flujo no debe conocer Api. |

### Regla de Dependencia — mapa actual
✅ Api → Flujo → { Reglas, Servicios, AccesoDatos } → Abstracciones
❌ Flujo → Api (violación detectada)

> Este reporte es informativo. La revisión humana es obligatoria.
```

### 5.7 Etiquetar el PR

| Decisión | Etiqueta |
|---|---|
| Aprobado | `arq-ok` |
| Requiere ajustes | `arq-requiere-ajustes` |
| Bloquea PR | `arq-bloqueada` |

## 6. Salidas seguras

**SOLO:** un comentario, labels, logs.
**NUNCA:** modificar código, `.csproj`, aprobar/mergear.

## 7. Manejo de errores

- Si algún `.csproj` está mal formado → reportar y continuar con los válidos.
- Si el PR no toca backend → salir sin comentar.

## 8. Idempotencia

Actualiza el comentario existente (marcador `<!-- validar-arquitectura-report -->`).

## 9. Referencias

- Constitution §3 (arquitectura por capas), §9.5 (Safe Outputs).
- `academia/docs/instructions/*.instructions.md` (reglas path-specific).

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del taller. |