# EMMORA — MASTER DEVELOPMENT CONTEXT

Documento maestro de contexto del proyecto.

Este archivo permite continuar el desarrollo del proyecto en nuevas sesiones
de trabajo o con herramientas de IA sin perder información importante.

Debe utilizarse como **contexto inicial** cuando se inicie una nueva conversación
sobre el desarrollo de la aplicación.

---

# 1. INFORMACIÓN GENERAL

Nombre del proyecto: **Emmora**

Tipo de aplicación:
Timer de entrenamientos funcionales tipo WOD.

Plataforma:
Flutter

Estado actual:
Testing con usuarios.

Versión actual:
**0.9 Beta**

Objetivo inmediato:
Preparar la aplicación para **release 1.0**.

---

# 2. VISIÓN DEL PROYECTO

Emmora busca ser un temporizador profesional para entrenamientos funcionales.

Debe ofrecer:

- temporización precisa
- visibilidad clara a distancia
- estabilidad total
- funcionamiento offline
- historial de entrenamientos
- simplicidad de uso en gimnasio

Principios del producto:

1. precisión temporal
2. interfaz minimalista
3. arquitectura escalable

---

# 3. MODOS DE ENTRENAMIENTO

Actualmente implementados:

AMRAP  
EMOM  
TABATA  
FOR TIME

Cada modo utiliza el mismo motor interno de ejecución.

---

# 4. ARQUITECTURA DEL SISTEMA

El sistema utiliza una arquitectura basada en segmentos.

Flujo:

WorkoutDefinition  
↓  
WorkoutStructure  
↓  
SegmentRunner  
↓  
TimerScreen  
↓  
TimerUiState  
↓  
UI  
↓  
WorkoutResult  
↓  
WorkoutHistory

Ventajas:

- evita duplicación de lógica
- permite agregar nuevos modos fácilmente
- separa lógica de UI

---

# 5. MOTOR DE ENTRENAMIENTOS

El motor está basado en **SegmentRunner**.

Cada entrenamiento se transforma en una lista de segmentos:

WorkSegment  
RestSegment

Ejemplo TABATA:

Work 20  
Rest 10  
Work 20  
Rest 10  
Work 20  
Rest 10  

El runner ejecuta los segmentos secuencialmente.

---

# 6. TIMER UI STATE

El estado emitido por el runner contiene:

remainingSeconds  
phase  
currentRound  
totalRounds  
phaseTotalSeconds  
isPaused  
isFinished  

La UI escucha estos cambios mediante:

Stream<TimerUiState>

---

# 7. PANTALLAS PRINCIPALES

HomeScreen  
Selección de modo de entrenamiento.

Config Screens
Configuración específica por modo.

TimerScreen  
Pantalla principal del temporizador.

WorkoutHistoryScreen  
Historial de entrenamientos.

WorkoutDetailScreen  
Detalle de entrenamiento con notas.

---

# 8. HISTORIAL DE ENTRENAMIENTOS

Entidad principal:

WorkoutResult

Campos:

type  
date  
totalSeconds  
metadata  
note  

Metadata depende del tipo de workout.

Ejemplo For Time:

{
"timeCapSeconds": 600
}


---

# 9. FUNCIONES IMPLEMENTADAS

Actualmente la app incluye:

- countdown previo
- sonidos de countdown
- vibración háptica
- pausa/resume
- finalización manual en For Time
- historial persistente
- detalle de entrenamientos
- notas editables
- iconos por tipo de workout
- temporizador grande visible a distancia

---

# 10. CAMBIOS RECIENTES

Cambios aplicados en versiones recientes:

- mejora del tamaño del temporizador
- iconos en HomeScreen
- icono de pausa cuando el timer está pausado
- vibración háptica en cambios de fase
- caja de notas expandible
- mejoras visuales del historial
- nombre del proyecto cambiado a **Emmora**

---

# 11. ROADMAP DEL PRODUCTO

v1.0

Release pública.

Incluye:

- 4 modos de entrenamiento
- historial completo
- notas
- arquitectura estable
- funcionamiento offline

---

v1.1

Mejoras UX.

- mejoras visuales
- countdown mejorado
- animaciones del timer

---

v1.2

Funciones avanzadas.

- builder de intervalos
- sonidos personalizables

---

v2.0

Modo MIX.

Permitirá combinar workouts.

Ejemplo:

AMRAP → REST → EMOM → REST → FOR TIME

---

# 12. ESTRATEGIA PREMIUM

Emmora seguirá un modelo **freemium**.

Versión gratuita:

- AMRAP
- EMOM
- TABATA
- FOR TIME
- historial básico
- notas

Versión premium incluirá:

estadísticas avanzadas  
progreso semanal  
filtros de historial  
dashboard personal  
workouts mixtos  

---

# 13. PRINCIPIOS DE DESARROLLO

Reglas del proyecto:

1. evitar duplicación de lógica
2. mantener separación de capas
3. mantener el motor independiente de la UI
4. documentar cambios importantes

---

# 14. OBJETIVO ACTUAL

Preparar **Emmora v1.0**

Tareas pendientes:

- ajustes finales de UI
- optimización visual del timer
- pruebas con usuarios
- generación de APK para testing