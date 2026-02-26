# SMARTWOD — CONTEXTO TÉCNICO ACTUAL

---

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD  
Plataforma: Flutter  
Versión actual: 0.3.0-beta  
Estado: Beta Técnica Estable  
Modos activos: AMRAP + EMOM  

Enfoque actual:
Consolidar arquitectura antes de expandir modos.

---

## 2. MOTOR TEMPORAL ACTUAL

### Modelo de ejecución

- Runner comunica estado vía Stream<TimerUiState>
- TimerScreen recibe runnerBuilder
- TimerScreen no conoce la implementación interna del runner
- Comunicación desacoplada

### Máquina de estados

TimerPhase:

- work
- rest
- paused
- finished

---

## 3. SISTEMA DE AUDIO

Implementación:

- SoundEngine inyectado en runner
- Dos AudioPlayer separados
- ReleaseMode.stop
- countdown_1.wav contiene 3-2-1 completo
- Countdown disparado únicamente cuando remaining == 3
- No se usan comparaciones <=
- No se corta el audio manualmente
- No hay duplicaciones ni loops
- Well Done en estado finished

Audio estable.

---

## 4. DIFERENCIACIÓN VISUAL POR MODO

CentralTimer recibe accentColor.

AMRAP → Colors.orange  
EMOM → Colors.blueAccent  

Countdown usa el color del modo.
Rest mantiene azul estándar.
Paused mantiene gris.
Finished mantiene verde.

---

## 5. ARQUITECTURA ACTUAL

Core:
- timer_phase.dart
- timer_ui_state.dart

Domain:
- WorkoutRunner (interfaz)
- AmrapRunner
- EmomRunner

Presentation:
- TimerScreen (unificado)
- ConfigScreens por modo
- CentralTimer

Data:
- WorkoutHistoryRepositoryImpl

---

## 6. DECISIONES CONSOLIDADAS

- DateTime sobre Stopwatch
- Stream sobre callbacks
- RunnerBuilder en TimerScreen
- No instanciar dependencias dentro de build()
- Countdown centralizado en runner
- Identidad visual desacoplada

---

## 7. PROBLEMA ARQUITECTÓNICO PENDIENTE

Actualmente:

Cada runner tiene su propia lógica temporal.

Objetivo siguiente:

Unificar ejecución por segmentos.

---

## 8. SIGUIENTE EVOLUCIÓN (FASE 2)

Crear arquitectura por segmentos:

abstract class WorkoutDefinition {
    int get totalSeconds;
    List<WorkoutSegment> buildSegments();
}

class WorkoutSegment {
    final TimerPhase phase;
    final int duration;
}

El runner ejecutará segmentos.
No ejecutará modos.

Esto permitirá:

- Tabata sin duplicación
- ForTime simple
- Mixed flexible
- Eliminación de lógica repetida

---

## 9. OBJETIVO ESTRATÉGICO

Transformar SMARTWOD en:

Un motor profesional de ejecución temporal configurable.

No solo una app con múltiples timers.

---

SMARTWOD se encuentra en un punto óptimo
para consolidar arquitectura antes de expandir funcionalidad.


Si quieres, ahora el siguiente paso fuerte sería:

👉 Diseñar WorkoutSegment y WorkoutDefinition formalmente
y convertir AMRAP y EMOM a ese modelo.

Ese es el salto serio de arquitectura.