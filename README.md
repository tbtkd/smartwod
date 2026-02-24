# SMARTWOD

SMARTWOD es una aplicación móvil desarrollada en Flutter para la creación
y ejecución precisa de entrenamientos funcionales tipo WOD.

Versión actual: 0.2.0-beta  
Estado: Beta Técnica Estable (AMRAP consolidado)

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

**Fase:** Beta Técnica Estable  
**Modalidad activa:** AMRAP completamente funcional  
**Motor temporal:** Estable y sin drift perceptible  
**Audio:** Sincronizado y desacoplado  
**Arquitectura:** Lista para expansión a nuevos modos

---

## 🏋️ AMRAP – Implementación Actual

### Flujo estructural correcto

W1 → sin descanso  
D1 → descanso bloque 2  
W2 → trabajo bloque 2  
D2 → descanso bloque 3  
W3 → trabajo bloque 3  
FIN  

El descanso pertenece siempre al siguiente bloque.

---

### Funcionalidades activas

- Configuración dinámica de bloques
- Descanso opcional por bloque
- Cálculo automático de tiempo total
- Countdown inicial sincronizado (3-2-1)
- Countdown automático en final de fase
- Pausa funcional (solo en fase Work)
- Rest no permite pausa
- Barra de progreso global precisa
- Persistencia automática al finalizar
- Registro en historial

---

## ⏱ Motor de ejecución

- Runner desacoplado de UI
- Máquina de estados clara (work / rest / paused / finished)
- Cálculo temporal basado en DateTime (compatible con background)
- Sin reinicio incorrecto al pausar
- Sin adelantamiento de barra
- Sin desfases acumulativos
- Countdown disparado únicamente cuando remaining == 3
- El archivo countdown_1.wav contiene 3-2-1 completo
- No se corta audio manualmente
- No hay duplicaciones ni loops

---

## 🔊 Sistema de Audio

Implementado mediante `SoundEngine`:

- Countdown único disparado en segundo 3
- Sonido de finalización ("Well Done") funcional
- Sin duplicaciones
- Sin cortes prematuros
- Pre-carga de assets
- ReleaseMode.stop
- Audio desacoplado e inyectado en Runner

---

## 💾 Persistencia

- Guardado automático al finalizar entrenamiento
- Registro en historial
- Implementación actual basada en repositorio local

---

## 🧠 Arquitectura Actual

lib/
├── core/  
├── data/  
├── domain/  
├── presentation/  
└── widgets/  

Separación por capas en progreso consolidado:

- Domain → Runner, Entidades
- Data → Repositorios
- Presentation → Screens
- Core → Estado y motor temporal

---

# 📈 ROADMAP OFICIAL

## Fase 1 – Consolidación del Core (ACTUAL)

✔ Motor temporal estable  
✔ Audio sincronizado  
✔ Arquitectura runner desacoplada  
✔ Countdown consistente  
✔ Beta funcional AMRAP  

---

## Fase 2 – Arquitectura Escalable

1. Crear BaseRunner abstracto
2. Extraer PhaseEngine reutilizable
3. Separar máquina de estados del runner
4. Implementar pruebas unitarias del motor

---

## Fase 3 – Nuevos Modos

- EMOM
- Tabata
- For Time
- Mixed (secuencias combinadas)

Todos reutilizando el mismo CoreTimerEngine.

---

## Fase 4 – Profesionalización

- Persistencia robusta (Hive / Isar)
- Exportación de historial
- Estadísticas
- Métricas por bloque
- Refinamiento UI

---

## Fase 5 – Versión 1.0.0

- Optimización final
- Publicación Play Store
- Versión estable pública

---

SMARTWOD se está construyendo con enfoque en precisión, estabilidad
y crecimiento sostenible.