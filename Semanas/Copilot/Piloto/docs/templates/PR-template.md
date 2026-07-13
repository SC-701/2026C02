<!--
Plantilla de Pull Request — Taller
No borrar las secciones. Marcar N/A si no aplica.
-->

## 📌 Resumen

*Descripción corta (2–4 líneas) de qué hace este PR y por qué.*

---

## 🎯 Trazabilidad

- **Historia de usuario:** `US-###`
- **Caso de uso:** `UC-###`
- **Criterios de aceptación cubiertos:** `AC-01`, `AC-02`
- **Issue asociado:** `#<numero>` (si aplica)
- **ADRs afectados:** `[ADR-###]` (si aplica)

---

## 🔧 Tipo de cambio

- [ ] `feat` — nueva funcionalidad
- [ ] `fix` — corrección de defecto
- [ ] `refactor` — mejora interna sin cambio funcional
- [ ] `docs` — solo documentación
- [ ] `test` — solo pruebas
- [ ] `chore` — mantenimiento / configuración
- [ ] `perf` — mejora de rendimiento
- [ ] `hotfix` — corrección urgente en producción

---

## 🧪 Pruebas

- [ ] Se agregaron o modificaron **pruebas unitarias** que cubren los AC de este PR.
- [ ] Se cumple la **relación 1 a 1** (1 AC → 1+ pruebas; 1 prueba → 1 unidad pública).
- [ ] La suite completa **pasa localmente**.
- [ ] Cobertura mínima del taller respetada.
- [ ] **Prohibido** `--passWithNoTests` o equivalentes.

**Comando ejecutado:**

```bash
<comando de test>
```

**Cobertura resultante:** *…%*

---

## 🏗️ Arquitectura y estándares

- [ ] Se respeta la **arquitectura por capas** (backend) o **estructura feature-based** (frontend).
- [ ] Se cumple **SOLID** y **Clean Code**.
- [ ] Se cumplen las reglas del `copilot-instructions.md` del repo.
- [ ] **No se introducen dependencias nuevas** fuera del catálogo de librerías justificadas.
- [ ] Nombres en español; identificadores siguen las convenciones del taller.

---

## 🎨 Frontend (si aplica)

- [ ] Solo componentes funcionales + hooks (excepto `ErrorBoundary`).
- [ ] Sin `any`; TypeScript estricto respetado.
- [ ] Sin `React.FC`; props tipados con `interface`.
- [ ] Estados asíncronos como discriminated union.
- [ ] HTTP vía useRecurso (custom hook del proyecto); sin `axios`/`fetch` directo en componentes.
- [ ] Formularios y grids con librerías open-source justificadas con ADR.

---

## 🖥️ Backend (si aplica)

- [ ] Controllers son *thin translation* (sin lógica de negocio).
- [ ] La lógica de negocio vive en `Reglas` / `Flujo`.
- [ ] `AccesoDatos` no contiene lógica de negocio.
- [ ] Dependencias apuntan a `Abstracciones`; composición solo en `Api`.
- [ ] Cada capa tiene su proyecto de pruebas.

---

## 🔒 Seguridad

- [ ] **No hay secretos** en el código ni en la configuración versionada.
- [ ] No se introducen paquetes de terceros no autorizados.
- [ ] Se validan y sanitizan las entradas del usuario donde aplica.
- [ ] Los endpoints requieren autenticación/autorización cuando corresponde.

---

## 📚 Documentación

- [ ] Se actualizó / creó el UC correspondiente.
- [ ] Se actualizó el CHANGELOG.
- [ ] Se documentaron cambios que impacten a otros equipos.
- [ ] Si hay decisión arquitectónica → se agregó/actualizó un ADR.

---

## ✅ Checklist final

- [ ] El PR tiene un **solo objetivo** claro.
- [ ] Se ejecutó el linter y no hay warnings críticos.
- [ ] La rama está **actualizada** con `main`.
- [ ] No hay `console.log` / prints de depuración olvidados.
- [ ] Los mensajes de commit siguen *Conventional Commits* en imperativo.

---

## 📸 Evidencia (si aplica)

*Capturas, gifs, logs o enlaces a demos que ayuden a revisar el PR.*

---

## 🧭 Notas para el revisor

*Contexto adicional, decisiones tomadas, puntos donde se requiere atención especial.*

---

## 🚀 Post-merge

- [ ] Verificar despliegue en el ambiente correspondiente.
- [ ] Comunicar cambios relevantes al equipo consumidor.
- [ ] Cerrar issue asociado.