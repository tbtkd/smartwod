# SMARTWOD --- CONTEXTO TÉCNICO Y PLAN DE EVOLUCIÓN

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD\
Tipo: Aplicación móvil Flutter\
Estado actual: Beta Técnica Interna Avanzada\
Arquitectura: Modular, en transición hacia separación por capas

------------------------------------------------------------------------

## 2. ARQUITECTURA ACTUAL

### Core (Dominio funcional actual)

Contiene la lógica principal del entrenamiento.

-   amrap_runner.dart → Motor del entrenamiento
-   amrap_block.dart → Modelo de bloque
-   timer_ui_state.dart → Estado del temporizador

Responsabilidades del runner:

-   Control de fases (work / rest / paused / finished)
-   Manejo de pausa (solo en trabajo)
-   Progreso global
-   Transición automática entre bloques
-   Integración con sistema de sonido
-   Precisión temporal basada en referencia real (anti-drift)

------------------------------------------------------------------------

### Models

-   workout_history_entry.dart → Entidad de historial

------------------------------------------------------------------------

### Screens

-   home_screen.dart → Pantalla principal
-   amrap_config_screen.dart → Configuración dinámica
-   timer_screen.dart → Ejecución del entrenamiento
-   workout_finished_screen.dart → Resumen final
-   workout_history_screen.dart → Historial global
-   workout_stats_screen.dart → Estadísticas acumuladas

------------------------------------------------------------------------

### Widgets

-   central_timer.dart → Componente visual principal del contador
-   duration_picker_dialog.dart → Selector avanzado de tiempo
-   amrap_block_card.dart → Tarjeta de configuración de bloque
-   wod_button.dart → Botón reutilizable para modos WOD

------------------------------------------------------------------------

### Utils (Capa de servicios actual)

-   feedback_service.dart → Gestión de sonido
-   workout_persistence_service.dart → Persistencia de entrenamiento
    activo
-   workout_history_service.dart → Persistencia de historial

Persistencia actual basada en SharedPreferences.

------------------------------------------------------------------------

## 3. ESTADO TÉCNICO ACTUAL

✔ Runner estable\
✔ Precisión temporal mejorada\
✔ UI refinada con animaciones\
✔ Persistencia activa\
✔ Historial funcional\
✔ Estadísticas acumuladas\
✔ Arquitectura modular preparada para expansión

------------------------------------------------------------------------

## 4. PLAN DE MIGRACIÓN ARQUITECTÓNICA

El crecimiento del proyecto requiere separación clara de
responsabilidades.

### Objetivo

Transicionar hacia una arquitectura por capas:

-   Domain (lógica pura de negocio)
-   Data (persistencia)
-   Presentation (UI)

------------------------------------------------------------------------

### Fase 1 --- Abstracción de dominio

-   Crear interfaz base WorkoutRunner
-   Desacoplar sonido mediante inyección de dependencia
-   Crear entidad WorkoutResult independiente del runner

------------------------------------------------------------------------

### Fase 2 --- Repositorios

-   Reemplazar servicios estáticos por repositorios inyectables
-   Introducir WorkoutHistoryRepository
-   Separar acceso a almacenamiento del resto de la app

------------------------------------------------------------------------

### Fase 3 --- Migración de almacenamiento

Migrar de SharedPreferences a:

-   Hive (recomendado por simplicidad) o
-   Isar (si se requiere alto rendimiento y escalabilidad)

Ventajas:

-   Paginación
-   Consultas eficientes
-   Escalabilidad sin límite práctico
-   Mejor rendimiento con grandes volúmenes de datos

------------------------------------------------------------------------

### Fase 4 --- Escalabilidad funcional

Implementación futura de:

-   EMOM
-   Tabata
-   For Time
-   MIX
-   Plantillas guardadas
-   Estadísticas avanzadas
-   Filtros por tipo de WOD

------------------------------------------------------------------------

## 5. CONSIDERACIONES DE ESCALABILIDAD

Actualmente SharedPreferences es suficiente para uso normal.

Riesgos potenciales a largo plazo:

-   JSON grande puede afectar tiempos de carga
-   Decodificación completa en memoria
-   No soporta consultas parciales

Recomendación: Migrar antes de superar \~5,000 entrenamientos
almacenados.

------------------------------------------------------------------------

Este documento refleja el estado técnico actual y la hoja de ruta
estructural para evolución sostenible del proyecto SMARTWOD.
