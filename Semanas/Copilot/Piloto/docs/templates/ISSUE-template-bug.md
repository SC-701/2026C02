---
name: 🐞 Reporte de bug
about: Reportar un defecto en el sistema
title: "[BUG] <descripción corta del problema>"
labels: [bug, triage]
assignees: []
---

## 🐞 Descripción del bug

*Descripción clara y concisa del defecto observado.*

---

## 📍 Contexto

- **Producto / módulo:** *…*
- **Ambiente:** desarrollo / prueba / producción
- **Versión / commit:** *…*
- **Navegador / sistema operativo (si aplica):** *…*
- **Rol del usuario afectado:** *…*

---

## 🔁 Pasos para reproducir

1. *Ir a …*
2. *Hacer clic en …*
3. *Ingresar …*
4. *Observar el error*

---

## ✅ Comportamiento esperado

*Qué debería haber ocurrido según el caso de uso o criterio de aceptación.*

---

## ❌ Comportamiento observado

*Qué ocurre en realidad. Incluir mensaje de error exacto si existe.*

---

## 📸 Evidencia

*Capturas, videos, logs, stack trace, código HTTP, ID de correlación.*

```
<logs si aplican>
```

---

## 🎯 Trazabilidad

- **Historia de usuario:** `US-###` (si se identifica)
- **Caso de uso:** `UC-###` (si se identifica)
- **Criterio de aceptación afectado:** `AC-##` (si se identifica)

---

## 🔥 Impacto y severidad

- **Severidad:**
  - [ ] Crítica — servicio caído / pérdida de datos
  - [ ] Alta — funcionalidad principal bloqueada, con workaround difícil
  - [ ] Media — funcionalidad afectada con workaround aceptable
  - [ ] Baja — cosmético o menor
- **Frecuencia:** siempre / intermitente / una sola vez
- **Cantidad estimada de usuarios afectados:** *…*
- **¿Existe workaround?** sí / no · descripción: *…*

---

## 🧪 Hipótesis inicial (opcional)

*Si el reportador tiene una intuición de la causa.*

---

## ✔️ Definición de "hecho" para este bug

- [ ] Prueba unitaria que reproduce el defecto (🔴 RED).
- [ ] Corrección implementada que hace pasar la prueba (🟢 GREEN).
- [ ] Refactor si aplica (🔵 REFACTOR).
- [ ] Verificación en el ambiente donde se detectó.
- [ ] Actualización del UC/AC si el caso de uso quedaba incompleto.
- [ ] Post-mortem si la severidad fue crítica.