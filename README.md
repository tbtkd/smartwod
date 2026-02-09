
# SMARTWOD 🏋️‍♂️⏱️

SMARTWOD es una aplicación de temporizadores para entrenamiento funcional (CrossFit-style),
diseñada inicialmente para **uso personal**, con foco en **AMRAP**, y preparada para crecer
a otros formatos como EMOM, TABATA y MIX.

El proyecto está desarrollado en **Flutter**, con prioridad en Android, manteniendo una
arquitectura clara, escalable y fácil de mantener.

---

## 🎯 Objetivo del proyecto

- Crear un temporizador de entrenamiento **simple, visual y robusto**
- Permitir configurar entrenamientos tipo **AMRAP con múltiples bloques**
- Integrar descansos, sonidos, vibración y UX clara durante el entrenamiento
- Servir como proyecto de aprendizaje progresivo en Flutter

---

## 📁 Estructura del proyecto (actual)

```text
lib/
├── core/
│   ├── amrap_block.dart
│   ├── amrap_runner.dart
│   └── timer_ui_state.dart
│
├── screens/
│   ├── amrap_config_screen.dart
│   ├── home_screen.dart
│   └── timer_screen.dart
│   └── widgets/
│
├── widgets/
│   ├── central_timer.dart
│   ├── circular_timer.dart
│   ├── duration_picker_dialog.dart
│   └── wod_button.dart
│
├── app/
│   └── smartwod_app.dart
│
└── main.dart
```

---

## ✅ Funcionalidad IMPLEMENTADA

### Configuración AMRAP
- Múltiples bloques AMRAP
- Primer AMRAP solo trabajo
- AMRAPs siguientes:
  - Descanso
  - Trabajo
- Selector de tiempo en bloques de 15s con rollover a minutos

### Runner
- Ejecución secuencial de bloques
- Manejo correcto de trabajo / descanso
- Runner desacoplado de UI

### UI
- Círculo central
- Estado inicial visible
- Cambio de color por fase
- Indicador “X de N”

---

## ⏸️ Pendiente

- Número central azul durante descanso
- Mostrar descansos futuros debajo del contador
- Countdown previo de 10 segundos
- Sonido y vibración
- Pulido de UX

---

## 🚀 Estado

Base sólida, funcional y lista para continuar iterando.

💪 Continuará...


flutter run -d emulator-5554