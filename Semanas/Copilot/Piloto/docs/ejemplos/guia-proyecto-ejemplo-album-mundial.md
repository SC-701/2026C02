---
title: Proyecto ejemplo — Álbum del Mundial (Control de Postales)
type: walkthrough
audience: [Desarrolladores, Docentes del taller, Nuevos integrantes]
version: 0.1
status: activo
last-reviewed: 2026-07-06
related: [copilot-estrategia.md, constitution.md, guia-de-uso.md, ADR-001..ADR-Frontend-002]
producto: AlbumMundial
repos:
  - AlbumMundial.Api  (backend C#)
  - AlbumMundial.SPA  (frontend React + TS)
---

# ⚽ Walkthrough completo · Álbum del Mundial

> **Objetivo:** aterrizar en un proyecto real y ejecutable todos los artefactos del Taller. Al terminar esta guía habrás recorrido el flujo completo: setup → historia → UC → ciclo TDD → PR → workflows automáticos → merge.

---

## 📌 Contexto del proyecto

Sistema para controlar las postales del álbum del mundial. Un coleccionista puede:

- Registrar las postales que **posee**.
- Marcar postales como **repetidas** para intercambio.
- Consultar las postales **faltantes**.
- Ver estadísticas de progreso de la colección.

**Dominio simple**, familiar y con reglas claras — ideal para mostrar el flujo end-to-end.

---

## 🎯 Alcance de este walkthrough

Vamos a recorrer **una única historia de usuario completa** para mostrar cada paso del ciclo. Al final, se listan las historias restantes que quedan como ejercicio.

**Historia elegida:** *US-001 · Registrar una postal en la colección*.

Cubriremos:
- Setup de los 2 repositorios.
- Documentos previos mínimos (visión + un ADR de dominio).
- Historia US-001, UC-001 con criterios GWT.
- Ciclo TDD completo en backend (6 capas).
- Ciclo TDD completo en frontend (feature-based).
- PR con los reportes automáticos de los workflows.
- Merge.

---

## 🗺️ Mapa del walkthrough

```
Fase 0 · Setup de los 2 repos                         (30 min)
   ↓
Fase 1 · Documentos previos mínimos                   (20 min)
   ↓
Fase 2 · Historia US-001                              (10 min)
   ↓
Fase 3 · Caso de uso UC-001 + validación              (15 min)
   ↓
Fase 4 · Backend — ciclo TDD para AC-01               (45 min)
   ↓
Fase 5 · Backend — cubrir los demás AC                (60 min)
   ↓
Fase 6 · Frontend — hook + componente + vista         (60 min)
   ↓
Fase 7 · PR + reportes automáticos                    (15 min)
   ↓
Fase 8 · Merge                                        (5 min)
```

---

## Fase 0 · Setup de los 2 repositorios

### 0.1 Crear el repo del backend

En GitHub → **"Use this template"** sobre `SC-701/Template.API`:

- **Nombre:** `AlbumMundial.Api`
- Organización: la del taller.
- Visibilidad: privada.

### 0.2 Crear el repo del frontend

Análogamente, desde `SC-701/Template.SPA`:

- **Nombre:** `AlbumMundial.SPA`

### 0.3 Clonar los repositorios

```bash
# Backend
git clone <url> AlbumMundial.Api

# Frontend
git clone <url> AlbumMundial.SPA
```

### 0.4 Crear los proyectos del producto

Los templates tienen `src/` vacío. El alumno crea sus proyectos con el nombre de su dominio:

```bash
# Backend — crear solución y capas en src/
cd AlbumMundial.Api
dotnet new sln -n AlbumMundial
dotnet new classlib -n AlbumMundial.Abstracciones -o src/AlbumMundial.Abstracciones -f net8.0
dotnet new classlib -n AlbumMundial.Flujo            -o src/AlbumMundial.Flujo            -f net8.0
dotnet new classlib -n AlbumMundial.Reglas            -o src/AlbumMundial.Reglas            -f net8.0
dotnet new classlib -n AlbumMundial.Servicios            -o src/AlbumMundial.Servicios            -f net8.0
dotnet new classlib -n AlbumMundial.AccesoDatos            -o src/AlbumMundial.AccesoDatos            -f net8.0
dotnet new webapi   -n AlbumMundial.Api           -o src/AlbumMundial.Api           -f net8.0 --use-controllers
dotnet sln add src/**/*.csproj
```

```bash
# Frontend — iniciar el proyecto Vite en src/
cd AlbumMundial.SPA
npm create vite@latest . -- --template react-ts
```

Verificar que compilan:

```bash
# Backend
cd AlbumMundial.Api && dotnet restore && dotnet build

# Frontend
cd AlbumMundial.SPA && npm ci && npm run build
```

### 0.5 Verificar personalización de Copilot

Confirmar que cada repo tiene:

```
.github/
  ├── copilot-instructions.md      ← reglas activas
  ├── instructions/                ← path-specific
  ├── prompts/                     ← 6 prompts críticos
  ├── agents/                      ← programador-mapi, programador-spa-react, analista-requisitos
  ├── skills/                      ← 5 skills críticos
  └── workflows/                   ← 5 workflows agentic + CI + SCA
.specify/memory/constitution.md    ← ley suprema
docs/
  ├── templates/
  ├── adr/
  ├── stories/
  └── use-cases/
src/                               ← vacío; el alumno crea sus proyectos aquí (paso 0.4)
```

**Backend commit:** `chore: bootstrap AlbumMundial.Api desde SC-701/Template.API`
**Frontend commit:** `chore: bootstrap AlbumMundial.SPA desde SC-701/Template.SPA`

---

## Fase 1 · Documentos previos mínimos

Según la Constitution §5.1 (backend) y la matriz del maestro §5.1, para un **producto nuevo estándar** necesitamos:

- ✅ Visión (una página).
- ✅ Constitution (ya viene precargada — no tocar).
- ✅ ADR de dominio si hay una decisión estructural específica.
- ✅ Casos de uso (US + UC + AC).

No necesitamos C4 completo porque el dominio es acotado.

### 1.1 Redactar la visión

**Backend:** `docs/vision/vision.md`

```markdown
---
title: Visión — AlbumMundial
version: 0.1
status: activo
---

# Visión · Álbum del Mundial

## Problema
Los coleccionistas del álbum del mundial pierden control de qué postales
tienen, cuáles les faltan y cuáles son repetidas. El registro manual
(cuaderno, Excel) es propenso a errores y no facilita el intercambio.

## Usuarios
- **Coleccionista** — persona que compila su álbum y busca completarlo.

## Propuesta de valor
Una aplicación que permite:
1. Registrar las postales poseídas.
2. Marcar repetidas para intercambio.
3. Ver de un vistazo el progreso y las faltantes.

## Métricas de éxito
- Tiempo promedio para registrar una postal < 5 s.
- Porcentaje de coleccionistas que completan el álbum ≥ 70 %.
- Cero pérdidas de datos.
```

**Frontend:** referencia al mismo documento del backend en su README (single source of truth).

**Commit backend:** `docs: agregar visión del producto`.

### 1.2 ADR de dominio

Hay una decisión estructural que necesitamos fundamentar: **el catálogo de postales es fijo (contiene todas las postales que Panini emitió) y viene precargado como semilla**. Esto merece un ADR corto.

**`docs/adr/ADR-004-catalogo-postales-como-semilla.md`**

Usá el template `ADR-template.md` y completá:

```markdown
---
adr_id: ADR-004
title: Catálogo de postales como datos de semilla (seed)
status: propuesto
date: 2026-07-06
---

## 2. Contexto
El álbum del mundial tiene un conjunto finito y conocido de postales
(≈670 en la última edición). Este conjunto no cambia durante la vida
útil del sistema.

## 3. Decisión
El catálogo se carga como **datos de semilla** en la base de datos al
desplegar el sistema. No se expone endpoint de escritura sobre el
catálogo; solo endpoint de lectura.

## 4. Alternativas
| Alt | Pros | Contras | ¿Descartada? |
|---|---|---|---|
| A. Catálogo editable vía API | Flexibilidad | Riesgo de corrupción | Sí |
| B. Catálogo como seed inmutable ✅ | Simplicidad, integridad | Requiere redeploy si Panini emite nuevas | No |
| C. Catálogo en archivo estático servido por CDN | Ligero | Sin queries | Sí |

## 5. Consecuencias
- ✅ Integridad garantizada.
- ✅ Consultas simples y rápidas.
- ⚠️ Si Panini emite postales especiales, requiere redeploy del seed.
```

**Commit:** `docs: agregar ADR-004 catálogo como semilla`.

---

## Fase 2 · Historia US-001

### 2.1 Generar la US con Copilot

Con el agente `analista-requisitos` activo en VS Code:

```
@analista-requisitos
/generar-historia-de-usuario
```

Copilot te pedirá los parámetros. Respondé:

- **nombreUS:** `registrar-postal-poseida`
- **epicFeature:** `Gestión de colección`
- **actor:** `Coleccionista`
- **capacidad:** `Registrar una postal que acabo de conseguir`
- **beneficio:** `Llevar el control preciso de mi colección`
- **contexto:** `El catálogo es fijo (1..670 postales, ADR-004). Registrar dos veces la misma postal la marca como repetida.`

Copilot generará `docs/stories/US-001-registrar-postal-poseida.md` con las **10 secciones** del template e invocará el skill `validar-us` automáticamente al finalizar. Salida esperada:

```
Decisión: Lista.
Criterios INVEST: 6/6 marcados.
Criterios de aceptación de alto nivel: 4 criterios observables.
Sin placeholders sin resolver.
```

El archivo generado `docs/stories/US-001-registrar-postal-poseida.md`:

```markdown
---
id: US-001
title: Registrar una postal en mi colección
status: refinada
owner: Por definir
size: S
priority: alta
related_uc: [UC-001]
related_epic: Gestión de colección
tags: [coleccion, registro]
version: 0.1
last-reviewed: 2026-07-12
---

# US-001 · Registrar una postal en mi colección

## 1. Historia de usuario
**Como** coleccionista
**Quiero** registrar una postal que acabo de conseguir
**Con el fin de** llevar el control preciso de mi colección

## 2. Valor de negocio
- Es la acción más frecuente del usuario; sin ella ninguna otra funcionalidad tiene sentido.
- Permite detectar postales repetidas en tiempo real, habilitando el flujo de intercambio.

## 3. Criterios INVEST
- [x] **Independiente** — no depende del orden con otra historia.
- [x] **Negociable** — el mecanismo exacto de duplicidad puede discutirse.
- [x] **Valiosa** — base de toda la funcionalidad del álbum.
- [x] **Estimable** — el equipo puede estimarla en una sesión.
- [x] **Small** — cabe en una iteración.
- [x] **Testable** — se puede validar con número, estado y cantidad.

## 4. Criterios de aceptación de alto nivel
- [ ] Puedo registrar una postal por su número (1..670).
- [ ] Si ya la tengo, el sistema me indica que es repetida y actualiza la cantidad.
- [ ] Recibo confirmación inmediata con el estado actual de la postal.
- [ ] La postal registrada se refleja en las consultas posteriores.

## 5. Casos de uso asociados

| ID | Título | Estado |
|---|---|---|
| UC-001 | Registrar postal poseída | sugerido |

## 6. Restricciones y supuestos
- El catálogo de postales es inmutable (ADR-004); el número debe existir en el seed.
- La autenticación es obligatoria; un coleccionista solo gestiona su propia colección.

## 7. Fuera de alcance
- Registro masivo (carga de un lote de postales de una sola vez).
- Edición o eliminación de una postal ya registrada.

## 8. Dependencias
- **Depende de:** catálogo de postales cargado como seed (ADR-004).
- **Es dependencia de:** US-002 (Marcar postal como repetida), US-003 (Consultar faltantes).

## 9. Notas de refinamiento
- ¿El número máximo de postales es 670 fijo o varía por edición del mundial?
- ¿Debe emitirse un evento de dominio `PostalRegistrada`? (impacta AC-01 del UC-001).

## 10. Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-12 | Por definir | Versión inicial |
```

**Commit backend:** `docs: agregar US-001 registrar postal poseída`.

---

## Fase 3 · Caso de uso UC-001 con criterios GWT

### 3.1 Generar el UC con Copilot

En VS Code, con el agent activo:

```
@programador-mapi
/generar-caso-de-uso
```

Copilot te pedirá los parámetros. Respondé:

- **nombreUC:** `registrar-postal-poseida`
- **historiaUsuario:** `US-001`
- **actor:** `Coleccionista autenticado`
- **capacidad:** `Registrar una postal por su número en la colección`
- **beneficio:** `Llevar control preciso de mi álbum`
- **endpoint:** `POST /api/v1/colecciones/mias/postales`

Copilot generará `docs/use-cases/UC-001-registrar-postal-poseida.md`. El archivo debería incluir las **11 secciones** y los **6 AC obligatorios**. Aquí un extracto de la sección crítica:

```markdown
## 6. Criterios de aceptación (GWT)

### AC-01 · Registro exitoso de postal
**Dado** un coleccionista autenticado con rol `Coleccionista`
**Y** una postal `123` que existe en el catálogo
**Y** que aún NO tiene la postal `123` en su colección
**Cuando** invoca `POST /api/v1/colecciones/mias/postales` con `{ "numero": 123 }`
**Entonces** el sistema responde HTTP 201
**Y** el cuerpo contiene `{ "numero": 123, "estado": "poseida", "cantidad": 1 }`
**Y** se registra evento `PostalRegistrada`

### AC-02 · Postal fuera del rango del catálogo (validación)
**Dado** un coleccionista autenticado
**Cuando** invoca `POST /api/v1/colecciones/mias/postales` con `{ "numero": 9999 }`
**Entonces** el sistema responde HTTP 400
**Y** el cuerpo contiene mensaje `Número de postal fuera del catálogo`

### AC-03 · Usuario no autenticado (autorización)
**Dado** un usuario sin token válido
**Cuando** invoca `POST /api/v1/colecciones/mias/postales` con `{ "numero": 123 }`
**Entonces** el sistema responde HTTP 401

### AC-04 · Postal no existe en el catálogo (no encontrado)
**Dado** un coleccionista autenticado
**Y** el número `500` (dentro del rango 1..670 pero eliminado del catálogo)
**Cuando** invoca `POST /api/v1/colecciones/mias/postales` con `{ "numero": 500 }`
**Entonces** el sistema responde HTTP 404
**Y** el cuerpo contiene `Postal no existe en el catálogo`

### AC-05 · Registrar postal ya poseída (idempotencia → repetida)
**Dado** un coleccionista autenticado
**Y** que ya tiene la postal `123` con cantidad `1`
**Cuando** invoca de nuevo `POST /api/v1/colecciones/mias/postales` con `{ "numero": 123 }`
**Entonces** el sistema responde HTTP 200
**Y** el cuerpo contiene `{ "numero": 123, "estado": "repetida", "cantidad": 2 }`

### AC-06 · Fallo de la base de datos (fallo dep. externa)
**Dado** un coleccionista autenticado
**Y** que la base de datos no responde
**Cuando** invoca `POST /api/v1/colecciones/mias/postales` con `{ "numero": 123 }`
**Entonces** el sistema responde HTTP 503
**Y** el cuerpo contiene `Servicio no disponible temporalmente`
```

### 3.2 Validar el UC

```
@programador-mapi invocá el skill validar-uc sobre docs/use-cases/UC-001-registrar-postal-poseida.md
```

Salida esperada: **Válido** — todas las secciones completas, los 6 escenarios cubiertos.

**Commit backend:** `docs: agregar UC-001 registrar postal poseída con AC en formato GWT`.

---

## Fase 4 · Backend — Ciclo TDD para AC-01

### 4.1 Crear la rama

```bash
git checkout -b feature/US-001-registrar-postal-poseida
```

### 4.2 🔴 RED — Prueba que falla

```
@programador-mapi
/generar-prueba-desde-ac
```

Parámetros:
- **ucId:** `UC-001`
- **acId:** `AC-01`
- **stack:** `backend`
- **sut:** `RegistradorPostales.Registre`
- **ubicacion:** `Reglas`

Copilot genera `tests/AlbumMundial.Reglas.Tests/RegistradorPostalesTests.cs`:

```csharp
using AlbumMundial.Abstracciones.Interfaces;
using AlbumMundial.Abstracciones.Modelos;
using AlbumMundial.Reglas;
using FluentAssertions;
using NSubstitute;
using Xunit;

namespace AlbumMundial.Reglas.Tests;

public class RegistradorPostalesTests
{
    // AC-01: Registro exitoso de postal
    [Fact]
    public async Task Registre_ConPostalDelCatalogoYSinPoseerla_RetornaRegistroPoseida()
    {
        // Arrange
        var idColeccionista = "user-123";
        var numeroPostal = 123;
        var catalogo = Substitute.For<ICatalogoDa>();
        var colecciones = Substitute.For<IColeccionesDa>();
        catalogo.Existe(numeroPostal).Returns(true);
        colecciones.ObtengaPostal(idColeccionista, numeroPostal).Returns((PostalPoseida?)null);
        var registrador = new RegistradorPostales(catalogo, colecciones);

        // Act
        var resultado = await registrador.Registre(idColeccionista, numeroPostal);

        // Assert
        resultado.Numero.Should().Be(123);
        resultado.Estado.Should().Be(EstadoPostal.Poseida);
        resultado.Cantidad.Should().Be(1);
        await colecciones.Received(1).Guarde(
            idColeccionista,
            Arg.Is<PostalPoseida>(p => p.Numero == 123 && p.Cantidad == 1)
        );
    }
}
```

Verificar que **falla**:

```bash
dotnet test --filter "FullyQualifiedName~Registre_ConPostalDelCatalogoYSinPoseerla"
# Falla porque RegistradorPostales aún no existe ✅
```

**Commit:** `test: agregar prueba para AC-01 de UC-001`.

### 4.3 🟢 GREEN — Código mínimo

```
@programador-mapi
/implementar-para-pasar-prueba
```

Parámetros:
- **archivoPrueba:** `tests/AlbumMundial.Reglas.Tests/RegistradorPostalesTests.cs`
- **nombreTest:** `Registre_ConPostalDelCatalogoYSinPoseerla_RetornaRegistroPoseida`
- **stack:** `backend`
- **ubicacion:** `Reglas`

El agent crea archivos en las capas correctas:

**`src/AlbumMundial.Abstracciones/Modelos/EstadoPostal.cs`**

```csharp
namespace AlbumMundial.Abstracciones.Modelos;

public enum EstadoPostal
{
    Poseida,
    Repetida
}
```

**`src/AlbumMundial.Abstracciones/Modelos/PostalPoseida.cs`**

```csharp
namespace AlbumMundial.Abstracciones.Modelos;

public record PostalPoseida(int Numero, int Cantidad)
{
    public EstadoPostal Estado => Cantidad > 1 ? EstadoPostal.Repetida : EstadoPostal.Poseida;
}
```

**`src/AlbumMundial.Abstracciones/Interfaces/ICatalogoDa.cs`**

```csharp
namespace AlbumMundial.Abstracciones.Interfaces;

public interface ICatalogoDa
{
    Task<bool> Existe(int numeroPostal);
}
```

**`src/AlbumMundial.Abstracciones/Interfaces/IColeccionesDa.cs`**

```csharp
using AlbumMundial.Abstracciones.Modelos;

namespace AlbumMundial.Abstracciones.Interfaces;

public interface IColeccionesDa
{
    Task<PostalPoseida?> ObtengaPostal(string idColeccionista, int numeroPostal);
    Task Guarde(string idColeccionista, PostalPoseida postal);
}
```

**`src/AlbumMundial.Reglas/RegistradorPostales.cs`**

```csharp
using AlbumMundial.Abstracciones.Interfaces;
using AlbumMundial.Abstracciones.Modelos;

namespace AlbumMundial.Reglas;

public class RegistradorPostales(ICatalogoDa catalogo, IColeccionesDa colecciones)
{
    public async Task<PostalPoseida> Registre(string idColeccionista, int numeroPostal)
    {
        var actual = await colecciones.ObtengaPostal(idColeccionista, numeroPostal);
        var nueva = actual is null
            ? new PostalPoseida(numeroPostal, 1)
            : actual with { Cantidad = actual.Cantidad + 1 };
        await colecciones.Guarde(idColeccionista, nueva);
        return nueva;
    }
}
```

Correr:

```bash
dotnet test --filter "FullyQualifiedName~Registre_ConPostalDelCatalogoYSinPoseerla"
# Verde ✅
dotnet test
# Toda la suite verde ✅
```

**Commit:** `feat: implementar RegistradorPostales para AC-01`.

### 4.4 🔵 REFACTOR — SOLID + Clean Code

```
@programador-mapi invocá el skill refactor-solid sobre src/AlbumMundial.Reglas/RegistradorPostales.cs
```

En este caso el código ya cumple SOLID (SRP claro, dependencias hacia `Abstracciones`, sin números mágicos, métodos cortos). El skill reportará ✅ en los 5 principios.

Si el skill sugiere ajustes menores (nombres, extracción de método), aplicarlos.

**Commit (si aplica):** `refactor: mejorar nombres en RegistradorPostales`.

---

## Fase 5 · Backend — Cubrir los demás AC

Repetir el ciclo RED → GREEN → REFACTOR para AC-02 a AC-06.

### 5.1 AC-02 · Validación de rango

**Test (RED):**

```csharp
// AC-02: Postal fuera del rango
[Fact]
public async Task Registre_ConNumeroFueraDelCatalogo_LanzaExcepcionValidacion()
{
    // Arrange
    var registrador = new RegistradorPostales(
        Substitute.For<ICatalogoDa>(),
        Substitute.For<IColeccionesDa>()
    );

    // Act
    Func<Task> act = () => registrador.Registre("user-123", 9999);

    // Assert
    await act.Should().ThrowAsync<PostalFueraDeRangoException>()
        .WithMessage("*fuera del catálogo*");
}
```

**Código (GREEN):**

- Agregar `PostalFueraDeRangoException` en `Abstracciones/Excepciones/`.
- Constante `NUMERO_MAXIMO_POSTAL = 670` en `Reglas/Constantes.cs`.
- Validación al inicio del método `Registre`.

### 5.2 AC-03 · Autenticación (capa API)

El AC-03 es responsabilidad del **controller**, no del `Reglas`. Movemos el test a `AlbumMundial.Api.Tests/PostalesControllerTests.cs`.

**Test:**

```csharp
// AC-03: Sin autenticación
[Fact]
public async Task Post_SinToken_Retorna401()
{
    // Arrange
    using var factory = new WebApplicationFactory<Program>();
    using var client = factory.CreateClient();

    // Act
    var response = await client.PostAsJsonAsync(
        "/api/v1/colecciones/mias/postales",
        new { numero = 123 }
    );

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
}
```

**Código:**

- `PostalesController` con `[Authorize]`.
- Configuración de auth en `Program.cs`.

### 5.3 AC-04 · Postal no existe

Test en `Reglas` con `catalogo.Existe(500).Returns(false)` → lanza `PostalNoExisteException` → mapeada a 404 en el controller.

### 5.4 AC-05 · Idempotencia → repetida

Test en `Reglas` con `colecciones.ObtengaPostal(...)` retornando una postal existente con cantidad 1. El resultado tiene cantidad 2 y estado `Repetida`.

### 5.5 AC-06 · Fallo de dependencia externa

Test en `Reglas` con `colecciones.Guarde(...)` lanzando `TimeoutException` → el flujo (`Flujo`) la mapea a `ServicioNoDisponibleException` → controller responde 503.

Aquí introducimos la capa **Flujo** por primera vez: `RegistroPostalesFlujo` en `AlbumMundial.Flujo/` orquesta y mapea excepciones.

### 5.6 Estructura final del backend

```
src/
├── AlbumMundial.Abstracciones/
│   ├── Modelos/           EstadoPostal.cs, PostalPoseida.cs
│   ├── Excepciones/       PostalFueraDeRangoException.cs, ...
│   └── Interfaces/        ICatalogoDa.cs, IColeccionesDa.cs, IRegistradorPostales.cs
├── AlbumMundial.Api/
│   ├── Controllers/       PostalesController.cs
│   └── Program.cs         (composition root)
├── AlbumMundial.Flujo/
│   └── RegistroPostalesFlujo.cs
├── AlbumMundial.Reglas/
│   ├── RegistradorPostales.cs
│   └── Constantes.cs
├── AlbumMundial.Servicios/       (vacío por ahora)
└── AlbumMundial.AccesoDatos/
    ├── CatalogoDa.cs
    └── ColeccionesDa.cs
```

### 5.7 Auditar cobertura antes del PR

```
@programador-mapi invocá el skill analisis-cobertura sobre los archivos modificados contra UC-001
```

Salida esperada:

```
Decisión: Aprobado.
- Cobertura línea: 94%
- Cobertura rama: 88%
- Los 6 escenarios mínimos cubiertos.
```

Si aparece algún gap, agregar la prueba faltante antes de abrir el PR.

---

## Fase 6 · Frontend — Hook + Componente + Vista

### 6.1 Crear la rama

```bash
git checkout -b feature/US-001-registrar-postal-poseida
```

### 6.2 Estructura del feature

Crear la carpeta `src/features/postales/` con la estructura estándar:

```
src/features/postales/
├── components/
├── hooks/
├── services/
├── types/
├── views/
└── routes.ts
```

### 6.3 🔴 RED — Prueba del hook

```
@programador-spa-react
/generar-prueba-desde-ac
```

Parámetros:
- **ucId:** `UC-001`
- **acId:** `AC-01`
- **stack:** `frontend`
- **sut:** `useRegistrarPostal`
- **ubicacion:** `features/postales`

Test generado en `tests/features/postales/use-registrar-postal.test.ts`:

```ts
import { renderHook, waitFor } from '@testing-library/react';
import { useRegistrarPostal } from '../../../src/features/postales/hooks/use-registrar-postal';
import { describe, it, expect, vi } from 'vitest';

describe('useRegistrarPostal', () => {
  // AC-01: Registro exitoso de postal
  it('registre_conPostalNueva_retornaEstadoExito', async () => {
    // Arrange
    const numeroPostal = 123;

    // Act
    const { result } = renderHook(() => useRegistrarPostal());
    result.current.registre(numeroPostal);

    // Assert
    await waitFor(() => {
      expect(result.current.estado.estado).toBe('exito');
    });
    if (result.current.estado.estado === 'exito') {
      expect(result.current.estado.datos.numero).toBe(123);
      expect(result.current.estado.datos.estado).toBe('poseida');
      expect(result.current.estado.datos.cantidad).toBe(1);
    }
  });
});
```

Verificar que **falla**:

```bash
npm run test -- use-registrar-postal
# Falla porque el hook aún no existe ✅
```

### 6.4 🟢 GREEN — Generar el hook

```
@programador-spa-react
/generar-custom-hook
```

Parámetros:
- **nombreHook:** `registrar-postal`
- **feature:** `postales`
- **proposito:** `Registrar una postal por su número en la colección del usuario`
- **tipo:** `estado-async`

**`src/features/postales/types/postal.types.ts`**

```ts
export type EstadoPostal = 'poseida' | 'repetida';

export interface PostalRegistrada {
  numero: number;
  estado: EstadoPostal;
  cantidad: number;
}
```

**`src/features/postales/services/postales.service.ts`**

```ts
import { consultarApi } from '<useRecurso>';
import type { PostalRegistrada } from '../types/postal.types';

export const postalesService = {
  registre: (numero: number) =>
    consultarApi.post<PostalRegistrada>(
      '/api/v1/colecciones/mias/postales',
      { numero }
    ),
};
```

**`src/features/postales/hooks/use-registrar-postal.ts`**

```ts
import { useState } from 'react';
import { postalesService } from '../services/postales.service';
import type { PostalRegistrada } from '../types/postal.types';

type EstadoRegistro =
  | { estado: 'inicial' }
  | { estado: 'cargando' }
  | { estado: 'exito'; datos: PostalRegistrada }
  | { estado: 'error'; mensaje: string };

export function useRegistrarPostal() {
  const [estado, setEstado] = useState<EstadoRegistro>({ estado: 'inicial' });

  const registre = (numero: number) => {
    setEstado({ estado: 'cargando' });
    postalesService.registre(numero)
      .then(datos => setEstado({ estado: 'exito', datos }))
      .catch(e => setEstado({ estado: 'error', mensaje: e.message }));
  };

  return { estado, registre } as const;
}
```

Correr la suite:

```bash
npm run test -- use-registrar-postal
# Verde ✅
```

**Commit:** `feat(postales): agregar useRegistrarPostal para AC-01`.

### 6.5 Generar el componente presentacional

```
@programador-spa-react
/generar-componente-funcional
```

Parámetros:
- **nombreComponente:** `FormularioRegistrarPostal`
- **feature:** `postales`
- **tipo:** `presentacional`
- **props:** `alRegistrar (callback con el número), esCargando`
- **ucId:** `UC-001`

**`src/features/postales/components/FormularioRegistrarPostal.tsx`**

```tsx
// Componente asociado a UC-001

import { useState } from 'react';

interface PropiedadesFormularioRegistrarPostal {
  alRegistrar: (numero: number) => void;
  esCargando?: boolean;
}

function FormularioRegistrarPostal({
  alRegistrar,
  esCargando = false,
}: PropiedadesFormularioRegistrarPostal) {
  const [numero, setNumero] = useState<string>('');

  const manejeEnvio = (evento: React.FormEvent) => {
    evento.preventDefault();
    const parsed = Number.parseInt(numero, 10);
    if (Number.isNaN(parsed)) return;
    alRegistrar(parsed);
    setNumero('');
  };

  return (
    <form onSubmit={manejeEnvio}>
      <label htmlFor="numero-postal">Número de postal</label>
      <input
        id="numero-postal"
        type="number"
        min={1}
        max={670}
        value={numero}
        onChange={e => setNumero(e.target.value)}
        disabled={esCargando}
        required
      />
      <button type="submit" disabled={esCargando}>
        {esCargando ? 'Registrando...' : 'Registrar'}
      </button>
    </form>
  );
}

export default FormularioRegistrarPostal;
```

### 6.6 Generar la vista que compone hook + componente

```
@programador-spa-react
/generar-componente-funcional
```

Parámetros:
- **nombreComponente:** `RegistrarPostal`
- **feature:** `postales`
- **tipo:** `vista`
- **ucId:** `UC-001`

**`src/features/postales/views/VistaRegistrarPostal.tsx`**

```tsx
// Vista asociada a UC-001

import { useRegistrarPostal } from '../hooks/use-registrar-postal';
import FormularioRegistrarPostal from '../components/FormularioRegistrarPostal';

function VistaRegistrarPostal() {
  const { estado, registre } = useRegistrarPostal();

  return (
    <section>
      <h1>Registrar postal</h1>

      <FormularioRegistrarPostal
        alRegistrar={registre}
        esCargando={estado.estado === 'cargando'}
      />

      {estado.estado === 'exito' && (
        <p>
          ✅ Postal {estado.datos.numero} registrada.
          {estado.datos.estado === 'repetida'
            ? ` ¡Ya tenías esta, ahora tenés ${estado.datos.cantidad}!`
            : ' ¡Nueva en tu colección!'}
        </p>
      )}

      {estado.estado === 'error' && (
        <p role="alert">❌ {estado.mensaje}</p>
      )}
    </section>
  );
}

export default VistaRegistrarPostal;
```

### 6.7 Registrar la ruta

**`src/features/postales/routes.ts`**

```ts
import VistaRegistrarPostal from './views/VistaRegistrarPostal';

export const rutasPostales = [
  { path: '/postales/registrar', element: <VistaRegistrarPostal /> },
];
```

Y agregarla al router principal (`src/router.ts`).

### 6.8 🔵 REFACTOR

```
@programador-spa-react invocá el skill refactor-solid sobre src/features/postales/
```

El skill valida:
- **SRP:** hook maneja estado, componente maneja UI, service maneja HTTP ✅
- **DIP:** componente depende de props/hook, no de service ✅
- **ISP:** props del formulario mínimas ✅
- No hay `any`, no hay `React.FC`, no hay imports fuera del catálogo ✅

**Commits del frontend:**
- `feat(postales): agregar FormularioRegistrarPostal`
- `feat(postales): agregar VistaRegistrarPostal`
- `feat(postales): registrar ruta /postales/registrar`

### 6.9 Auditar cobertura

```
@programador-spa-react invocá el skill analisis-cobertura contra UC-001
```

Salida esperada: ✅ Aprobado.

---

## Fase 7 · PR + reportes automáticos

### 7.1 Abrir los 2 PRs

**Backend:**

```bash
git push -u origin feature/US-001-registrar-postal-poseida
gh pr create --fill --base main
```

**Frontend:** ídem.

En la descripción de ambos, referenciar:
- `US-001`
- `AC-01`, `AC-02`, `AC-03`, `AC-04`, `AC-05`, `AC-06`
- Link al UC-001

### 7.2 Qué verás automáticamente (PR del backend)

Los 5 workflows agentic corren en paralelo. Verás comentarios como:

**Comentario de `validar-uc`:**
```
Decisión agregada: Válido
UC-001: Válido (0 críticas, 0 altas, 1 media, 0 bajas)
```

**Comentario de `validar-cobertura`:**
```
Decisión: Aprobado
Línea 94% ✅ | Rama 88% ✅
Los 6 escenarios mínimos cubiertos.
```

**Comentario de `validar-dependencias`:**
```
Decisión: Aprobado
Sin dependencias nuevas fuera del catálogo de librerías justificadas.
```

**Comentario de `validar-arquitectura`:**
```
Decisión: Aprobado
Regla de Dependencia respetada.
Reglas puro (sin I/O directo).
Controllers thin.
```

**Comentario resumen de `revisar-pr`:**
```
Decisión sugerida: Aprobar

| Dimensión | Estado |
|---|---|
| Trazabilidad     | ✅ |
| UC               | ✅ |
| Cobertura        | ✅ |
| Dependencias     | ✅ |
| Arquitectura     | ✅ |
| SOLID/Clean Code | ✅ |
| Seguridad        | ✅ |
| Commits          | ✅ |
| CI               | ✅ |
```

### 7.3 Revisión humana

Con el reporte consolidado como punto de partida, el reviewer:

1. Confirma que la trazabilidad AC ↔ Test ↔ Código es correcta al menos por muestreo.
2. Verifica lógica de negocio en `RegistradorPostales` y `RegistroPostalesFlujo`.
3. AccesoDatos su ✅.

### 7.4 Frontend igual

El PR del frontend recibe reportes análogos (sin `validar-arquitectura` porque no aplica a frontend en el taller, aunque el maestro puede evolucionar).

---

## Fase 8 · Merge

Merge de los 2 PRs a `main`. Automáticamente:

- Se cierra el issue de la historia US-001 (si lo abriste).
- Se despliega a un ambiente de prueba (según el CI/CD del repo).
- Las etiquetas del PR quedan como registro histórico.

---

## 🎉 Resultado

Con esta historia:

- El backend expone `POST /api/v1/colecciones/mias/postales` respetando las 6 capas, con 6 pruebas mapeadas 1 a 1 a los 6 AC.
- El frontend expone `/postales/registrar` con un formulario que llama al hook, que llama al service, que usa el useRecurso (custom hook del proyecto).
- Todo el flujo está trazable de US-001 → UC-001 → AC-## → test → código → commit → PR → merge.

---

## 📚 Historias restantes (ejercicio)

Aplicando el mismo patrón, extendé el proyecto con:

### US-002 · Marcar una postal como repetida (para intercambio)
- UC-002 · Marcar postal como disponible para intercambio.
- Requiere un endpoint `PATCH /api/v1/colecciones/mias/postales/{numero}/intercambio`.
- En el frontend, botón "Ofrecer para intercambio" en la lista de repetidas.

### US-003 · Consultar postales faltantes
- UC-003 · Consultar postales faltantes de mi colección.
- Endpoint `GET /api/v1/colecciones/mias/postales/faltantes`.
- En el frontend, vista con grid usando el componente propio del equipo.

### US-004 · Consultar postales repetidas
- UC-004 · Consultar postales repetidas.
- Endpoint `GET /api/v1/colecciones/mias/postales/repetidas`.
- En el frontend, vista análoga con estados.

### US-005 · Ver estadísticas de progreso
- UC-005 · Ver estadísticas de mi colección.
- Endpoint `GET /api/v1/colecciones/mias/estadisticas`.
- Retorna: `{ totalCatalogo, poseidas, faltantes, repetidas, porcentajeCompletado }`.
- En el frontend, dashboard con visualización.

**Consejo:** hacé US-002 completo como ejercicio guiado (ya podés hacerlo solo). Después, US-003, US-004 y US-005 en cadena para practicar velocidad.

---

## ✅ Qué demostró este walkthrough

| Artefacto del taller | Se usó en |
|---|---|
| Constitution | Guió cada decisión (§2, §3, §4, §5, §6, §7) |
| ADR-001..ADR-Frontend-002 | Sostuvo la arquitectura y política de dependencias |
| ADR-004 (nuevo, propio del proyecto) | Decisión de dominio (catálogo como semilla) |
| Documento maestro §5 (docs previos) | Definió qué documentar antes de codear |
| Repository Templates | Bootstrap de los 2 repos (`SC-701/Template.API`, `SC-701/Template.SPA`) |
| Content Templates | US, UC, ADR, README, PR |
| `copilot-instructions.md` | Guió a Copilot en cada request |
| Instructions path-specific | Reglas por capa (Api, Reglas, AccesoDatos, tests) |
| Prompts (6) | `/generar-historia-de-usuario`, `/generar-caso-de-uso`, `/generar-prueba-desde-ac`, `/implementar-para-pasar-prueba`, `/generar-componente-funcional`, `/generar-custom-hook` |
| Agents (3) | `@analista-requisitos` (requisitos), `@programador-mapi` (backend), `@programador-spa-react` (frontend) |
| Skills (5) | `validar-us`, `validar-uc`, `refactor-solid`, `analisis-cobertura`, `revisar-pr` |
| Workflows agentic (5) | Reportes automáticos en el PR |

**El único artefacto no ejercitado fue MCP** — porque este dominio no requirió conexión a sistemas externos. Cuando se ejercite (por ejemplo, para consultar el catálogo Panini oficial), pasará por el catálogo autorizado de MCPs.

---

## 🔗 Referencias

- ./guia-de-uso.md (guía general de uso del taller)
- ./copilot-estrategia.md
- ./constitution.md
- ./adr/
- ./templates/
- ./skills/
- ./prompts/

---

## 📝 Historial

| Versión | Fecha | Autor | Cambios |
|---|---|---|---|
| 0.1 | 2026-07-06 | Por definir | Versión inicial del walkthrough. Cubre setup, US-001 completo end-to-end (backend + frontend) y roadmap para US-002..US-005. |

---

*Walkthrough versión 0.1 · Taller · La Constitution siempre gana, también en los ejemplos.*