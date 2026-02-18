# SMARTWOD --- CONTEXTO TÉCNICO PARA IA

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD\
Tipo: Aplicación móvil Flutter\
Estado actual: Beta Técnica Interna\
Arquitectura: Modular por capas

------------------------------------------------------------------------

## 2. ARQUITECTURA ACTUAL

### Core

Contiene la lógica de negocio principal.

-   amrap_runner.dart → Motor del entrenamiento
-   amrap_block.dart → Modelo de bloque
-   timer_ui_state.dart → Estado del temporizador

Responsabilidades del runner:

-   Control de fases (work / rest / paused / finished)
-   Manejo de pausa (solo en trabajo)
-   Progreso global
-   Transición automática entre bloques
-   Integración con sistema de sonido

------------------------------------------------------------------------

### Screens

-   amrap_config_screen.dart → Configuración dinámica
-   timer_screen.dart → Ejecución del entrenamiento
-   workout_finished_screen.dart → Resumen final

------------------------------------------------------------------------

### Widgets

-   central_timer.dart → Componente visual principal del contador
-   duration_picker_dialog.dart → Selector avanzado de tiempo
-   amrap_block_card.dart → Tarjeta de configuración de bloque

------------------------------------------------------------------------

### Utils

-   feedback_service.dart → Gestión de sonido

El sistema de sonido actualmente:

-   Se ejecuta en cambio de fase
-   Se ejecuta al finalizar entrenamiento
-   Está integrado directamente con el runner

------------------------------------------------------------------------

## 3. ESTADO TÉCNICO ACTUAL

✔ Arquitectura modular ✔ Runner estable ✔ UI refinada con animaciones ✔
AnimatedList funcional ✔ Selector con scroll optimizado ✔ Sistema de
sonido activo ✔ Flujo completo estable

------------------------------------------------------------------------

## 4. ÁREAS DE MEJORA FUTURA

-   Desacoplar sonido mediante inyección de dependencia
-   Implementar debounce en eventos de audio
-   Añadir persistencia local
-   Añadir gestión de estado global
-   Implementar pruebas unitarias
-   Preparación para escalabilidad

------------------------------------------------------------------------

Este documento refleja el estado real del proyecto en su versión Beta
Técnica Interna.
