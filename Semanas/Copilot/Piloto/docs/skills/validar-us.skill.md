---
id: validar-us
name: Validar US
description: Verifica que una historia de usuario (US) cumple la plantilla institucional, contiene las 10 secciones obligatorias, satisface los 6 criterios INVEST, expone al menos 2 criterios de aceptación de alto nivel y tiene trazabilidad completa hacia el epic y los casos de uso derivados.
scope: transversal
inputs:
  - usPath: Ruta al archivo US-###.md a validar.
outputs:
  - reporteValidacion: Estado de cada sección obligatoria.
  - checklistINVEST: Estado de los 6 criterios INVEST.
  - observaciones: Lista de observaciones con severidad.
  - decision: Lista / Requiere ajustes / Rechazada.
used_by_agents: [analista-requisitos]
used_by_prompts: [/generar-historia-de-usuario]
owner: Por definir
version: 0.1
status: activo
governs_by: constitution.md §2.1, ADR-002
---

# ✅ Skill · Validar US

## 1. Propósito

Validar que una historia de usuario (US) puede utilizarse como **punto de partida ejecutable** para el ciclo SDD + TDD: cumple la plantilla, tiene todas las secciones obligatorias, satisface los 6 criterios INVEST, expone al menos 2 criterios de aceptación de alto nivel y tiene trazabilidad completa hacia el epic y los casos de uso derivados.

## 2. Cuándo usarlo

- **Antes de derivar casos de uso** — para asegurar que la US es contrato de refinamiento válido.
- **Después de generar una US** con el prompt `/generar-historia-de-usuario` — como verificación de calidad.
- **En el pipeline** que valida cambios sobre `docs/stories/` (workflow agentic).
- **En revisión de PR** cuando el PO introduce o modifica historias de usuario.

## 3. Cuándo NO usarlo

- Sobre archivos que no son US (casos de uso `UC-###`, ADRs, runbooks).
- Como sustituto de la revisión de negocio por el Product Owner real.
- Sobre borradores muy tempranos donde algunas secciones están intencionalmente incompletas — usar solo cuando la US pretende avanzar a estado `refinada` o superior.

## 4. Entradas

| Nombre | Requerido | Descripción |
|---|---|---|
| `usPath` | Sí | Ruta relativa al archivo `docs/stories/US-###-*.md`. |

## 5. Pasos

1. **Leer el archivo** `${usPath}` y verificar que existe.

2. **Validar frontmatter YAML:**
   - Campos obligatorios presentes: `id`, `title`, `status`, `owner`, `size`, `priority`, `related_uc`, `related_epic`, `tags`, `version`, `last-reviewed`.
   - `id` con formato `US-###` y coincide con el nombre del archivo.
   - `status` es uno de: `borrador | refinada | comprometida | implementada | deprecada`.
   - `size` es uno de: `XS | S | M | L | XL`.
   - `priority` es uno de: `alta | media | baja`.

3. **Validar presencia de las 10 secciones obligatorias:**
   1. Historia de usuario
   2. Valor de negocio
   3. Criterios INVEST
   4. Criterios de aceptación de alto nivel
   5. Casos de uso asociados
   6. Restricciones y supuestos
   7. Fuera de alcance
   8. Dependencias
   9. Notas de refinamiento
   10. Historial

4. **Validar la Historia de usuario (§1):** debe seguir el formato `Como / Quiero / Con el fin de`.

5. **Validar el Valor de negocio (§2):** debe tener al menos una viñeta con contenido específico (no placeholder vacío).

6. **Validar los criterios INVEST (§3):**
   - Los 6 ítems deben estar presentes: Independiente, Negociable, Valiosa, Estimable, Small, Testable.
   - Cada ítem debe estar marcado `[x]` o incluir una nota de justificación de por qué no aplica.

7. **Validar los criterios de aceptación de alto nivel (§4):**
   - Al menos 2 criterios presentes con contenido específico.
   - Redactados en lenguaje natural observable (no deben ser únicamente técnicos).

8. **Validar los casos de uso asociados (§5):**
   - Si `status` es `comprometida` o superior, la tabla debe tener al menos un UC con ID `UC-###` válido.
   - Si `status` es `borrador` o `refinada`, puede estar vacía pero no completamente con placeholders.

9. **Validar Fuera de alcance (§7):** debe tener al menos una viñeta con contenido específico para evitar scope creep.

10. **Detectar placeholders sin resolver** (`<algo>`, `TODO`, `Por definir`) fuera de las secciones donde son aceptables (Notas de refinamiento, Historial, Casos de uso asociados en borrador).

11. **Generar reporte** con severidad por observación:
    - `crítica` — bloquea el uso de la US.
    - `alta` — debe corregirse antes de derivar UCs.
    - `media` — recomendación fuerte.
    - `baja` — observación menor.

12. **Determinar decisión:**
    - `Lista` — sin observaciones críticas ni altas.
    - `Requiere ajustes` — hay altas o medias sin resolver.
    - `Rechazada` — hay críticas o faltan secciones obligatorias.

## 6. Validaciones

- ✅ Archivo existe y es Markdown válido.
- ✅ Frontmatter YAML bien formado con todos los campos requeridos.
- ✅ 10 secciones obligatorias presentes.
- ✅ Historia en formato Como / Quiero / Con el fin de.
- ✅ Criterios INVEST: los 6 ítems marcados o justificados.
- ✅ Al menos 2 criterios de aceptación de alto nivel con contenido observable.
- ✅ Fuera de alcance definido con al menos una viñeta específica.
- ✅ Sin placeholders sin resolver en secciones de contenido.

## 7. Salidas

- **`reporteValidacion`:**

| Sección | Presente | Correcta | Observación |
|---|---|---|---|
| Frontmatter | ✅ | ✅ | — |
| Historia de usuario | ✅ | ✅ | — |
| Valor de negocio | ✅ | ⚠️ | Solo tiene un placeholder. |
| Criterios INVEST | ✅ | ⚠️ | "Estimable" no está marcado ni justificado. |
| ... | ... | ... | ... |

- **`checklistINVEST`:**

| Criterio | Marcado | Observación |
|---|---|---|
| Independiente | ✅ | — |
| Negociable | ✅ | — |
| Valiosa | ✅ | — |
| Estimable | ❌ | No marcado ni justificado. |
| Small | ✅ | — |
| Testable | ✅ | — |

- **`observaciones`** — lista ordenada por severidad con línea del archivo y recomendación concreta.

- **`decision`** — `Lista` / `Requiere ajustes` / `Rechazada`.

## 8. Ejemplos

### Ejemplo: US rechazada

```
Decisión: Rechazada.

Observaciones críticas:
- Falta sección 4 (Criterios de aceptación de alto nivel).
- La Historia de usuario no sigue el formato Como/Quiero/Con el fin de — dice
  "El sistema debe permitir..." en lugar de perspectiva del usuario.

Observaciones altas:
- Criterio INVEST "Estimable" no está marcado ni justificado.
- Fuera de alcance (§7) solo tiene el placeholder "…" sin contenido específico.
```

### Ejemplo: US lista

```
Decisión: Lista.

Todas las secciones obligatorias presentes y correctas.
Criterios INVEST: 6/6 marcados.
Criterios de aceptación de alto nivel: 3 criterios observables.
Sin placeholders sin resolver.

La US puede avanzar a derivación de casos de uso con /generar-caso-de-uso.
```

## 9. Notas

- Este skill es el punto de entrada para garantizar que el ciclo SDD + TDD comience con requisitos de calidad.
- La validación de los UCs derivados (`validar-uc`) es responsabilidad del agente técnico; este skill solo valida el nivel US.
- Los criterios de aceptación de **alto nivel** aquí validados se detallan y formalizan en GWT dentro de los UCs correspondientes.
