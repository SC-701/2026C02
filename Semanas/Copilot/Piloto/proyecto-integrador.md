---
title: Proyecto Integrador — Taller de Desarrollo con GitHub Copilot
audience: Docentes universitarios, Estudiantes de ingeniería de software
owner: Docente del curso
version: academic-1.0
status: activo
last-reviewed: 2026-07-06
tags: [proyecto-integrador, taller, copilot, album-mundial, react, csharp]
---

# Proyecto Integrador — Taller de Desarrollo con GitHub Copilot

> El proyecto integrador es el eje del taller. Los equipos construyen un sistema real durante las 2 semanas, aplicando todos los estándares del taller: SDD, TDD, arquitectura por capas, React funcional y personalización de Copilot.

---

## 1. Dominio propuesto: Sistema de Control de Álbum del Mundial

El proyecto de referencia es el **Álbum del Mundial** — un sistema para registrar y gestionar la colección de figuritas/postales de un álbum de fútbol. Este dominio es ideal para el taller porque:

- Es accesible a cualquier estudiante (no requiere conocimiento de dominio especializado).
- Tiene entidades claras: Álbum, Figurita, Usuario, Intercambio.
- Tiene reglas de negocio no triviales: duplicados, estado de completitud, lógica de intercambio.
- Permite demostrar trazabilidad end-to-end con casos de uso reales.
- Ya existe el ejemplo pedagógico completo en `docs/estandares/ejemplos/guia-proyecto-ejemplo-album-mundial.md`.

---

## 2. Dominios alternativos

Si el docente o el equipo prefieren otro dominio, se puede usar cualquiera de los siguientes. Todos cumplen los requisitos de complejidad mínima:

| Dominio | Descripción breve |
|---|---|
| **Biblioteca del curso** | Gestión de préstamos de libros entre estudiantes |
| **Reserva de laboratorios** | Sistema para reservar salas y equipos de un laboratorio |
| **Gestor de proyectos estudiantiles** | Seguimiento de avances y entregas de proyectos académicos |
| **Foro de dudas del curso** | Sistema de preguntas y respuestas entre estudiantes |
| **Gestor de tareas del equipo** | To-do list colaborativo con prioridades y asignación |
| **Álbum de fotos de graduación** | Sistema para compartir y organizar fotos de un evento |

---

## 3. Alcance mínimo del proyecto (dominio Álbum del Mundial)

### 3.1 Historias de usuario mínimas

| ID | Historia | Prioridad |
|---|---|---|
| US-001 | Como coleccionista, quiero registrar mi álbum con su nombre y año, para poder gestionar mi colección. | Alta |
| US-002 | Como coleccionista, quiero agregar figuritas a mi álbum indicando número, jugador y país, para registrar mis figuritas. | Alta |
| US-003 | Como coleccionista, quiero marcar una figurita como "tengo repetida", para poder ofrecerla en intercambio. | Alta |
| US-004 | Como coleccionista, quiero ver el porcentaje de completitud de mi álbum, para saber cuánto me falta. | Media |
| US-005 | Como coleccionista, quiero buscar figuritas por número o jugador, para encontrar las que me faltan rápidamente. | Media |
| US-006 | Como coleccionista, quiero ver la lista de figuritas repetidas de otro usuario, para coordinar un intercambio. | Baja |

### 3.2 Casos de uso derivados (mínimo)

De las historias anteriores se derivan al menos estos casos de uso, cada uno con 6 ACs mínimos:

- `UC-001` — Registrar álbum
- `UC-002` — Agregar figurita al álbum
- `UC-003` — Marcar figurita como repetida
- `UC-004` — Consultar completitud del álbum
- `UC-005` — Buscar figuritas

### 3.3 Entidades del modelo

```
Álbum
├── id: guid
├── nombre: string
├── año: int
├── usuarioId: guid
└── figuritas: Figurita[]

Figurita
├── id: guid
├── número: int
├── jugador: string
├── país: string
├── álbumId: guid
└── esRepetida: bool

Usuario
├── id: guid
├── nombre: string
└── email: string
```

---

## 4. Arquitectura del proyecto

### 4.1 Backend — C# .NET 8

Estructura de la solución siguiendo las 6 capas del taller:

```
AlbumMundial.sln
├── src/
│   ├── AlbumMundial.Abstracciones/   ← interfaces + modelos
│   ├── AlbumMundial.Api/             ← controllers HTTP
│   ├── AlbumMundial.Bw/              ← flujo / orquestación del UC
│   ├── AlbumMundial.Bc/              ← reglas de negocio puras
│   ├── AlbumMundial.Sg/              ← servicios externos (si aplica)
│   └── AlbumMundial.Da/              ← acceso a datos
└── tests/
    ├── AlbumMundial.Bw.Tests/
    ├── AlbumMundial.Bc.Tests/
    └── AlbumMundial.Da.Tests/
```

**Regla:** la lógica de negocio (porcentaje de completitud, validación de duplicados) vive en `AlbumMundial.Bc`, no en la API ni en el flujo.

### 4.2 Frontend — React 18 + TypeScript

Estructura del SPA siguiendo las convenciones del taller:

```
AlbumMundial.SPA/
├── src/
│   ├── core/           ← config, estilos globales, tipos base
│   ├── features/
│   │   ├── album/      ← componentes, hooks, servicios del dominio álbum
│   │   └── figurita/   ← componentes, hooks, servicios del dominio figurita
│   ├── shared/         ← componentes y hooks reutilizables
│   └── router.ts
└── tests/
```

---

## 5. Hitos del taller (2 días × 3 horas)

### Día 1

| Hito | Descripción | Criterio de aceptación |
|---|---|---|
| **H1.1** — Repositorio base | Repo creado desde template; `copilot-instructions.md` propio; estructura de carpetas correcta | Repo público con commits iniciales; CI configurado |
| **H1.2** — UC-001 + ACs | UC-001 completo con 6 ACs en GWT correcto | UC en `docs/use-cases/`; revisado por el docente |
| **H1.3** — Primer ciclo TDD | UC-001 — AC-01 implementado con TDD (commits RED → GREEN → REFACTOR evidentes) | Test pasa en CI; cobertura ≥ 70% para AC-01 |
| **H1.4** — 2 prompts propios | 2 prompts en `.github/prompts/` con frontmatter completo | Archivos presentes y funcionales en el repo |

### Día 2

| Hito | Descripción | Criterio de aceptación |
|---|---|---|
| **H2.1** — AC-02 y AC-03 en TDD | Escenarios de validación y error del UC-001 cubiertos | Tests pasan; cobertura acumulada ≥ 70% |
| **H2.2** — Componente React UC-001 | Componente funcional con discriminated union y custom hook `useRecurso<T>()` | Sin `any`; prueba con Testing Library |
| **H2.3** — ADR completo | 1 ADR de decisión técnica del proyecto con todas las secciones | ADR en `docs/adr/` con formato correcto |
| **H2.4** — Demo + retrospectiva | Demo de 5 min (UC → test → código); retrospectiva documentada | Demo funciona; reporte de `revisar-pr` en el PR; `docs/retro.md` creado |

---

## 6. Criterios de entrega parcial y final

### Entrega al cierre del Día 1

El repositorio debe tener:
- [ ] Estructura de carpetas correcta y CI activo.
- [ ] UC-001 con 6 ACs en GWT correcto.
- [ ] AC-01 del UC-001 implementado con TDD (commits evidencian el ciclo).
- [ ] `copilot-instructions.md` propio en `.github/`.
- [ ] 2 prompts propios en `.github/prompts/`.

### Entrega al cierre del Día 2 (entrega final)

El repositorio debe tener:
- [ ] AC-01, AC-02 y AC-03 del UC-001 implementados con TDD.
- [ ] Cobertura de pruebas ≥ 70% para UC-001.
- [ ] 1 componente React funcional con estado async correcto.
- [ ] 1 ADR completo en `docs/adr/`.
- [ ] Reporte de `revisar-pr` adjunto en al menos 1 PR.
- [ ] Retrospectiva documentada en `docs/retro.md`.
- [ ] README completo con instrucciones de setup.

---

## 7. Repositorio de referencia

El repositorio de referencia del proyecto Álbum del Mundial está documentado en:

[`docs/estandares/ejemplos/guia-proyecto-ejemplo-album-mundial.md`](../docs/estandares/ejemplos/guia-proyecto-ejemplo-album-mundial.md)

Ese documento contiene un walkthrough end-to-end del ciclo completo: desde la historia de usuario hasta el PR final, pasando por UC, ACs, TDD y personalización de Copilot.

---

## 8. Historial de cambios

| Versión | Fecha | Cambios |
|---|---|---|
| academic-1.0 | 2026-07-06 | Creación del documento de proyecto integrador para el Taller de Desarrollo con GitHub Copilot |
