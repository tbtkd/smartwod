
# ARCHITECTURE_DECISIONS.md
SMARTWOD — Decisiones de Arquitectura

Este documento explica las decisiones técnicas tomadas durante el desarrollo del proyecto
SMARTWOD. Su objetivo es permitir que futuros desarrolladores entiendan rápidamente
por qué se eligió cada enfoque arquitectónico.

---

# 1. Uso de Flutter

Se eligió Flutter porque permite:

- desarrollo multiplataforma (Android / iOS)
- rendimiento cercano a nativo
- control total del render del timer
- un único código base

Para una app centrada en animaciones y temporización precisa,
Flutter ofrece mayor control que frameworks híbridos.

---

# 2. Arquitectura basada en Segmentos

En lugar de crear lógica separada para cada modo de entrenamiento,
se diseñó un motor unificado basado en segmentos.

Concepto:

WorkoutDefinition
→ genera
WorkoutStructure
→ compuesto por
Segmentos (Work / Rest)
→ ejecutados por
SegmentRunner

Ventajas:

- elimina duplicación de lógica
- permite agregar nuevos modos fácilmente
- simplifica el control del timer
- facilita mantenimiento

---

# 3. Separación por Capas

El proyecto separa responsabilidades en cuatro capas principales.

Domain

contiene lógica pura de negocio:

- definitions
- runners
- entities
- enums

Core

contiene componentes compartidos:

- timer state
- audio
- extensiones

Data

maneja persistencia:

- repositorios
- almacenamiento local

Presentation

contiene UI:

- pantallas
- widgets

Esta separación permite cambiar UI o almacenamiento sin afectar
la lógica de ejecución.

---

# 4. Uso de Stream para el Timer

El estado del timer se transmite mediante:

Stream<TimerUiState>

Razones:

- desacopla UI del motor
- permite múltiples listeners
- evita dependencias directas con widgets

La UI simplemente escucha el stream y renderiza el estado.

---

# 5. Persistencia basada en Metadata

Cada workout guarda metadata flexible.

Ejemplo:

Tabata:

rounds
workSeconds
restSeconds

For Time:

timeCapSeconds

Esto permite reconstruir la configuración del entrenamiento
sin crear estructuras de datos rígidas.

---

# 6. Offline First

SMARTWOD fue diseñado para funcionar completamente sin internet.

Razones:

- entrenamientos en gimnasio sin conexión
- mayor velocidad
- menos dependencias externas

El historial se guarda localmente.

---

# 7. Extensibilidad del Motor

La arquitectura permite agregar nuevos tipos de entrenamiento
sin modificar el motor.

Ejemplo futuro:

Modo MIX

AMRAP → REST → EMOM → REST → FOR TIME

Solo se necesita generar la estructura de segmentos.

---

# 8. Principios del Proyecto

SMARTWOD sigue tres principios técnicos:

1. precisión temporal
2. arquitectura simple
3. mínima duplicación de código

Estas decisiones permiten mantener el proyecto escalable.
