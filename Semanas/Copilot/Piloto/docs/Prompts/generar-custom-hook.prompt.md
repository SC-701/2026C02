---
mode: agent
description: Genera un custom hook de React en TypeScript con nomenclatura kebab-case, tipado estricto, discriminated union para estados asíncronos y respetando las reglas duras del frontend.
tools: [codebase, editFiles]
owner: Por definir
version: 0.1
status: activo
scope: frontend
governs_by: constitution.md §4.2, §4.5, §6, ADR-Frontend-001, ADR-Frontend-002
---

# Prompt · Generar custom hook React

## Objetivo
Crear un custom hook (`use-<nombre>.ts`) que encapsule lógica reutilizable siguiendo la Constitution §4.2 y §4.5.

## Entradas
- **Nombre del hook (sin prefijo `use`):** `${input:nombreHook:kebab-case, ej. consulta-titulares}`
- **Feature al que pertenece:** `${input:feature:Nombre del feature, ej. titulares (o "shared" para transversal)}`
- **Propósito del hook:** `${input:proposito:Qué encapsula, ej. Consulta titulares por lista de entidades}`
- **Tipo de hook:** `${input:tipo:estado-simple|estado-async|estado-derivado|efecto-suscripcion}`
- **Contrato de retorno esperado (opcional):** `${input:contrato:Descripción libre del valor de retorno}`

## Contexto obligatorio a considerar
- Constitution §4.2 (custom hooks), §4.5 (discriminated union), §6 (SOLID), §7 (Clean Code).
- ADR-Frontend-001 (React funcional + TS estricto).
- ADR-Frontend-002 (lista blanca de dependencias).
- `.github/copilot-instructions.md` (11 reglas duras).
- Hooks existentes en `src/features/${input:feature}/hooks/` o `src/shared/hooks/`.

## Instrucciones para Copilot

1. **Determiná la ubicación:**
   - Específico de un feature: `src/features/${input:feature}/hooks/use-${input:nombreHook}.ts`.
   - Transversal: `src/shared/hooks/use-${input:nombreHook}.ts`.

2. **Nombre del hook** en el código: `use${PascalCase(nombreHook)}` (ej. `useConsultaTitulares`).

3. **Estructura por tipo de hook:**

### `estado-simple`
```ts
import { useState } from 'react';

export function use${PascalCase(nombreHook)}(/* params tipados */) {
  const [estado, setEstado] = useState<Tipo>(/* inicial */);
  // handlers con `maneje`
  return { estado, /* setters expuestos */ } as const;
}
```

### `estado-async` (Constitution §4.5)
```ts
import { useEffect, useState } from 'react';

type EstadoRecurso<T> =
  | { estado: 'inicial' }
  | { estado: 'cargando' }
  | { estado: 'exito'; datos: T }
  | { estado: 'error'; mensaje: string };

export function use${PascalCase(nombreHook)}<T>(/* params */*: EstadoRecurso<T> {
  const [estado, setEstado] = useState<EstadoRec*rso<T>>({ estado: 'inicial' });*
  useEffect(() => {
    let cance*ado = false;
    setEstado({ estad*: 'cargando' });
    // usar useRecurso<T>() del proyecto (sin fetch/axios directo)
    consultarApi.get<T>(/* url */)
      .then(datos => { if *!cancelado) setEstado({ estado: 'e*ito', datos }); })
      .catch(e *> { if (!cancelado) setEstado({ es*ado: 'error', mensaje: e.message }*; });
    return () => { cancelado*= true; };
  }, [/* deps */]);

  *eturn estado;
}
```

### `estado-d*rivado`
```ts
import { use*emo } from 'react';

export function use${PascalCase(nombreHook)}(/* params */) {
  const derivado = us*Memo(() => {
    // cál*ulo puro
  }, [/* deps */]);
  ret*rn derivado;
}
```

### `efecto-su*cripcion`
```ts
import { useEffect*}*from 'react';

export function use${PascalCase(nombreHook)}(/* params */) {
  useEffect(() => {
 *  // suscripción
    return*() => {
      // cleanup obligator*o
    };
  }, [/* deps */]);
}
```*
4. **Reglas comunes:**
   - ***ipado estricto:** parámetros y ret*rno explícitamente tipados; sin `a*y`.
   - **Sin efectos con array d* dependencias vacío** salvo justif*cación en comentario*
   - **Cleanup obligatorio** en `*seEffect` que suscribe / abre time*s / h*ce fetch.
   - **Retorno como obje*o `as const`** cuando expone múlti*les valores para*preservar tipos literales.
   - ***o importar** paquetes fuera del ca*álogo blanco (*DR-Frontend-002).
   - **Nombres e* español** para variables y funcio*es internas.

5. **SRP (Const*tution §6.1):**
   - Un hook = un *ropósito.
   - Si crece más de *80 líneas, descomponerlo en hooks *ás pequeños que este componga.

6.***Documentá** con JSDoc breve:
   - Propósito.*   - Parámetros y tipos.
   -*Valor de retorno.
   - Ejemplo mín*mo de uso.

## Reglas duras
- **HT*P** siempre vía el manejador insti*ucional — nunca `fetch` / `axios` *irecto.
- **Sin librerías** de fet*hing externo (`react-query`, `swr`* — usar el patrón `EstadoRecurso<T*`.
- **Sin `any`** — usar `unknown* + estrechamiento.
- **Prefijo `us*`** obligatorio en el nombre del h*ok (regla ya validada por el linte* de React).
- **Un hook = un archi*o** con nombre kebab-case.
- **Ret*rno tipado** — no dejar que TypeSc*ipt infiera `any` implícito.

## S*lida esperada
- Archivo `use-${inp*t:nombreHook}.ts` creado.
- Tipos *xportados*si otros archivos los consumen (`E*tadoRecurso<T>`, tipos del contrat* de retorno).
-*Sugerencias en el chat:
  - Prueba*unitaria con `renderHook` — invoca* `/generar-*rueba-desde-ac`.
  - Componente qu* lo consuma — invocar `/generar-co*ponente-funcional`.

## Referencia*
- `academia/docs/constitution*md` §4.2, §4.5, §6, §7
- `docs/est*ndares/adr/ADR-Frontend-001-react-*uncional.md`
- `academia/docs/ad*/*DR-Frontend-002-lista-blanca-depen*encias.md`
- `.github/copilot-inst*uctions.md`