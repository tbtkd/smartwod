
SMARTWOD — CONTEXTO TÉCNICO PARA IA

1. IDENTIDAD DEL PROYECTO
Nombre: SMARTWOD
Tipo: Aplicación móvil Flutter
Plataforma principal: Android (iOS posterior)
Dominio: Fitness / CrossFit timers
Estado: En desarrollo activo

2. OBJETIVO FUNCIONAL
SMARTWOD es un temporizador avanzado para entrenamientos tipo CrossFit, comenzando por AMRAP, con soporte para:
- Múltiples bloques de trabajo
- Bloques de descanso intermedios
- Ejecución secuencial automática
- UI clara, deportiva y usable en entrenamiento real
- Arquitectura desacoplada (lógica ≠ UI)

3. ARQUITECTURA (CRÍTICO)
Principios obligatorios:
- La UI no maneja lógica de tiempo
- El runner no maneja widgets
- TimerUiState es la única fuente de verdad
- Los efectos (sonido, vibración, color) reaccionan al estado
- No duplicar lógica de temporizador

4. ESTRUCTURA ACTUAL DEL PROYECTO

lib/
 app/
  smartwod_app.dart
 core/
  amrap_block.dart
  amrap_runner.dart
  timer_engine.dart
  timer_ui_state.dart
 models/
 screens/
  amrap_config_screen.dart
  home_screen.dart
  timer_screen.dart
  widgets/
 widgets/
  central_action.dart
  central_timer.dart
  circular_timer.dart
  wod_button.dart
 main.dart

5. FLUJO AMRAP IMPLEMENTADO
- Primer AMRAP: solo trabajo
- AMRAPs siguientes: descanso + trabajo
- Selector de tiempo en bloques de 15 segundos con rollover a minutos

6. RUNNER AMRAP
- Ejecuta bloques secuenciales
- Maneja trabajo y descanso
- Actualiza TimerUiState
- No depende de UI

7. ESTADO UI ACTUAL
- Temporizador funcional
- Progreso circular visible
- Pantalla AMRAP operativa

8. FUNCIONALIDADES PENDIENTES
- Countdown previo de 10 segundos antes de iniciar
- Contador en color azul tanto en trabajo como descanso
- Mostrar resumen de bloques y descansos bajo el contador
- Sonido y vibración por fase

9. RESTRICCIONES TÉCNICAS
- Mantener el proyecto compilable
- No rehacer arquitectura
- Entregar archivos completos al modificar
- Respetar decisiones previas

10. INSTRUCCIÓN FINAL PARA IA
Continuar el proyecto exactamente desde este estado, respetando arquitectura, estado actual y funcionalidades ya implementadas.
