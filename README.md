# SMARTWOD

Aplicación móvil desarrollada en Flutter para la creación y ejecución de
entrenamientos tipo AMRAP (As Many Rounds As Possible).

------------------------------------------------------------------------

## 📌 Estado actual del proyecto

SMARTWOD se encuentra en fase de **Beta Técnica Interna**.

El sistema es funcional, estable y modular, con refinamientos recientes
en experiencia de usuario, animaciones y arquitectura.

Actualmente incluye:

-   Configuración dinámica de bloques AMRAP
-   Soporte para múltiples bloques con descanso opcional
-   Selector avanzado de tiempo con scroll (minutos y segundos)
-   Validación de mínimos (15s trabajo / 5s descanso)
-   AnimatedList con inserción y eliminación animada
-   Cálculo automático del tiempo total
-   Motor de ejecución desacoplado de la UI
-   Sistema de sonido activo (cambio de fase y finalización)
-   Barra de progreso global
-   Pantalla final con resumen del entrenamiento

------------------------------------------------------------------------

## 🏗 Arquitectura del proyecto

Estructura actual:

lib/ ├── core/ │ ├── amrap_runner.dart │ ├── amrap_block.dart │ └──
timer_ui_state.dart │ ├── screens/ │ ├── amrap_config_screen.dart │ ├──
timer_screen.dart │ ├── workout_finished_screen.dart │ └── widgets/ │
└── amrap_block_card.dart │ ├── widgets/ │ ├── central_timer.dart │ └──
duration_picker_dialog.dart │ └── utils/ └── feedback_service.dart

------------------------------------------------------------------------

## 🔁 Flujo de la aplicación

1.  Configuración del entrenamiento
2.  Fase de preparación (countdown)
3.  Ejecución de bloques:
    -   Trabajo
    -   Descanso
4.  Finalización automática
5.  Pantalla de resumen

------------------------------------------------------------------------

## 🔊 Sistema de sonido

El sistema de sonido está activo y gestionado desde:

utils/feedback_service.dart

Actualmente se ejecuta en:

-   Cambio de fase (work ↔ rest)
-   Finalización del entrenamiento

Nota: Puede requerir optimización futura para evitar posibles desfases
en dispositivos específicos.

------------------------------------------------------------------------

## 🚀 Próximas mejoras planeadas

-   Persistencia local de configuración
-   Historial de entrenamientos
-   Guardado de plantillas
-   Configuración personalizada de sonidos
-   Desacoplamiento completo del sistema de audio
-   Preparación para publicación en tienda

------------------------------------------------------------------------

Proyecto desarrollado en Flutter.
