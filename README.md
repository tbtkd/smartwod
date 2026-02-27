# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la creación
y ejecución precisa de entrenamientos funcionales tipo WOD.

Versión actual: 0.4.0-beta  
Estado: Motor Unificado por Segmentos (AMRAP + EMOM consolidados)

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

**Fase:** 0.4.0-beta  
**Modos activos:**
- AMRAP
- EMOM

**Motor temporal:** Segmentado y unificado  
**Audio:** Sin duplicaciones ni loops  
**Arquitectura:** Definition → SegmentRunner → TimerScreen  
**Persistencia:** Funcional y consistente  

---

## 🧠 Evolución Arquitectónica (0.4.0-beta)

Se eliminó la lógica duplicada entre runners específicos y se implementó un
motor unificado basado en segmentos.

Nueva estructura:

lib/
├── core/
│ ├── timer_phase.dart
│ └── timer_ui_state.dart
├── domain/
│ ├── definitions/
│ │ ├── workout_definition.dart
│ │ ├── workout_structure.dart
│ │ ├── workout_segment.dart
│ │ ├── amrap_definition.dart
│ │ └── emom_definition.dart
│ └── runners/
│ ├── workout_runner.dart
│ └── segment_runner.dart
├── data/
├── presentation/
└── widgets/


Separación por capas consolidada:

- Core → Estado y fases
- Domain → Definitions + Motor
- Presentation → UI
- Data → Persistencia

---

# 📈 ROADMAP ACTUALIZADO

## Fase 1 – Consolidación del Core (COMPLETADA)

✔ AMRAP estable  
✔ EMOM estable  
✔ Audio sincronizado  
✔ Stream-based runner  
✔ Persistencia funcional  

---

## Fase 2 – Arquitectura por Segmentos (COMPLETADA)

✔ WorkoutDefinition  
✔ WorkoutStructure  
✔ WorkoutSegment  
✔ SegmentRunner unificado  
✔ Eliminación de runners duplicados  
✔ Validaciones defensivas  
✔ Correcciones de lifecycle  

---

## Fase 3 – Nuevos Modos (SIGUIENTE)

- Tabata (validación final del motor segmentado)
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

SMARTWOD ha evolucionado de temporizador funcional
a motor profesional configurable de ejecución temporal.