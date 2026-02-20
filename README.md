# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la creación
y ejecución precisa de entrenamientos funcionales tipo WOD.

Actualmente se encuentra estable en modalidad AMRAP y preparada para
escalar hacia múltiples formatos como EMOM, Tabata y For Time.

---

## 🚀 Visión del Proyecto

SMARTWOD busca convertirse en una herramienta profesional para atletas
y entrenadores que necesitan:

- Precisión temporal real
- Ejecución estable sin drift
- Flujo correcto de trabajo y descanso
- Registro automático de entrenamientos
- Arquitectura preparada para escalar

El enfoque principal es robustez estructural antes de expansión funcional.

---

## 🏗 Estado Actual

**Fase:** Beta Técnica Interna Estable  
**Modalidad activa:** AMRAP completamente funcional  
**Motor temporal:** Estable y sin drift perceptible  
**Audio:** Sincronizado y desacoplado  

---

## 🏋️ AMRAP – Implementación Actual

### Flujo correcto de bloques

El sistema implementa el siguiente orden estructural:

W1 → (sin descanso)  
D1 → descanso del bloque 2  
W2 → trabajo del bloque 2  
D2 → descanso del bloque 3  
W3 → trabajo del bloque 3  
FIN

El descanso pertenece siempre al siguiente bloque.

---

### Funcionalidades activas

- Configuración dinámica de bloques
- Descanso opcional por bloque
- Cálculo automático de tiempo total
- Countdown inicial sincronizado (3-2-1)
- Countdown automático en final de cada fase de trabajo
- Pausa funcional (solo en fase Work)
- Rest no permite pausa
- Barra de progreso global precisa
- Persistencia automática al finalizar
- Registro en historial

---

## ⏱ Motor de ejecución

- Runner desacoplado de la UI
- Máquina de estados clara (work / rest / paused / finished)
- Cálculo temporal basado en DateTime (compatible con background)
- Sin reinicio incorrecto al pausar
- Sin adelantamiento de barra
- Sin desfases acumulativos

---

## 🔊 Sistema de Audio

Implementado mediante `SoundEngine`:

- Countdown 3-2-1 sincronizado
- Sonido de finalización ("Well Done") funcional
- Sin duplicaciones
- Sin cortes prematuros
- Pre-carga de assets
- ReleaseMode.stop

Audio desacoplado e inyectado en el Runner.

---

## 💾 Persistencia

- Guardado automático al finalizar entrenamiento
- Registro en historial
- Implementación actual basada en repositorio local

---

## 🧠 Arquitectura Actual

Separación estructural clara:

lib/
├── core/
├── data/
├── domain/
├── presentation/
└── widgets/

Separación por capas en progreso real:

- Domain → Runner, Entidades
- Data → Repositorios
- Presentation → Screens y UI
- Core → Estado y motor temporal

---

## 📈 Próximos Pasos

1. Abstracción completa de WorkoutRunner base
2. Implementación de EMOM
3. Implementación de Tabata
4. Implementación de For Time
5. Migración futura de persistencia (Hive / Isar)
6. Métricas avanzadas

---

SMARTWOD se está construyendo con enfoque en precisión, estabilidad
y crecimiento sostenible.
