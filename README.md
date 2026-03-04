
# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para crear y ejecutar entrenamientos funcionales tipo WOD con precisión temporal y registro automático.

Versión actual: 0.5.0-beta  
Estado: Arquitectura consolidada + historial avanzado

---

# 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta confiable para atletas y entrenadores que necesitan:

- temporizador preciso
- ejecución estable sin drift
- manejo correcto de intervalos
- visualización clara de fases
- historial de entrenamientos
- registro de notas
- funcionamiento offline

El objetivo es priorizar:

1. estabilidad
2. claridad de arquitectura
3. escalabilidad

---

# 🏗 Estado Actual del Proyecto

Fase actual: **0.5.0-beta**

Modos de entrenamiento implementados:

- AMRAP
- EMOM
- TABATA
- FOR TIME

Funciones implementadas:

- temporizador central unificado
- countdown previo al entrenamiento
- audio de conteo final
- pausa/resume del entrenamiento
- historial persistente
- detalle de cada workout
- notas por entrenamiento
- finalización manual en For Time
- metadata estructurada por tipo de workout

---

# 🧠 Arquitectura del Sistema

SMARTWOD utiliza una arquitectura desacoplada basada en segmentos.

Flujo principal:

WorkoutDefinition  
↓  
WorkoutStructure  
↓  
SegmentRunner  
↓  
TimerScreen  
↓  
WorkoutResult  
↓  
WorkoutHistory

Esto permite:

- reutilizar lógica
- evitar duplicación de código
- agregar nuevos modos sin modificar el motor

---

# 📂 Estructura del Proyecto

```

# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para crear y ejecutar entrenamientos funcionales tipo WOD con precisión temporal y registro automático.

Versión actual: 0.5.0-beta  
Estado: Arquitectura consolidada + historial avanzado

---

# 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta confiable para atletas y entrenadores que necesitan:

- temporizador preciso
- ejecución estable sin drift
- manejo correcto de intervalos
- visualización clara de fases
- historial de entrenamientos
- registro de notas
- funcionamiento offline

El objetivo es priorizar:

1. estabilidad
2. claridad de arquitectura
3. escalabilidad

---

# 🏗 Estado Actual del Proyecto

Fase actual: **0.5.0-beta**

Modos de entrenamiento implementados:

- AMRAP
- EMOM
- TABATA
- FOR TIME

Funciones implementadas:

- temporizador central unificado
- countdown previo al entrenamiento
- audio de conteo final
- pausa/resume del entrenamiento
- historial persistente
- detalle de cada workout
- notas por entrenamiento
- finalización manual en For Time
- metadata estructurada por tipo de workout

---

# 🧠 Arquitectura del Sistema

SMARTWOD utiliza una arquitectura desacoplada basada en segmentos.

Flujo principal:

WorkoutDefinition  
↓  
WorkoutStructure  
↓  
SegmentRunner  
↓  
TimerScreen  
↓  
WorkoutResult  
↓  
WorkoutHistory

Esto permite:

- reutilizar lógica
- evitar duplicación de código
- agregar nuevos modos sin modificar el motor

---

# 📂 Estructura del Proyecto

```
lib/

core/
timer_phase.dart
timer_ui_state.dart
workout_type_extension.dart
audio/
sound_engine.dart

domain/
definitions/
amrap_definition.dart
emom_definition.dart
tabata_definition.dart
for_time_definition.dart

runners/
segment_runner.dart

entities/
workout_result.dart

enums/
workout_type.dart

data/
repositories/
workout_history_repository_impl.dart

presentation/
screens/
timer_screen.dart
workout_history_screen.dart
workout_detail_screen.dart

widgets/
central_timer.dart
```

---

# ⏱ Funcionamiento del Timer

Todos los modos se ejecutan mediante **SegmentRunner**.

Cada entrenamiento se transforma en una lista de segmentos:

```
WorkSegment
RestSegment
```

Ejemplo Tabata:

```
Work 20s
Rest 10s
Work 20s
Rest 10s
Work 20s
Rest 10s
...
```

El runner ejecuta cada segmento de forma secuencial.

---

# 🧩 Timer UI State

El runner emite un estado llamado:

TimerUiState

Campos principales:

```
remainingSeconds
phase
currentRound
totalRounds
phaseTotalSeconds
isPaused
isFinished
```

Este estado se transmite mediante:

```
Stream<TimerUiState>
```

La UI escucha el stream para actualizar el timer.

---

# 🗂 Historial de Entrenamientos

Cada entrenamiento genera un objeto:

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

Ejemplo almacenado:

```
{
"type": "forTime",
"totalSeconds": 455,
"metadata": {
"timeCapSeconds": 600
}
}
```

---

# 📊 Visualización del Historial

El historial muestra información resumida del workout.

Ejemplo TABATA:

```
TABATA
8 rondas · 20s / 10s
2026-03-04
04:00
```

Ejemplo FOR TIME:

```
FOR TIME
Time Cap 10:00
2026-03-04
07:35
```

Esto permite entender el entrenamiento sin abrir el detalle.

---

# 🧾 Detalle de Entrenamiento

La pantalla de detalle muestra:

- tiempo total
- configuración del workout
- fecha
- notas del usuario

Para Tabata se muestra:

```
Rondas
Trabajo
Descanso
```

Para For Time se muestra:

```
Time Cap
Fecha
```

---

# 🧭 Roadmap

## v0.6

Mejoras visuales

- iconos por tipo de workout
- optimización visual del historial
- mejoras del timer

## v0.7

Nuevo modo:

MIX

Permite encadenar workouts.

Ejemplo:

```
AMRAP 5:00
REST 1:00
EMOM 10
REST 2:00
FOR TIME 8:00
```

## v0.8

Mejoras UX

- animaciones del timer
- historial visual avanzado
- mejoras de navegación

## v1.0

Release pública.

Incluye:

- 5 modos de entrenamiento
- historial completo
- arquitectura estable
- experiencia offline completa

---

# 💎 Funciones Premium (futuras)

Planeadas para versión premium:

Estadísticas avanzadas

- progreso semanal
- tiempo entrenado por semana
- distribución por tipo de workout

Filtros de historial

- por tipo de workout
- por fecha
- por duración

Dashboard personal

```
Total workouts
Tiempo entrenado
Promedio por sesión
```
ib/
│
├── core/
│ ├── timer_phase.dart
│ ├── timer_ui_state.dart
│ ├── workout_type_extension.dart
│ └── audio/
│ └── sound_engine.dart
│
├── domain/
│ ├── definitions/
│ │ ├── amrap_definition.dart
│ │ ├── emom_definition.dart
│ │ ├── tabata_definition.dart
│ │ └── for_time_definition.dart
│ │
│ ├── runners/
│ │ └── segment_runner.dart
│ │
│ ├── entities/
│ │ └── workout_result.dart
│ │
│ └── enums/
│ └── workout_type.dart
│
├── data/
│ └── repositories/
│ └── workout_history_repository_impl.dart
│
├── presentation/
│ └── screens/
│ ├── timer_screen.dart
│ ├── workout_history_screen.dart
│ └── workout_detail_screen.dart
│
└── widgets/
└── central_timer.dart
```

---

# ⏱ Funcionamiento del Timer

Todos los modos se ejecutan mediante **SegmentRunner**.

Cada entrenamiento se transforma en una lista de segmentos:

```
WorkSegment
RestSegment
```

Ejemplo Tabata:

```
Work 20s
Rest 10s
Work 20s
Rest 10s
Work 20s
Rest 10s
...
```

El runner ejecuta cada segmento de forma secuencial.

---

# 🧩 Timer UI State

El runner emite un estado llamado:

TimerUiState

Campos principales:

```
remainingSeconds
phase
currentRound
totalRounds
phaseTotalSeconds
isPaused
isFinished
```

Este estado se transmite mediante:

```
Stream<TimerUiState>
```

La UI escucha el stream para actualizar el timer.

---

# 🗂 Historial de Entrenamientos

Cada entrenamiento genera un objeto:

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

Ejemplo almacenado:

```
{
"type": "forTime",
"totalSeconds": 455,
"metadata": {
"timeCapSeconds": 600
}
}
```

---

# 📊 Visualización del Historial

El historial muestra información resumida del workout.

Ejemplo TABATA:

```
TABATA
8 rondas · 20s / 10s
2026-03-04
04:00
```

Ejemplo FOR TIME:

```
FOR TIME
Time Cap 10:00
2026-03-04
07:35
```

Esto permite entender el entrenamiento sin abrir el detalle.

---

# 🧾 Detalle de Entrenamiento

La pantalla de detalle muestra:

- tiempo total
- configuración del workout
- fecha
- notas del usuario

Para Tabata se muestra:

```
Rondas
Trabajo
Descanso
```

Para For Time se muestra:

```
Time Cap
Fecha
```

---

# 🧭 Roadmap

## v0.6

Mejoras visuales

- iconos por tipo de workout
- optimización visual del historial
- mejoras del timer

## v0.7

Nuevo modo:

MIX

Permite encadenar workouts.

Ejemplo:

```
AMRAP 5:00
REST 1:00
EMOM 10
REST 2:00
FOR TIME 8:00
```

## v0.8

Mejoras UX

- animaciones del timer
- historial visual avanzado
- mejoras de navegación

## v1.0

Release pública.

Incluye:

- 5 modos de entrenamiento
- historial completo
- arquitectura estable
- experiencia offline completa

---

# 💎 Funciones Premium (futuras)

Planeadas para versión premium:

Estadísticas avanzadas

- progreso semanal
- tiempo entrenado por semana
- distribución por tipo de workout

Filtros de historial

- por tipo de workout
- por fecha
- por duración

Dashboard personal

```
Total workouts
Tiempo entrenado
Promedio por sesión
```
