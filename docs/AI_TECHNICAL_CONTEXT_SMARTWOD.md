# SMARTWOD — CONTEXTO TÉCNICO ACTUAL

---

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD  
Plataforma: Flutter  
Estado actual: Beta Técnica Estable  
Modo activo: AMRAP completamente funcional  

Enfoque actual:
Consolidación estructural antes de expansión funcional.

---

## 2. ESTADO REAL DEL MOTOR AMRAP

### Flujo correcto implementado

W1 → sin descanso  
D1 → descanso bloque 2  
W2 → trabajo bloque 2  
D2 → descanso bloque 3  
W3 → trabajo bloque 3  
FIN  

El descanso pertenece siempre al bloque siguiente.

---

## 3. MOTOR TEMPORAL

- Basado en DateTime (no Stopwatch)
- Compatible con background
- Cálculo periódico con Timer de 250ms
- Sin drift acumulativo
- Sin reinicios al pausar
- Pausa no permitida en fase rest
- Barra global sincronizada con tiempo real

---

## 4. SISTEMA DE AUDIO

Implementación actual:

- SoundEngine inyectado en AmrapRunner
- Dos AudioPlayer separados
- ReleaseMode.stop
- Countdown disparado únicamente cuando remaining == 3
- countdown_1.wav contiene 3-2-1 completo
- No se utilizan comparaciones <=
- No se corta el audio manualmente
- No hay duplicaciones ni loops
- Well Done reproducido al finalizar estado finished

Audio sincronizado y estable.

---

## 5. ESTRUCTURA ACTUAL

Domain:
- AmrapRunner
- WorkoutRunner (interfaz)
- Entidades

Core:
- TimerUiState
- TimerPhase

Data:
- WorkoutHistoryRepositoryImpl

Presentation:
- TimerScreen
- ConfigScreen
- HistoryScreen

Widgets:
- CentralTimer
- WodButton

---

## 6. DECISIONES TÉCNICAS CONSOLIDADAS

- DateTime se mantiene sobre Stopwatch
- Audio desacoplado
- Runner independiente de UI
- Countdown centralizado
- No instanciar dependencias dentro de build()
- Limpieza de código muerto realizada
- Arquitectura preparada para múltiples runners

---

## 7. PRÓXIMA EVOLUCIÓN ESTRUCTURAL

Fase 2 – Arquitectura Escalable

1. Crear BaseRunner abstracto
2. Extraer PhaseEngine reutilizable
3. Unificar lógica temporal para EMOM / TABATA / FOR TIME
4. Agregar pruebas unitarias del motor

Fase 3 – Nuevos modos

- EMOM
- Tabata
- ForTime
- Mixed

Todos reutilizando el mismo CoreTimerEngine.

---

SMARTWOD prioriza estabilidad estructural antes de expansión funcional.
El motor AMRAP se considera consolidado en versión beta técnica.