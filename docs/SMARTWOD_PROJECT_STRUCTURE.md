
# PROJECT_STRUCTURE.md
SMARTWOD — Estructura del Proyecto

Este documento describe la estructura de carpetas del proyecto para facilitar
la comprensión del código.

## Estructura principal

lib/

core/
Contiene componentes reutilizables del sistema.

- timer_phase.dart
- timer_ui_state.dart
- workout_type_extension.dart
- audio/
  - sound_engine.dart

domain/
Contiene la lógica de negocio.

definitions/
- amrap_definition.dart
- emom_definition.dart
- tabata_definition.dart
- for_time_definition.dart

runners/
- segment_runner.dart

entities/
- workout_result.dart

enums/
- workout_type.dart

data/
Persistencia de datos.

repositories/
- workout_history_repository_impl.dart

presentation/
Pantallas de la aplicación.

screens/
- timer_screen.dart
- workout_history_screen.dart
- workout_detail_screen.dart

widgets/
Componentes visuales reutilizables.

- central_timer.dart

## Flujo de ejecución

Definition → Structure → Runner → UI → History

Este flujo permite separar responsabilidades y mantener el código modular.
