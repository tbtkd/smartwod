# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la
creación y ejecución de entrenamientos funcionales tipo WOD, comenzando
con modalidad AMRAP (As Many Rounds As Possible) y diseñada para escalar
a múltiples formatos como EMOM, Tabata y For Time.

------------------------------------------------------------------------

## 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta profesional para atletas y
entrenadores que desean:

-   Crear entrenamientos personalizados
-   Ejecutarlos con precisión temporal real
-   Registrar historial completo
-   Analizar estadísticas acumuladas
-   Escalar a múltiples modalidades de WOD

La aplicación está construida con enfoque en estabilidad, precisión y
escalabilidad futura.

------------------------------------------------------------------------

## 🏗 Estado Actual

**Fase:** Beta Técnica Interna Avanzada\
**Motor:** Estable y preciso\
**Arquitectura:** Modular y preparada para expansión

### Funcionalidades implementadas

#### 🏋️ AMRAP

-   Configuración dinámica de bloques
-   Descanso opcional por bloque
-   Selector avanzado de tiempo (minutos/segundos)
-   Validaciones mínimas de duración
-   Cálculo automático del tiempo total
-   AnimatedList con transiciones suaves

#### ⏱ Motor de ejecución

-   Runner desacoplado de la UI
-   Máquina de estados controlada
-   Precisión temporal basada en referencia real (anti-drift)
-   Countdown previo al inicio
-   Pausa inteligente
-   Barra de progreso global

#### 🔊 Audio

-   Sonido en cambio de fase
-   Sonido al finalizar entrenamiento
-   Sistema pre-cargado para reducir latencia
-   Pendiente refinamiento fino de sincronización

#### 💾 Persistencia

-   Guardado automático del entrenamiento activo
-   Restauración básica al reabrir la app
-   Limpieza automática al finalizar

#### 📊 Historial y estadísticas

-   Registro automático de entrenamientos completados
-   Historial ordenado por fecha
-   Estadísticas acumuladas:
    -   Total de entrenamientos
    -   Tiempo total acumulado
    -   Entrenamiento más largo

------------------------------------------------------------------------

## 🧠 Arquitectura

Estructura modular organizada por responsabilidades:

lib/ ├── core/ (lógica de negocio) ├── models/ (entidades) ├── screens/
(UI) ├── widgets/ (componentes reutilizables) └── utils/ (servicios y
persistencia)

Diseñada para evolucionar hacia separación clara de capas: - Domain -
Data - Presentation

------------------------------------------------------------------------

## 📈 Roadmap

-   Refactor arquitectónico por capas
-   Migración de almacenamiento a base de datos local (Hive / Isar)
-   Implementación de EMOM
-   Implementación de Tabata
-   Implementación de For Time
-   Plantillas guardadas
-   Configuración avanzada de sonido
-   Optimización completa de sincronización de audio
-   Preparación para publicación en tiendas

------------------------------------------------------------------------

## 🛠 Tecnologías

-   Flutter
-   Dart
-   SharedPreferences (temporal)
-   Arquitectura modular preparada para escalabilidad

------------------------------------------------------------------------

SMARTWOD es un proyecto en evolución con enfoque en calidad técnica,
estabilidad y crecimiento sostenible.
