# SMARTWOD --- CONTEXTO TÉCNICO Y PLAN ESTRUCTURAL

## 1. IDENTIDAD DEL PROYECTO

Nombre: SMARTWOD  
Tipo: Aplicación móvil Flutter  
Estado actual: Beta Técnica Interna Avanzada  
Enfoque actual: Estabilización estructural y desacoplamiento de dominio  

------------------------------------------------------------------------

## 2. PRIORIDADES TÉCNICAS ACTUALES

Orden de implementación definido:

1. Sincronización precisa de sonido
2. Abstracción de WorkoutRunner
3. Implementación de Clean Architecture real
4. Migración de almacenamiento
5. Expansión funcional (EMOM, Tabata, For Time)

Las métricas avanzadas se posponen para versión futura.

------------------------------------------------------------------------

## 3. OBJETIVO INMEDIATO — SINCRONIZACIÓN DE SONIDO

Problema actual:

- Posible desfase perceptible en ciertos dispositivos.
- Audio acoplado directamente al runner.
- Dependencia directa del FeedbackService.

Objetivos técnicos:

- Garantizar precisión inferior a 100ms.
- Evitar bloqueo del hilo principal.
- Implementar interfaz SoundEngine.
- Inyectar dependencia en el runner.
- Preparar arquitectura para múltiples perfiles de sonido.

------------------------------------------------------------------------

## 4. ABSTRACCIÓN DEL RUNNER

Se implementará una interfaz base:

abstract class WorkoutRunner {
  Stream<TimerUiState> get stream;
  void start();
  void pause();
  void dispose();
}

Objetivo:

- Desacoplar TimerScreen del tipo específico de entrenamiento.
- Permitir implementación futura de:
  - EmomRunner
  - ForTimeRunner
  - TabataRunner

------------------------------------------------------------------------

## 5. MIGRACIÓN A CLEAN ARCHITECTURE

Separación definitiva en:

Domain:
- Entidades
- Interfaces de runner
- Interfaces de repositorio

Data:
- Implementaciones de repositorios
- Persistencia

Presentation:
- Screens
- Widgets
- ViewModels (futuro)

Se eliminarán servicios estáticos.

------------------------------------------------------------------------

## 6. ESCALABILIDAD FUTURA

Fases posteriores:

- EMOM
- Tabata
- For Time
- MIX
- Plantillas
- Métricas avanzadas
- Exportación / Compartir
- Publicación en tienda

------------------------------------------------------------------------

## 7. DECISIÓN ESTRATÉGICA

SMARTWOD evoluciona hacia:

- Dominio desacoplado
- Audio desacoplado
- Persistencia escalable
- Runner extensible
- Arquitectura sostenible

El foco actual es robustez estructural antes de expansión funcional.
