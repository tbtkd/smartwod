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

El orden real es:

W1 → sin descanso  
D1 → descanso bloque 2  
W2 → trabajo bloque 2  
D2 → descanso bloque 3  
W3 → trabajo bloque 3  
FIN

El descanso pertenece siempre al bloque siguiente.

---

### Motor temporal

- Basado en DateTime (no Stopwatch)
- Permite precisión real incluso si la app va a background
- Cálculo periódico con Timer de 250ms
- Sin drift acumulativo
- Sin reinicios al pausar
- Pausa no permitida en fase rest
- Barra global sincronizada con tiempo real

---

## 3. SISTEMA DE AUDIO

Implementación actual:

- SoundEngine inyectado en AmrapRunner
- AudioPlayer con ReleaseMode.stop
- Countdown único disparado al llegar a 3 segundos
- Well Done reproducido después de emitir estado finished
- No se modifica esta lógica sin análisis previo

Audio ya sincronizado y estable.

---

## 4. ESTRUCTURA ACTUAL

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

## 5. DECISIONES TÉCNICAS CONSOLIDADAS

- DateTime se mantiene sobre Stopwatch
- Audio desacoplado
- Runner independiente de UI
- No usar variables redundantes
- No instanciar dependencias dentro de build()
- Limpieza de código muerto realizada

---

## 6. PRÓXIMA EVOLUCIÓN

1. Convertir WorkoutRunner en base extensible
2. Implementar EmomRunner
3. Implementar TabataRunner
4. Implementar ForTimeRunner
5. Introducir Clean Architecture formal
6. Migrar almacenamiento a solución más robusta

---

SMARTWOD prioriza estabilidad estructural antes de expansión funcional.
