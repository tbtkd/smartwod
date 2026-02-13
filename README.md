# SmartWOD 🏋️‍♂️

SmartWOD es una aplicación móvil desarrollada en Flutter enfocada en temporizadores para entrenamientos funcionales estilo CrossFit.

Actualmente el proyecto se encuentra en una base funcional estable, con arquitectura desacoplada y enfoque fuerte en claridad estructural.

---

## 🚦 Estado actual del proyecto

✔ Configuración dinámica de bloques AMRAP
✔ Primer bloque solo trabajo
✔ Bloques posteriores: descanso + trabajo
✔ Countdown inicial de 10 segundos
✔ Temporizador circular decreciente (CustomPainter)
✔ Transiciones suaves entre fases
✔ Cambio de color por fase (trabajo / descanso)
✔ Indicador "Amrap X de N"
✔ Barra de progreso global del entrenamiento
✔ Pantalla final profesional
✔ Cálculo correcto de tiempos totales (incluye último descanso)
✔ Separación estricta lógica / UI

El flujo actual es:


Home
 └── AMRAP
      └── Configuración
            └── Countdown
                  └── Ejecución
                        └── Pantalla final


## 🧠 Arquitectura

Separación estricta de responsabilidades:

  - core/ → lógica pura (sin dependencias de Flutter)
  - screens/ → pantallas
  - widgets/ → componentes reutilizables
  - TimerUiState → única fuente de verdad

La UI nunca controla el tiempo.
El runner nunca conoce widgets.

---

## 📌 Regla principal del proyecto

> **Todo el desarrollo se realiza únicamente dentro de la carpeta `lib/`.**

No modificar carpetas de plataforma (`android/`, `ios/`, etc.)
a menos que sea estrictamente necesario.

---

## 📁 Estructura del proyecto

```
lib/
│
├── main.dart
│   # Punto de entrada de la app
│
├── app/
│   └── smartwod_app.dart
│   # Configuración general (MaterialApp, tema)
│
├── screens/
│   ├── home_screen.dart
│   │   # Pantalla principal con modos de entrenamiento
│   │
│   ├── amrap_config_screen.dart
│   │   # Configuración dinámica del AMRAP por bloques
│   │
│   └── timer_screen.dart
│       # Ejecución real del entrenamiento
│
├── widgets/
│   └── wod_button.dart
│   # Botón reutilizable de los modos
│
├── core/
│   ├── amrap_block.dart
│   │   # Modelo de bloque (trabajo / descanso)
│   │
│   ├── timer_engine.dart
│   │   # Motor genérico de conteo de tiempo
│   │
│   └── amrap_runner.dart
│       # Controlador que ejecuta bloques en secuencia
│
└── utils/
    └── constants.dart
    # Reservado para constantes futuras
```

---

## ▶️ Flujo de desarrollo recomendado

1. Iniciar emulador Android
2. Ejecutar:
   ```bash
   flutter run
   ```
3. Modificar únicamente archivos dentro de `lib/`
4. Guardar → Hot Reload automático

---

## 🚫 Cosas que NO hacer

- ❌ No modificar `MainActivity.kt`
- ❌ No editar archivos Gradle sin motivo
- ❌ No mezclar Dart con código nativo
- ❌ No ejecutar lógica de tiempo desde la UI

---

## 🧩 Funcionamiento AMRAP

Regla estructural:

  Bloque 1 → solo trabajo
  Bloque 2..N → descanso + trabajo

El último bloque SÍ incluye su descanso si fue programado.

---

## 🎯 Funcionalidades clave
🔹 Countdown inicial
  10 segundos antes de iniciar el entrenamiento.

🔹 Temporizador circular
    Disminuye visualmente conforme pasa el tiempo.
    CustomPainter.
    Colores por fase.

🔹 Progreso global
    Barra horizontal animada que representa el avance total del entrenamiento.

🔹 Transiciones
    Fade en texto superior.
    Cambio suave de color.
    Animaciones controladas con AnimatedSwitcher / AnimatedContainer.

🔹 Pantalla final
    Muestra:
    Duración total
    Amrap completados
    Botón volver

---

## 🚫 Restricciones del proyecto

🔹 No modificar lógica sin autorización.
🔹 No mezclar UI con lógica.
🔹 No duplicar cálculos.
🔹 No inventar estados.
🔹 Entregar archivos completos cuando se modifique algo.

---

## 🛣 Próximos pasos

🔹 Pendientes para futura versión:
🔹 Sonido en transición de fases
🔹 Vibración opcional
🔹 Historial de entrenamientos
🔹 Guardado local
🔹 Nuevos modos (EMOM, FOR TIME, TABATA)
🔹 Modo oscuro mejorado
🔹 Mejora tipográfica profesional

---

## 📌 Filosofía

SmartWOD prioriza:

🔹 Arquitectura limpia
🔹 Código claro
🔹 Escalabilidad
🔹 UX enfocada en entrenamiento real