---
id: valida*-uc
name: Validar UC
description: *erifica que un ca*o de uso (UC) cumple la plantilla *nstitucional, contiene las 11 secc*ones obligatorias, c*bre los 6 escenarios mínimos con A* en formato GWT correcto y tiene t*azabilidad completa.
scope: transv*rsal
inputs:
  - ucPath: Ruta al a*chivo UC-###.md a validar.
outputs**  - reporteValidacion: Estado de c*da sección obligatoria.
  - checkl*stEscenarios: Estado*de los 6 escenarios mínimos.
  - o*servaciones: Lista de observacione* con severidad.
  - decision: Váli*o / Requiere *justes / Rechazado.
used_by_agents* [programador-mapi, programador-sp*-react]
used_by_prompts: [/generar*caso-de-uso]
owner: Por definir
ve*sion: 0.1
status: activo
governs_b*: constitution.md §2.1, §2.5,*§2.6
---

# ✅ Skill · Validar UC

*# 1. Propósito

Validar que un cas* de uso (UC) puede ut*lizarse como **contrato ejecutable** por el ciclo TDD: cumple la plan*illa, t*ene todas las secciones obligatori*s, cubre los 6 escenarios mínimos *on AC en formato GWT correcto y ex*one trazabilidad completa hacia hi*torias, pruebas y código.

## 2. C*ándo usarlo

- **Antes de iniciar *a f*se 🔴 RED** — para asegurar que el*UC es contrato ejecutable.*- **Después de generar un UC** con*el prompt `/generar-caso-de-uso` —*como verificación de calidad.
- ***n el p*peline** que valida cambios sobre *docs/use-cases/*** (workflow agentic).
- **En revisi*n de PR** cuando el P* introduce o modifica UCs.

## 3. *uándo NO usarlo

- Sobre archivos *ue no son*UC (historias `US-###`, ADRs, runb*oks).
- Como*sustituto de la revisión de negoci* por el Product Owner.
- Sobre bor*ad*res muy tempranos donde algunas se*ciones están intencionalmente inco*plet*s — usar solo cuando el UC pretend* avanzar a estado `aprobado`.

## *. Entradas

| Nombre | Requerido |*Descripción |
|---|---|---|
| `ucP*th` | S* | Ruta relativa al archivo `docs/*se-cases/UC-###-*.md`. |

## 5. Pa*os

1. **Leer el archivo***`${ucPath}` y verificar que existe*
2. **Validar frontmatter YAML:**
   - Campos obligatorios present*s: `id`, `title`, `status`, `owner*, `tech_lead`, `related_st*ries`, `version`, `last-reviewed`.*   - `id` con formato `UC-###` y c**ncide con el nombre del archivo.
 * - `status` es uno de: `borrador |*aprobado | implementado | deprecad*`.
3. **Validar pres*ncia de las 11 secciones obligator*as:**
   1. Historia de usuario
  *2. Actores
   3. Precondiciones
  *4.*Flujo básico
   5. Flujos alternos*y excepciones
   6. Criterios de a*eptación (GWT)
   7. Post*ondiciones
   8. Reglas de negocio*aplicables
   9. Trazabilidad
   1*. Notas y decisiones
   11.*Historial
4. **Validar la Historia*de usuario:** debe seguir formato *Como / Quiero / Con*el fin de`.
5. **Validar los crite*ios de aceptación (§6 del UC):**
 * - Cada AC t*ene ID `AC-##` numerado secuencial*ente.
   - Cada AC tiene un nombre*cor*o descriptivo.
   - Cada AC sigue *a estructura `Dado / Y / Cuando / *ntonces / Y`.
   - C*da `Entonces` es **observable** (c*digo HTTP, mensaje literal, evento*con nombre).
6. ***alidar los 6 escenarios mínimos** *Constitution §2.5):
   - Éxito · V*lidación · Auth · No encontrado · *dempotencia ·*Fallo dep. externa.
   - Cada esce*ario tiene al menos un AC asociado****** aparece marcado como `N/A justi*icado: <razón>`.
7. **Validar Traz*bilidad (§9 del UC):**
   -*Enlace a historia de usuario (`rel*ted_stories`).
   - Path esperado *e pruebas.
   - Endpoint /*componente / ADR relacionado si ap*ica.
8. **Detectar placeholders s*n resolver** (`<algo>`, `TODO`, `P*r definir`) fuera de las secciones*don*e son aceptables (Notas y decision*s, Historial).
9. **Generar report*** con severidad por*observación:
   - `crítica` — bloq*ea el uso del UC.
   - `alta` — de** corregirse antes de mergear.
   -*`media` — recomendación fuerte.
  *- `baja* — observación menor.
10. **Determ*nar decisión:**
    - `Válido` — s*n observaciones críticas ni altas.*    - `Requiere ajustes` — hay alt*s o medias sin resolver.
    - `*echazado` — hay críticas o faltan *ecciones obligatorias.

## 6. Vali*aciones

- ✅ Archivo existe y es*Markdown válido.
- ✅ Frontmatter Y*ML bien formado.
- ✅ 11 secciones *bligator*as presentes.
- ✅ Historia en form*to Como/Quiero/Con el fin de.
- ✅ *C en formato GWT correcto.
- ✅*6 escenarios mínimos cubiertos o j*stificados.
- ✅ Trazabilidad compl*ta.
- ✅ Sin placeholders sin resol*er.

##*7. Salidas

- **`reporteValidacion*:**

| Sección | Presente |*Correcta | Observación |
|---|---|*--|---|
| Frontmatter | ✅ | ✅ | — *
|*Historia de usuario | ✅ | ✅ | — |
* Actores | ✅ | ⚠️ | Falta actor se*undario. |
| ... | ... | ... |*... |

- **`checklistEscenarios`:** ver estructura en `analisis-cober*ura.skill.md* §7.
- **`observaciones`** — lista*ordenada por severidad con línea d*l*archivo y recomendación concreta.
* **`decision`** — `Válido` / `Requ*ere ajustes` / `Rechazado`.

## 8* Ejemplos

### Ejemplo: UC rechaza*o

```
Decisión: Rechazado.

Obser*aciones crític*s:
- Falta sección 6 (Criterios de*aceptación).
- AC-01 no incluye En*onces observable — dice "el*sistema responde correctamente" si* código HTTP.

Recomendaciones:
- *egenerar con /generar-caso-de-*so especificando el endpoint.
- Re*mplazar "responde correctamente" p*r*"responde HTTP 200 con arreglo `ti*ulares`".
```

### Ejemplo: UC vál*do

```*Decisión: Válido.

Observaciones:
* (media) AC-05 marcado N/A — asegu*ar justificación en*el propio AC.
- (baja) Sección "No*as y decisiones" vacía; consider*r mover del historial cualquier de*isión relevante.
```

## *. Referencias

- Constitution §2.1*(Spec antes que código), §2.5 (esc*narios mínimos), §2.6 (nomenclatur* de p*uebas).
- `academia/docs/templat*s/UC-template.md`.
- `docs/estanda*es/adr/ADR-002-sdd-tdd.md`.
- Agen*s que lo*componen: `programador-mapi`, `pro*ramador-spa-react`.
- Prompts que *o componen: `/generar-caso-de-uso`*(como verificación posterior).*
---

*Skill versión academic-1.0 · Taller**