
# SMARTWOD — CONTEXTO TÉCNICO

---

# 1. INFORMACIÓN GENERAL

Nombre del proyecto: SMARTWOD  
Plataforma: Flutter  
Versión actual: 0.5.0-beta

Estado del sistema:

Arquitectura consolidada basada en segmentos.

Modos activos:

- AMRAP
- EMOM
- TABATA
- FOR TIME

Próximo modo:

- MIX

---

# 2. PRINCIPIO ARQUITECTÓNICO

SMARTWOD separa responsabilidades en capas.

Arquitectura:

Definition  
↓  
Structure  
↓  
Runner  
↓  
UI

Esto permite agregar nuevos modos sin modificar el motor.

---

# 3. DEFINITIONS

Cada modo tiene su definición.

Ejemplos:

```
AmrapDefinition
EmomDefinition
TabataDefinition
ForTimeDefinition
```

La definición contiene los parámetros del workout.

Ejemplo Tabata:

```
rounds
workSeconds
restSeconds
```

Ejemplo For Time:

```
timeCapSeconds
```

---

# 4. STRUCTURE

Las definiciones se transforman en segmentos ejecutables.

```
WorkSegment
RestSegment
```

Estos segmentos son ejecutados por el runner.

---

# 5. SEGMENT RUNNER

SegmentRunner es el motor principal del timer.

Responsabilidades:

- ejecutar segmentos
- manejar transición work/rest
- emitir estado del timer
- calcular progreso global
- manejar pausa

---

# 6. TIMER PHASE

Estados posibles:

```
work
rest
paused
finished
```

Reglas:

- pausa solo durante work
- rest no puede pausarse
- finalización automática al terminar segmentos

---

# 7. TIMER UI STATE

El runner emite estados hacia la UI.

Campos:

```
remainingSeconds
phase
currentRound
totalRounds
phaseTotalSeconds
isPaused
isFinished
```

La UI se actualiza mediante:

```
Stream<TimerUiState>
```

---

# 8. TIMER SCREEN

TimerScreen funciona como controlador principal.

Responsabilidades:

- iniciar countdown
- iniciar runner
- escuchar actualizaciones
- guardar historial
- controlar wakelock

TimerScreen no conoce lógica interna del workout.

---

# 9. HISTORIAL

Persistencia mediante:

```
WorkoutHistoryRepository
```

Entidad principal:

```
WorkoutResult
```

Campos:

```
type
date
totalSeconds
metadata
note
```

---

# 10. METADATA POR MODO

TABATA

```
rounds
workSeconds
restSeconds
```

FOR TIME

```
timeCapSeconds
```

EMOM

```
rounds
intervalSeconds
```

AMRAP

```
blocks[]
```

Esto permite reconstruir el entrenamiento en el detalle.

---

# 11. FINALIZACIÓN MANUAL

Solo el modo FOR TIME permite finalizar manualmente.

El tiempo real se calcula como:

```
elapsedSeconds =
configuredSeconds - remainingSeconds
```

Esto permite terminar antes del time cap.

---

# 12. SEGURIDAD

Protecciones implementadas:

- cancelación segura de streams
- limpieza de runners
- control de wakelock
- validación de metadata

---

# 13. ROADMAP TÉCNICO

v0.6

- mejoras UI
- optimización del timer
- iconos por tipo

v0.7

modo MIX

v0.8

mejoras UX

v1.0

release pública

---

# 14. FUNCIONES PREMIUM

Planeadas:

- estadísticas semanales
- filtros de historial
- dashboard de progreso

Estas funciones no modifican el motor temporal.
