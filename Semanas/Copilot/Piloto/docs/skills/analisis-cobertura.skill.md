---
id: analisis-cobertura
na*e: Análisis de Cobertura
descripti*n:*Audita la cobertura de pruebas de *n cambio y valida que los 6 escena*ios m*nimos por UC (Constitution §2.5) e*tén cubiertos con al menos una pru*ba cada uno.
scope: transversal
in*uts:*  - alcance: Archivo, directorio o*rama a anal*zar.
  - ucId: UC contra el cual a*ditar (opcional).
  - umbralM*nimo: Porcentaje mínimo de cobertu*a de línea/rama (opcional; toma de* CI si no se*pasa).
outputs:
  - reporteCobertu*a: Porcentaje total y por archivo.*  - checklistEscenarios: Est*do de los 6 escenarios mínimos por*AC.
  - gaps: Lista de pruebas fal*antes con recomendación.
  - dec*sion: Aprobado / bloquea PR /*requiere aprobación explícita.
use*_by_agents: [programador-mapi, pro*ramador-spa-react]
used_by_prompts* []
owner: Por definir
version:*0.1
status: activo
governs_by: con*titution.md §2.3, §2.4, §2.5
---

* 📊 Skill · Análisis de*Cobertura

## 1. Propósito

Audita* de forma sistemática la cobertura*de pruebas de un cambio o r*ma, y garantizar que los **6 escen*rios mínimos por UC** (Constitutio* §2.5) tienen al*menos una prueba cada uno. Bloquea*la apertura de PR cuando no se cum*l*n los mínimos.

## 2. Cuándo usarl*

- **Antes de abrir cualquier PR** (paso obligatorio del fl*jo TDD).
- Como parte de la revisi*n de código, para confirmar la rel*ción 1 * 1 (Constitution §2.3).
- Después *e un refactor que pudo haber movid* código s*n pruebas.
- Como parte de auditor*as periódicas del repo.

## 3. Cuá*do NO usarlo

- Como sustitu*o de la revisión humana del PR.
- *ara justificar mergear con c*bertura por debajo del umbral sin *DR.
- En cambios exclusivamente co*méticos (formato, com*ntarios, renombres) que no alteran*comportamiento.

## 4. Entradas

|*Nombre | Requerido |*Descripción |
|---|---|---|
| `alc*nce` | Sí | Archivo, directorio o *ama a analizar. |
| `ucId` | No*| UC contra el cual mapear los AC.*Si no se pasa, se infiere del cont*x*o del PR. |
| `umbralMinimo` | No * Porcentaje mínimo. Si no se pasa,*toma el definido en el*CI del repo. |

## 5. Pasos

1. ***jecutar la suite con cobertura** e* el alcance sol*citado.
   - Backend: `dotnet test*--collect:"XPlat Code Coverage"`.
*  - Frontend: `npm run test -* --coverage`.
2. **Extraer métrica* globales**: cobertura de línea, d* rama y por*archivo modificado.
3. **Comparar *ontra el umbral mínimo** del CI. S* no se al*anza, marcar `decision = bloquea P*`.
4. **Cargar el UC** referenciad* (`docs/use-cases/${ucId}*.md`).
5* **Mapear cada AC** del UC con las*pruebas existentes:
   - Bu*car comentarios `// AC-##` o `it('*..')` que referencien el AC.
   - *egist*ar si hay al menos 1 prueba por AC*
6. **Validar cobertura de los 6 e*cenarios mínimos** (Constitution §*.*):
   - Éxito · Validación · Auth * No encontrado · Idempotencia · F*llo dependencia externa.
7. **Dete*tar unidades públicas sin pruebas**:
   - Back*nd: clases/métodos públicos sin te*ts que los referencien.
   - Front*nd: componentes/hooks exportados s*n tests.
8. **Generar re*orte** con gaps y recomendaciones *oncretas.
9. **Determinar decisión**:
   - `Aprobado` — cumple um*ral y los 6 escenarios están cubie*tos.
   - `Requiere aprobación exp*ícita` — cumple umbral p*ro falta 1 escenario con justifica*ión N/A.
   - `Bloquea PR` — no cu*ple umbral o*faltan escenarios sin justificar.
*## 6. Validaciones

- ✅ La suite c*mpleta ejecutó sin errores.
- ✅ Se*cargó correctamente el UC referenc*ado.
- ✅ Todo AC del UC tiene mape* (existente o registrado como gap)*
- ✅ Los 6 escenarios mínimos está* cubiertos o marcados como N/A jus*ificado.
- ✅ El umbral de cobertur* del CI se respetó.

## 7. Salidas*
- **`reporteCobertura`:**
  - Tot*l línea: `##%`
  - Total rama: `##*`
  - Detalle por archivo.
- **`ch*cklistEscenarios`:**

| Escenario *ínimo | AC referenciado | Prueba(s* | Estado |
|---|---|---|---|
| Éx*to | AC-01 | `MetodoTests.Consulte*ConEntidadesActivas_...` | ✅ |
| V*lidación | AC-02 | ... | ✅ |
| Aut* | AC-03 | ... | ⚠️ gap |
| No enc*ntrado | AC-04 | ... | ✅*|
| Idempotencia | AC-05 | N/A jus*ificado: método consulta pura | * |
| Fallo dep. externa | AC-06 | *.. | ✅ |

- **`gaps`** — lista con*recomendación concreta por*gap.
- **`decision`** — `Aprobado`*/ `Requiere aprobación explícita` * `Bloquea PR`.

## 8. *jemplos

### Ejemplo: PR con gap c*ítico

```
Reporte:*- Cobertura línea: 82% (umbral 80%* ✅
- Cobertura rama: 71% (umbral 7*%) *
- AC-03 (autenticación) sin prueb*.

Decisión: Bloquea PR.

Recomend*ción:
- Agregar test `Consulte_S*nRolSupervisor_Retorna403()` para *C-03.
- Aumentar cobertura de*rama en `ConsultorTitulares.Consul*e` (branches no cubiertas: ent*dad nula).
```

### Ejemplo: PR ap*obado

```
Reporte:
- Cobertura lí*ea: 91% ✅
- C*bertura rama: 87% ✅
- Los 6 escena*ios cubiertos (AC-05 marcado N/A j*stificado en*UC-001).

Decisión: Aprobado.
```
*## 9. Referencias

- Constitution *2.3 (relación 1 a 1), §2.4 (*obertura mínima), §2.5 (escenarios*mínimos).
- `academia/docs/adr/A*R-002-s*d-tdd.md`.
- Agents que lo compone*: `programador-mapi`, `programador*spa-react`.
- Complementa a* `revisar-pr` (que lo invoca como *arte de*la revisión).

---

*Skill versión*0.1 · Taller*