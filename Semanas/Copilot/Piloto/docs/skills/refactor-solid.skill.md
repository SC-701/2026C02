---
id: refactor-solid
name: Refactor SOLID
description: Aplica sistemáticamente los 5 principios SOLID a una unidad de código recién creada (fase 🔵 REFACTOR del ciclo TDD), sin romper las pruebas existentes.
scope: transversal
inputs:
  - unidadObjetivo: Ruta al archivo o clase/componente/hook a refactorizar.
  - contextoUC: ID del UC del que proviene la unidad (opcional).
outputs:
  - archivosModificados: Lista de archivos alterados.
  - checklistSolid: Estado de los 5 principios antes y después.
  - suiteVerde: Confirmación de que la suite completa sigue pasando.
used_by_agents: [programador-mapi, programador-spa-react]
used_by_prompts: []
owner: Por definir
version: 0.1
status: activo
governs_by: constitution.md §2.2, §6, §7
---

# 🔵 Skill · Refactor SOLID

## 1. Propósito

Aplicar de forma **sistemática, ordenada y verificable** los 5 principios SOLID sobre una unidad de código recién producida (fase GREEN), garantizando que la suite de pruebas siga pasando y que el diseño mejore sin cambios de comportamiento.

Cumple con la fase **🔵 REFACTOR** del ciclo Red-Green-Refactor obligatorio (Constitution §2.2).

## 2. Cuándo usarlo

- Inmediatamente después de que un test pase en GREEN.
- Antes de abrir un PR, sobre las unidades modificadas.
- Al detectar una violación explícita de SOLID durante revisión de código.
- Al extraer lógica reutilizable (aplica junto con `migrar-hook` en frontend o `agregar-capa` en backend).

## 3. Cuándo NO usarlo

- Si la prueba **no está pasando** (primero completar GREEN).
- Si la suite completa **no está verde antes** de empezar (refactorizar sobre código roto amplifica el problema).
- Sobre código que va a ser eliminado en el mismo PR.
- Para reescrituras estructurales que requieren ADR (usar el ADR primero).

## 4. Entradas

| Nombre | Requerido | Descripción |
|---|---|---|
| `unidadObjetivo` | Sí | Ruta al archivo o identificador de la clase/componente/hook. |
| `contextoUC` | No | ID del UC del que proviene (ayuda a nombrar mejor). |

## 5. Pasos

1. **Ejecutar la suite completa** y confirmar verde antes de empezar.
   - Backend: `dotnet test`.
   - Frontend: `npm run test`.
2. **Aplicar SRP:**
   - Identificar si la unidad tiene más de una razón para cambiar.
   - Si sí, extraer las responsabilidades a unidades independientes.
   - Re-ejecutar la suite.
3. **Aplicar OCP:**
   - Identificar switches por tipo o if/else largos que crecerán con nuevos casos.
   - Reemplazar por composición, estrategias o polimorfismo.
   - Re-ejecutar la suite.
4. **Aplicar LSP:**
   - Verificar que cada implementación cumple el contrato de su interfaz sin sorpresas.
   - Corregir precondiciones más fuertes o postcondiciones más débiles.
   - Re-ejecutar la suite.
5. **Aplicar ISP:**
   - Si hay interfaces gordas donde los consumidores usan solo parte, dividirlas.
   - Re-ejecutar la suite.
6. **Aplicar DIP:**
   - Verificar que las dependencias apuntan a abstracciones, no a concreciones.
   - Backend: mover interfaces necesarias a `Abstracciones`.
   - Frontend: componentes dependen de hooks; services dependen del useRecurso (custom hook del proyecto).
   - Re-ejecutar la suite.
7. **Aplicar Clean Code complementario** (Constitution §7):
   - Métodos ≤ 20 líneas.
   - Máx. 2 niveles de anidamiento.
   - Sin números mágicos.
   - Nombres descriptivos en español.
8. **Ejecutar la suite final** y confirmar verde.
9. **Reportar** el checklist antes/después.

## 6. Validaciones

- ✅ Suite verde **antes** de iniciar.
- ✅ Suite verde **después de cada principio aplicado**.
- ✅ Suite verde **al final** del skill.
- ✅ Sin nuevas dependencias fuera del catálogo de librerías justificadas.
- ✅ Sin cambios en la firma pública salvo que el UC lo permita.
- ✅ Sin cambios de comportamiento observable.

## 7. Salidas

- **`archivosModificados`** — lista de archivos alterados con resumen del cambio.
- **`checklistSolid`** — tabla:

| Principio | Estado inicial | Estado final |
|---|---|---|
| SRP | ✅ / ⚠️ / ❌ | ✅ |
| OCP | ... | ... |
| LSP | ... | ... |
| ISP | ... | ... |
| DIP | ... | ... |

- **`suiteVerde`** — confirmación booleana.

## 8. Ejemplos

### Ejemplo backend — violación de SRP

**Antes:**
```csharp
public class ConsultorTitulares
{
    public IEnumerable<Titular> Consulte(string entidad)
    {
        // 1. Lee de la BD
        // 2. Aplica reglas de negocio
        // 3. Envía email de auditoría
        // 4. Genera PDF
    }
}
```

**Después (SRP aplicado):**
```csharp
public class ConsultorTitulares(IPadronDa da) { /* solo consulta */ }
public class RegistradorAudito*ia(IAuditoriaSg s*) { /* solo audita */ }
public class GeneradorPdfTitul*res(IReportesSg s*) { /* solo genera */ }
```

### Ejemplo frontend — vi*lación de SRP

**Antes:** `ListaTi*ulares.tsx` hace fet*h, mantiene estado async y renderi*a.

**Después:**
- `use-*onsulta-titulares.ts` (hook — esta*o async).
- `ListaTitulares.tsx` (*omponente presentac*onal).
- `titulares.service.ts` (l*amada al useRecurso (custom hook del proyecto)).*
## 9. Referencias

- Constitution*§2.2 *ciclo Red-Green-Refactor), §6 (SOL*D), §7 (Clean Code).
- Robert C. M*rtin — *Cl*an Architecture* y *Clean Code*.
-*Martin Fowler — *Refactoring*.
- A*ents que l* componen: `programador-mapi`, `pr*gramador-spa-react`.

---

*Skill *ersión academic-1.0 · Taller