# SMARTWOD — CONTEXTO TÉCNICO PARA IA (ACTUALIZADO)

## 1. IDENTIDAD DEL PROYECTO
Nombre: SMARTWOD  
Tipo: Aplicación móvil Flutter  
Plataforma principal: Android (iOS posterior)  
Dominio: Fitness / CrossFit timers  
Estado: En desarrollo activo (base funcional estable)

## 2. ESTADO ACTUAL CONFIRMADO (CRÍTICO)
- El proyecto compila correctamente
- El temporizador baja correctamente
- Flujo AMRAP estable
- Countdown inicial de 10 segundos
- Trabajo actual enfocado SOLO en UI/UX
- No cambiar APIs existentes

## 3. OBJETIVO FUNCIONAL
Temporizador avanzado para entrenamientos tipo CrossFit (AMRAP inicialmente), con:
- Múltiples bloques de trabajo
- Descansos intermedios
- Ejecución secuencial automática
- UI clara y usable durante entrenamiento
- Separación estricta lógica / UI

## 4. ARQUITECTURA (NO ROMPER)
- UI no maneja tiempo
- Runner no maneja widgets
- TimerUiState es la única fuente de verdad
- Efectos reaccionan al estado
- No duplicar lógica

## 5. ESTRUCTURA REAL DEL PROYECTO
lib/
 core/
  amrap_block.dart
  amrap_runner.dart
  timer_ui_state.dart
 screens/
  amrap_config_screen.dart
  timer_screen.dart
 widgets/
  central_timer.dart
 main.dart

## 6. MODELO DE ESTADO (CRÍTICO)
enum TimerPhase { rest, work, finished }

class TimerUiState {
  final int remainingSeconds;
  final int currentRound;
  final int totalRounds;
  final TimerPhase phase;
}

NO existen idle / paused / running.

## 7. AMRAP RUNNER
- Recibe List<AmrapBlock>
- Emite estado vía callback
- Controla trabajo y descanso
- NO depende de UI
- NO implementa pause / resume

## 8. TIMER SCREEN (UI)
- Recibe bloques desde configuración
- Muestra:
  - AppBar con flecha + AMRAP
  - Texto Trabajo / Descanso
  - X de N
  - Descanso con segundos
  - Temporizador circular centrado
- El temporizador siempre debe bajar

## 9. OBJETIVO ACTUAL (SOLO UI)
Pendiente:
1. Ajustes de spacing
2. Jerarquía visual
3. Tipografía
4. Colores por fase
5. Animaciones suaves
6. Sonido y vibración (futuro)

## 10. RESTRICCIONES ABSOLUTAS
- No inventar APIs
- No modificar lógica
- No romper compilación
- Entregar archivos completos

## 11. INSTRUCCIÓN FINAL PARA IA
El proyecto YA funciona.
Continuar desde este estado, enfocándose SOLO en UI/UX.
