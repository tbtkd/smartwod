# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la creación
y ejecución de entrenamientos funcionales tipo WOD, comenzando con modalidad
AMRAP (As Many Rounds As Possible) y diseñada para escalar a múltiples formatos
como EMOM, Tabata y For Time.

------------------------------------------------------------------------

## 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta profesional para atletas y
entrenadores que desean:

- Crear entrenamientos personalizados
- Ejecutarlos con precisión temporal real
- Registrar historial completo
- Escalar a múltiples modalidades de WOD
- Mantener arquitectura sólida y sostenible

La aplicación está construida con enfoque en estabilidad, precisión,
modularidad y crecimiento estructural.

------------------------------------------------------------------------

## 🏗 Estado Actual

**Fase:** Beta Técnica Interna Avanzada  
**Motor:** Estable con precisión temporal anti-drift  
**Arquitectura:** Modular, en transición a separación por capas  

### Funcionalidades implementadas

#### 🏋️ AMRAP

- Configuración dinámica de bloques
- Descanso opcional por bloque
- Selector avanzado de tiempo (minutos/segundos)
- Validaciones mínimas de duración
- Cálculo automático del tiempo total
- AnimatedList con transiciones suaves

#### ⏱ Motor de ejecución

- Runner desacoplado de la UI
- Máquina de estados controlada
- Precisión temporal basada en referencia real
- Countdown previo al inicio
- Pausa inteligente
- Barra de progreso global

#### 🔊 Audio

- Sonido en cambio de fase
- Sonido al finalizar entrenamiento
- Sistema pre-cargado
- Optimización de sincronización en proceso
- Plan de desacoplamiento mediante inyección de dependencia

#### 💾 Persistencia

- Guardado automático del entrenamiento activo
- Restauración básica al reabrir la app
- Registro automático en historial
- Persistencia basada en SharedPreferences (temporal)

#### 📊 Historial

- Registro de entrenamientos completados
- Vista detallada con desglose por bloques
- Notas editables por entrenamiento

------------------------------------------------------------------------

## 🧠 Arquitectura

Estructura actual modular organizada por responsabilidades:

lib/
├── core/
├── models/
├── screens/
├── widgets/
└── utils/

El proyecto está en transición hacia arquitectura por capas:

- Domain
- Data
- Presentation

------------------------------------------------------------------------

## 📈 Roadmap Prioritario

1. Optimización completa de sincronización de audio
2. Abstracción de WorkoutRunner base
3. Implementación Clean Architecture real
4. Migración de almacenamiento a Hive / Isar
5. Implementación de EMOM
6. Implementación de Tabata
7. Implementación de For Time
8. Estadísticas avanzadas (versión futura)

------------------------------------------------------------------------

## 🛠 Tecnologías

- Flutter
- Dart
- SharedPreferences (temporal)
- Arquitectura modular en evolución

------------------------------------------------------------------------

SMARTWOD es un proyecto en evolución con enfoque en calidad técnica,
precisión temporal y crecimiento estructural sostenible.
