
# WORKOUT_ENGINE.md
SMARTWOD — Motor de Ejecución de Entrenamientos

Este documento explica el funcionamiento interno del motor de ejecución
de entrenamientos de SMARTWOD.

El motor es el **núcleo del sistema**, responsable de ejecutar los
intervalos de tiempo de todos los modos de entrenamiento.

---

# 1. Concepto del Motor

El motor se basa en una arquitectura de **segmentos de ejecución**.

Un entrenamiento no se ejecuta como una lógica independiente,
sino como una **lista de segmentos secuenciales**.

Ejemplo conceptual:

Work → Rest → Work → Rest → Work

Cada uno de estos pasos es un **segmento**.

---

# 2. Tipos de Segmentos

Actualmente existen dos tipos principales:

WorkSegment

representa una fase activa del entrenamiento.

RestSegment

representa una fase de descanso.

Cada segmento contiene:

durationSeconds

tipo de fase

---

# 3. Flujo del Motor

El flujo de ejecución es:

Definition
↓
WorkoutStructure
↓
SegmentRunner
↓
TimerUiState
↓
UI

---

# 4. SegmentRunner

SegmentRunner es el componente que ejecuta el entrenamiento.

Responsabilidades:

- ejecutar los segmentos uno a uno
- manejar el contador de tiempo
- cambiar entre fases
- emitir actualizaciones del estado
- calcular progreso global

---

# 5. TimerUiState

El estado emitido por el runner contiene:

remainingSeconds
phase
currentRound
totalRounds
phaseTotalSeconds
isPaused
isFinished

Este estado se transmite mediante un Stream.

La UI solo escucha el estado y renderiza el timer.

---

# 6. Pausa

La pausa solo se permite durante la fase:

work

No se permite pausa durante:

rest

Esto evita inconsistencias en el flujo del entrenamiento.

---

# 7. Finalización del Entrenamiento

Cuando se ejecutan todos los segmentos:

phase → finished

El runner emite el estado final y el TimerScreen
guarda el resultado en el historial.

---

# 8. For Time — Finalización Manual

El modo For Time permite terminar manualmente el entrenamiento.

El tiempo real se calcula así:

elapsedSeconds =
configuredSeconds - remainingSeconds

Esto permite registrar el tiempo real completado.

---

# 9. Ventajas de esta Arquitectura

Esta arquitectura permite:

- reutilizar el motor entre modos
- agregar nuevos entrenamientos fácilmente
- evitar duplicación de lógica
- mantener el código simple

---

# 10. Expansión Futura

El motor permitirá implementar:

Modo MIX

Ejemplo:

AMRAP → Rest → EMOM → Rest → For Time

Solo será necesario generar los segmentos correspondientes.

El motor no necesita modificaciones.
