---
agent: true
description: Genera un componente React funcional en TypeScript siguiendo las 11 reglas duras del frontend, con tipado estricto, nomenclatura del taller y estructura feature-based.
tools: [codebase, editFiles]
owner: Por definir
version: 0.1
status: activo
scope: frontend
governs_by: constitution.md §4, ADR-Frontend-001, ADR-Frontend-002
---

# Prompt · Generar componente funcional React

## Objetivo
Crear un componente React funcional (`.tsx`) que respete estrictamente la Constitution §4 y las 11 reglas duras del `copilot-instructions.md` del frontend.

## Entradas
- **Nombre del componente:** `${input:nombreComponente:PascalCase en español, ej. ListaTitulares}`
- **Feature al que pertenece:** `${input:feature:Nombre del feature, ej. titulares}`
- **Tipo de componente:** `${input:tipo:presentacional|contenedor|vista}`
- **Props esperados:** `${input:props:Descripción libre de los props que recibe el componente}`
- **Caso de uso asociado:** `${input:ucId:ID del UC, ej. UC-001}`

## Contexto obligatorio a considerar
- Constitution §4 (arquitectura frontend), §5.2 (nomenclatura), §6 (SOLID), §7 (Clean Code).
- ADR-Frontend-001 (React funcional + TS estricto).
- ADR-Frontend-002 (lista blanca de dependencias).
- `.github/copilot-instructions.md` (11 reglas duras).
- Componentes existentes en `src/features/${input:feature}/components/` para consistencia.

## Instrucciones para Copilot

1. **Determiná la ubicación del archivo** según el tipo:
   - **Presentacional:** `src/features/${input:feature}/components/${input:nombreComponente}.tsx`.
   - **Vista:** `src/features/${input:feature}/views/Vista${input:nombreComponente}.tsx`.
   - **Contenedor:** `src/features/${input:feature}/views/${input:nombreComponente}.tsx` (compone hooks + presentacionales).

2. **Generá el componente respetando las 11 reglas duras:**
   - **Función**, no clase (excepto `ErrorBoundary`).
   - **Sin `any`**; usar `unknown` + estrechamiento cuando aplique.
   - **Sin `React.FC`**; tipar props con `interface Propiedades${input:nombreComponente}` en la firma.
   - Si maneja estado asíncrono → **discriminated union** `inicial | cargando | exito | error`.
   - **Solo imports** de la lista blanca (`react`, `react-router-dom`, librerías open-source justificadas con ADR).
   - **HTTP** siempre vía el custom hook useRecurso<T>() del proyecto (nunca `fetch`/`axios` directo).
   - **Formularios** siempre con el useState + useReducer nativo.
   - **Grids** siempre con el componente propio del equipo.
   - **Un archivo, un componente**, máximo ~150 líneas — si excede, extraer subcomponentes/hooks.
   - **Nombres en español**; handlers con `maneje`; callbacks-props con `al`.
   - **Sin `console.log`** ni código muerto.

3. **Estructura del archivo:**

```tsx
// Imports (solo lista blanca)

// Interface de props
interface Propiedades${input:nombreComponente} {
  // ... con `es`, `tiene`, `debe` para booleanos
  // callbacks con prefijo `al`
}

// Componente
function ${input:nombreComponente}({
  // destructuring con defaults explícitos
}: Propiedades${input:nombreComponente}) {
  // hooks (useState, useReducer, useContext, custom hooks)
  // handlers con prefijo `maneje`
  // render con early returns por estado
}

export default ${input:nombreComponente};
```

4. **SRP (Constitution §6.1):**
   - Si el componente necesita fetching + estado + UI → separar en 3: custom hook (estado), service (fetch vía manejador), componente (solo render).
   - Si es una vista, componer hooks y componentes presentacionales; no incluir lógica en la vista.

5. **Referenciá el UC en un comentario superior:** `// Componente asociado a ${input:ucId}`.

6. **Sugerí en el chat:**
   - Si el componente requiere un custom hook adicional, invocar `/generar-custom-hook`.
   - Si requiere pruebas, invocar `/generar-prueba-desde-ac`.

## Reglas duras
- **No agregues** dependencias fuera del catálogo de librerías justificadas.
- **No uses** `useEffect` con dependencias vacías salvo justificación en comentario.
- **No hardcodees** URLs, strings de UI ni configuraciones — usar `core/config/` o props.
- **Todos los props booleanos con prefijo** `es`, `tiene`, `debe`.
- **Todos los handlers-callbacks con prefijo** `al` (`alGuardar`, `alCambiar`).
- **Todos los handlers internos con prefijo** `maneje`.

## Salida esperada
- Archivo `.tsx` creado en la ubicación correcta.
- Interface de props exportada si otros componentes la consumen.
- Sugerencias de pruebas asociadas y de custom hooks necesarios.

## Referencias
- `academia/docs/constitution.md` §4, §5.2, §6, §7
- `academia/docs/adr/ADR-Frontend-001-react-funcional.md`
- `academia/docs/adr/ADR-Frontend-002-lista-blanca-dependencias.md`
- `.github/copilot-instructions.md`
