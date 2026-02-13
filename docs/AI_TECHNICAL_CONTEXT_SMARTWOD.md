# SMARTWOD --- CONTEXTO TÉCNICO PARA IA (VERSIÓN ACTUAL)

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD\
Framework: Flutter\
Plataforma principal: Android (iOS futuro)\
Dominio: Fitness / Temporizador tipo CrossFit (AMRAP)\
Estado: Base funcional estable pre-v1.0

------------------------------------------------------------------------

## 2. ESTADO ACTUAL CONFIRMADO (CRÍTICO)

✔ El proyecto compila correctamente\
✔ Countdown inicial de 10 segundos funcional\
✔ Flujo AMRAP estable\
✔ Trabajo y descanso secuenciales correctos\
✔ Progreso por bloque (círculo decreciente) funcionando\
✔ Barra de progreso global implementada\
✔ Pantalla final funcional\
✔ Sin integración de audio (pendiente futuro)

⚠ Proyecto actualmente enfocado en UI/UX refinado, no en cambios
estructurales profundos.

------------------------------------------------------------------------

## 3. ARQUITECTURA (NO ROMPER)

Principios estrictos:

-   UI NO maneja tiempo
-   Runner NO conoce widgets
-   TimerUiState es la única fuente de verdad
-   No duplicar lógica entre capas
-   No introducir estados innecesarios

Separación clara: - core → lógica - screens → composición UI - widgets →
componentes visuales reutilizables

------------------------------------------------------------------------

## 4. ESTRUCTURA REAL DEL PROYECTO

lib/ core/ amrap_block.dart amrap_runner.dart timer_ui_state.dart
screens/ amrap_config_screen.dart timer_screen.dart
workout_finished_screen.dart widgets/ central_timer.dart
duration_picker_dialog.dart main.dart

------------------------------------------------------------------------

## 5. MODELO DE ESTADO ACTUAL

enum TimerPhase { rest, work, paused, finished }

class TimerUiState { final int remainingSeconds; final int currentRound;
final int totalRounds; final TimerPhase phase; }

Notas: - paused existe solo como estado visual - finished dispara
navegación a pantalla final - No existe estado idle en el runner

------------------------------------------------------------------------

## 6. AMRAP RUNNER (LÓGICA CENTRAL)

Responsabilidades: - Ejecutar bloques secuenciales - Controlar
transiciones trabajo → descanso → trabajo - Emitir TimerUiState vía
callback - Calcular progreso global - Controlar pausa / reanudación

NO: - No renderiza UI - No navega - No conoce widgets

Propiedades clave: - totalWorkoutSeconds - globalProgress -
currentBlockTotalSeconds

------------------------------------------------------------------------

## 7. TIMER SCREEN (UI PRINCIPAL)

Responsabilidades: - Mostrar countdown inicial - Mostrar fase actual
(Amrap / Descanso) - Mostrar progreso circular decreciente - Mostrar
barra de progreso global - Gestionar interacción tap → pause/resume -
Navegar a pantalla final al finalizar

Regla crítica: La UI reacciona al estado. Nunca calcula tiempo por su
cuenta.

------------------------------------------------------------------------

## 8. FUNCIONALIDADES IMPLEMENTADAS

✔ Countdown inicial ✔ Progreso decreciente por bloque ✔ Barra de
progreso global ✔ Pantalla final con resumen ✔ Animaciones suaves en
textos (AnimatedSwitcher) ✔ Cambio de color por fase ✔ Separación
correcta lógica/UI

------------------------------------------------------------------------

## 9. PENDIENTE ANTES DE v1.0

1.  Refinar pantalla final (más estadísticas)
2.  Mejorar transiciones visuales entre fases
3.  Ajustes finos de jerarquía visual
4.  Integración de sonido (3,2,1 y cambio de fase)
5.  Optimización menor de rendimiento

------------------------------------------------------------------------

## 10. RESTRICCIONES ABSOLUTAS

-   NO romper compilación
-   NO modificar lógica sin autorización explícita
-   NO inventar estados nuevos innecesarios
-   SIEMPRE entregar archivos completos cuando se modifique algo
-   Mantener coherencia con arquitectura actual

------------------------------------------------------------------------

## 11. INSTRUCCIÓN PARA FUTURA IA

Este proyecto se encuentra en estado estable. Continuar desde aquí
respetando:

-   Separación lógica/UI
-   Flujo actual del runner
-   Modelo de estado existente
-   Progreso global ya implementado

El enfoque actual es refinamiento visual y preparación para versión 1.0.
