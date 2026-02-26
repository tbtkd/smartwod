# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la creación
y ejecución precisa de entrenamientos funcionales tipo WOD.

Versión actual: 0.3.0-beta  
Estado: Beta Técnica Estable (AMRAP + EMOM consolidados)

---

## 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta profesional para atletas
y entrenadores que necesitan:

- Precisión temporal real
- Ejecución estable sin drift
- Flujo correcto de trabajo y descanso
- Identidad visual por modo
- Registro automático de entrenamientos
- Arquitectura preparada para escalar

El enfoque principal es consolidación estructural antes de expansión funcional.

---

## 🏗 Estado Actual

**Fase:** Beta Técnica Estable  
**Modos activos:**
- AMRAP
- EMOM

**Motor temporal:** Estable y desacoplado  
**Audio:** Sin duplicaciones ni loops  
**Arquitectura:** RunnerBuilder + Stream  
**Persistencia:** Funcional y consistente  

---

## 🏋️ AMRAP – Implementación

Flujo estructural:

W1 → sin descanso  
D1 → descanso bloque 2  
W2 → trabajo bloque 2  
D2 → descanso bloque 3  
W3 → trabajo bloque 3  
FIN  

Características:

- Configuración dinámica de bloques
- Descanso opcional
- Countdown automático en 3
- Pausa solo en Work
- Rest no permite pausa
- Barra global precisa
- Identidad visual naranja
- Persistencia automática

---

## 🔵 EMOM – Implementación

Características:

- Rondas configurables
- Duración configurable por ronda
- Preview dinámico de tiempo total
- Countdown sincronizado
- Identidad visual azul
- Persistencia automática
- Integración completa con TimerScreen unificado

---

## 🎨 Sistema Visual por Modo

AMRAP → Naranja  
EMOM → Azul  

Countdown utiliza el color del modo.  
Barra de progreso global mantiene coherencia visual.

---

## ⏱ Motor de Ejecución

- Runner desacoplado de UI
- Comunicación vía Stream<TimerUiState>
- TimerScreen recibe runnerBuilder
- Máquina de estados:
  - work
  - rest
  - paused
  - finished
- Countdown disparado únicamente cuando remaining == 3
- No se utilizan comparaciones <=
- No se corta audio manualmente
- No hay loops de sonido

---

## 🔊 Sistema de Audio

SoundEngine desacoplado:

- Dos AudioPlayer separados
- ReleaseMode.stop
- Preload de assets
- Countdown único en segundo 3
- Well Done al finalizar

---

## 💾 Persistencia

- Guardado automático al finalizar
- Historial por tipo de entrenamiento
- WorkoutType integrado en navegación

---

## 🧠 Arquitectura Actual

lib/
├── core/
│   ├── timer_phase.dart
│   └── timer_ui_state.dart
├── domain/
│   ├── runners/
│   │   ├── amrap_runner.dart
│   │   └── emom_runner.dart
│   └── entities/
├── data/
├── presentation/
│   └── screens/
├── widgets/

Separación por capas consolidada:

- Core → Estado y fases
- Domain → Runners
- Presentation → UI
- Data → Persistencia

---

# 📈 ROADMAP OFICIAL ACTUALIZADO

## Fase 1 – Consolidación del Core (COMPLETADA)

✔ AMRAP estable  
✔ EMOM estable  
✔ Audio sincronizado  
✔ Stream-based runner  
✔ Identidad visual por modo  
✔ Persistencia funcional  

---

## Fase 2 – Arquitectura por Segmentos (SIGUIENTE)

Objetivo:
Convertir el motor en ejecutor genérico de segmentos.

1. Crear WorkoutSegment
2. Crear WorkoutDefinition
3. Hacer que runners construyan segmentos
4. Unificar lógica temporal en un motor común
5. Eliminar duplicación entre runners

Esto permitirá:

- Tabata sin duplicar lógica
- For Time sin crear runner complejo
- Modo Mixed estructuralmente limpio

---

## Fase 3 – Nuevos Modos

- Tabata (validación del motor por segmentos)
- For Time
- Mixed

---

## Fase 4 – Profesionalización

- Persistencia robusta (Hive / Isar)
- Exportación de historial
- Métricas por sesión
- Refinamiento UI global
- Sistema de temas centralizado

---

## Fase 5 – Versión 1.0.0

- Optimización final
- Publicación Play Store
- Versión estable pública

---

SMARTWOD está evolucionando de temporizador funcional
a motor profesional de ejecución de entrenamientos.