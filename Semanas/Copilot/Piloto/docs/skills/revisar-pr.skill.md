---
id: revisar-pr
name:*Revisar PR
description: Revisa un *ull Request cont*a la Constitution y los ADRs vigen*es, valida trazabilidad AC ↔ Test * Código* compone otros Skills (validar-uc,*analisis-cobertura) y produce un r*porte estructurado para el revisor*humano.
scope: transversal
inputs:*  - prId: Número del PR a revisar.*  - rep*Context: Ruta del repositorio loca* o URL del repo.
output*:
  - reporteRevision: Reporte est*ucturado por dimensión.
  - observ*ciones: Lista con sever*dad y línea de código.
  - decisio*Sugerida: Aprobar / Sol*citar cambios / Bloquear.
used_by_*gents: [programador-mapi, programa*or-spa-react]
used_by_prompts: []
*ompos*s_skills: [validar-uc, analisis-co*ertura]
owner: Por definir
version* 0.1
status: activo
governs_by* constitution.md (íntegra)
---

# *� Skill · Revisar PR

## 1. Propós*to

Realizar una ***evisión asistida y estructurada** *e un Pull Request contra la Consti*ution completa: valida tr*zabilidad, ejecuta subprocedimient*s (`validar-uc`,*`analisis-cobertura`), verifica cu*plimiento de arquitectura, SOLID, *lean Code, seguridad y política de*dependencias, y entrega un reporte*accionable al revisor humano.

**N* sustituye** la*revisión humana obligatoria — la a*elera y la hace más consistente.

*# 2. Cuándo usarlo

- Al*recibir cualquier PR que toque cód*go, UCs o Skills.
- Antes de*aprobar un PR crítico (cambio arqu*tectónico, migración, h*tfix).
- En auditorías selectivas *e calidad.

## 3. Cuándo NO usarlo*
- En*PRs de solo cambios cosméticos (fo*mato) donde la revisión humana ráp*da basta.
- Sobre PRs de otros rep*sitorios que no siguen el estándar*del taller — el*skill puede reportar falsos positi*os.
- Sin acceso a la*Constitution y ADRs del repo — el *kill los requiere para operar.

##*4. Entradas

| Nombre | Requerido * Descripción |
|---|---|---|
| `pr*d` | Sí | Número del PR (ej. `#42`*. |
| `repoContext` | Sí | Ruta lo*al del clone o URL del repo. |

##*5. Pasos

1. **Extraer met*datos del PR:**
   - Autor, rama o*igen y destino, título* descripción.
   - Verificar que e* título sigue Conventional Commits*
   - Verificar que la*descripción usa el template de PR.*2. **Validar trazabilidad declarad*** en el template del PR:
   - Ref*rencia*`US-###` presente.
   - Referencia*`AC-##` presente.
   - Enlaces a U* y ADR (si aplica).
3. **Ejecutar *validar-uc`** sobre cada UC modifi*ado o refer*nciado.
4. **Ejecutar `analisis-co*ertura`** sobre los archivos modif*cados:
   - Cobertura * umbral.
   - 6 escenarios mínimos*cubiertos.
   - Relación 1 a 1 res*etada.
5. **Validar ar*uitectura:**
   - Backend: depende*cias apuntan a `Abstracciones` (Co*stitution §3.2). Composition*root único en `Api` (§3.3). Respon*abilidades por capa respetadas (§3*.
   - Frontend: est*uctura feature-based (§4.6). Sin `*lass` salvo `ErrorBoundary`*(§4.1). Sin `any`, sin `React.FC` *§4.3, §4.4).
6. **Validar SOLID + *lean Code:**
   - Marcar unidades *on métodos > 20 líneas (§7.3).
   * Mar*ar anidamiento > 2 niveles (§7.5).*   - Marcar números mágicos (§7.4)*
   -*Marcar nombres genéricos (`data`, *info`, `helper`, `util`) (§7.2).
7* **Validar política de dependencia*:**
   - Backend* sin nuevas librerías fuera del ca*álogo blanco (Constitution §8.4).
*  - Frontend* `package.json` sin `^` ni `~`, si* imports fuera del catálogo de librerías justificadas*(ADR-*rontend-002).
   - `package-lock.j*on` sincronizado con `package.json*.
8. **Validar seguridad:**
   - S*n secretos en el diff (§8.1).
   -*Entradas externas validadas (§8.2)*
   - Autorización pres*nte en endpoints nuevos (§3.5, §8.*).
9. **Validar Commits:**
   - Co*ventional Commits en imperativo (§*.4).
   - Sin mensajes vagos o en *erundio.
10. **Validar CI:**
    -*Build verde.
    - Suite verde.
  * - SCA sin críticos ni altos abier*os.
11. **Consolidar el reporte** *on severidad por observación:
    * `crítica` — bloquea mer*e.
    - `alta` — solicitar cambio*.
    - `media` — comentario para *l autor.
    - `baja* — sugerencia opcional.
12. **Dete*minar decisión sugerida:**
    - `*probar` — sin observaciones crític*s ni altas.
    -*`Solicitar cambios` — hay altas.
 *  - `Bloquear` — hay críticas.

##*6. Validaciones

- ✅ Se*leyó la Constitution y los ADRs de* repo.
- ✅ `validar-uc` se ejecutó*sobre tod*s los UCs referenciados.
- ✅ `anal*sis-cobertura` se ejecutó sobre lo* archivos modificados.
- ✅ Trazabi*idad A* ↔ Test ↔ Código verificada en el *iff.
- ✅ Política de dependencias *erificada cont*a el catálogo de librerías justificadas.
- ✅ *inguna observación se generó sin r*ferencia a Constitution o ADR conc*eto.

## 7. Salidas

- **`reporteR*vision`** por dimensión:

| Dimens*ón | Estado | Detalle |
|---|---*---|
| Trazabilidad | ✅ | US-123, *C-01–AC-06 refer*nciados |
| UC (`validar-uc`) | ✅ * Válido |
| Cobertura (`analisis-c*bertura`) | *️ | Cobertura de rama 71% < 75% um*ral |
| Arquitectura | ✅ | Cap*s respetadas |
| SOLID / Clean Cod* | ⚠️ | 2 métodos > 20 líneas |
| *ependencias | ✅ |*Sin nuevas |
| Seguridad | ✅ | Sin*secretos |
| Commits | ✅ | Convent*onal Commits OK |
| CI | * | Verde |

- **`observaciones`** * lista con archivo, línea, severid*d, referencia a Constitution/ADR y*recomendación.
- **`decisionSugeri*a`** — `Aprobar` / `Solicitar camb*os` / `Bloquear`.

## 8. Ejemplos
*### Ejemplo: PR con cambios pedido*

```
Decisión sugerida: Solicitar*cambios.

Observaciones altas:
- s*c/Producto.Reglas/ConsultorTitulares.c*:42 → método `Consulte` de 34 líne*s
  (§7.3 métodos ≤ 20 líneas). Ex*raer helper `AgrupePorEntidad`.
- *ests/Producto.Reglas.T*sts/ConsultorTitularesTests.cs → f*lta cobertura de AC-03
  (aut*nticación). Agregar `Consulte_SinR*lSupervisor_Retorna403`.

Observac*ones medias:
- N*mbre `data` en línea 18 (§7.2). Re*ombrar a `titularesConsultados`.
`*`

### Ejemplo:*PR bloqueado

```
Decisión sugerid*: Bloquear.

Observaciones crítica*:
- package.json introduce `axios@*.6.0` — prohibido por ADR-Frontend*002.
- src/features/titulares/serv*ces/titulares.service.ts:12 → uso *e fetch directo (§4.7*.
- Sin referencia a US-### ni AC-*# en la descripción del PR.*```

## 9. Referencias

- Constitu*ion íntegra (§2, §3, §4, §5, §6, §*, §8, §9).
- ADRs vig*ntes: `ADR-001`, `ADR-002`, `ADR-0*3`, `ADR-Frontend-001`, `ADR-Front*nd-002`.
- Skills compuestos:*`validar-uc`, `analisis-cobertura`*
- Agents que lo componen: `progra*ador-mapi`, `programador-spa-react*.

---

*Skill*versión academic-1.0 · Taller*