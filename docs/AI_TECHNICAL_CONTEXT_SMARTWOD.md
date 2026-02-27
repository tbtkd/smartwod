# SMARTWOD — CONTEXTO TÉCNICO ACTUAL

---

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD  
Plataforma: Flutter  
Versión actual: 0.4.0-beta  
Estado: Motor Segmentado Unificado  
Modos activos: AMRAP + EMOM  

Enfoque actual:
Expansión funcional sobre arquitectura consolidada.

---

## 2. MOTOR TEMPORAL ACTUAL

### Modelo de ejecución

- Definition construye estructura
- SegmentRunner ejecuta segmentos
- Comunicación vía Stream<TimerUiState>
- TimerScreen no conoce la implementación interna
- Comunicación desacoplada

Arquitectura:

    WorkoutDefinition
    ↓
    WorkoutStructure
    ↓
    SegmentRunner
    ↓
    TimerScreen


---

## 3. MÁQUINA DE ESTADOS

TimerPhase:

- work
- rest
- paused
- finished

Reglas:

- Pausa solo permitida en work
- Countdown se dispara al cruzar segundo 3
- Countdown activo en work y rest
- Finalización dispara sonido y estado finished

---

## 4. SEGMENTRUNNER

Responsabilidades:

- Ejecutar segmentos secuencialmente
- Calcular remaining vía DateTime
- Mantener progreso global
- Emitir TimerUiState
- Manejar transición automática entre segmentos
- Disparar countdown
- Manejar finalización

Protecciones añadidas:

- Validación defensiva de índices
- Protección contra setState después de dispose
- Cancelación adecuada de timers

---

## 5. SISTEMA DE AUDIO

- SoundEngine inyectado
- Dos AudioPlayer independientes
- ReleaseMode.stop
- Countdown único
- Well Done en finished
- Sin loops ni duplicaciones

---

## 6. DIFERENCIACIÓN VISUAL

AMRAP → Colors.orange  
EMOM → Colors.blueAccent  

Uso actualizado de:
 - withValues(alpha: x)

Reemplazando withOpacity() (deprecated).

---

## 7. ESTRUCTURA DE DOMINIO

Definitions:

- workout_definition.dart
- workout_structure.dart
- workout_segment.dart
- amrap_definition.dart
- emom_definition.dart

Runner:

- segment_runner.dart

Eliminados:

- AmrapRunner
- EmomRunner

---

## 8. ESTADO (TimerUiState)

Contiene:

- remainingSeconds
- phaseTotalSeconds
- currentRound
- totalRounds
- phase
- isPaused

No fue modificado en la migración.
Se mantiene contrato estable con UI.

---

## 9. ESTADO ACTUAL DE LA ARQUITECTURA

Duplicación temporal: Eliminada  
Motor: Unificado  
UI: Desacoplada  
Persistencia: Estable  
Lifecycle: Corregido  

---

## 10. SIGUIENTE EVOLUCIÓN

Implementar:

- TabataDefinition (segmentos repetitivos work/rest)
- ForTimeDefinition (modo open-ended)

El motor actual permite añadir nuevos modos sin modificar SegmentRunner.

---

## 11. OBJETIVO ESTRATÉGICO

Transformar SMARTWOD en:

Un motor profesional configurable de ejecución temporal
capaz de soportar múltiples estructuras de entrenamiento
sin alterar la lógica central.