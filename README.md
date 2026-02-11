# SmartWOD 🏋️‍♂️

SmartWOD es una aplicación de temporizador para entrenamientos funcionales
desarrollada en Flutter. El proyecto está enfocado en **uso personal**,
aprendizaje progresivo y buenas prácticas de arquitectura.

Actualmente se está desarrollando primero el modo **AMRAP**, el cual ya cuenta
con un flujo completo desde configuración hasta ejecución.

---

## 🚦 Estado actual del proyecto

✔ Proyecto Flutter configurado correctamente  
✔ Emulador Android funcionando  
✔ Estructura de carpetas organizada  
✔ Navegación entre pantallas  
✔ Modo **AMRAP funcional de extremo a extremo**  

El flujo actual es:

```
Home
 └── AMRAP
      └── Configuración de bloques
            └── Ejecución del entrenamiento
```

---

## 🧠 Conceptos clave implementados

- Separación clara entre:
  - UI (screens / widgets)
  - Lógica (core)
- Motor de tiempo independiente de Flutter
- Ejecución por bloques (trabajo / descanso)
- Flujo automático sin intervención del usuario
- Código comentado y legible

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

## 🚀 Próximos pasos planeados

- Pulir UX del temporizador (colores, animaciones)
- Agregar sonido y vibración entre bloques
- Implementar FOR TIME reutilizando el motor
- Implementar EMOM y TABATA
- Guardar configuraciones favoritas
- Definir lógica de modo Premium (uso personal)

---

## 🧠 Filosofía del proyecto

SmartWOD prioriza:
- Código claro
- Arquitectura limpia
- Aprendizaje consciente
- Escalabilidad

Cada modo de entrenamiento debe ser
**fácil de entender, reutilizar y mantener**.
 ##################################################### UPDATE

 # SMARTWOD 🏋️‍♂️⏱️

SMARTWOD es una aplicación de temporizadores para entrenamiento
funcional (estilo CrossFit), desarrollada en Flutter con prioridad en
Android.

Actualmente el proyecto se encuentra en una versión estable funcional,
con arquitectura limpia y enfoque en mejorar la experiencia visual.

------------------------------------------------------------------------

## Estado actual (estable)

✔ Configuración múltiple de bloques AMRAP\
✔ Primer bloque solo trabajo\
✔ Bloques posteriores: descanso + trabajo\
✔ Countdown inicial de 10 segundos\
✔ Runner secuencial estable\
✔ Timer descendente correcto\
✔ Cambio de color por fase\
✔ Indicador "AMRAP X de N"\
✔ Tiempo total calculado correctamente

------------------------------------------------------------------------

## Arquitectura

-   AmrapRunner desacoplado de UI\
-   TimerUiState como única fuente de verdad\
-   UI reactiva sin lógica de negocio\
-   Sin estados idle / paused / running

------------------------------------------------------------------------

## Estructura

lib/ ├── core/ ├── screens/ ├── widgets/ ├── app/ └── main.dart

------------------------------------------------------------------------

## En desarrollo

-   Animación progresiva del círculo
-   Optimización visual
-   Espaciado responsivo
-   Mejora tipográfica

------------------------------------------------------------------------

Base estable confirmada.
