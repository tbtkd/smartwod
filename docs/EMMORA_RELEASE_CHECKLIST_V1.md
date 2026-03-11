# EMMORA — Release Checklist v1.0

Este documento define los pasos necesarios antes de publicar
la versión 1.0 de la aplicación Emmora.

El objetivo es asegurar:

- estabilidad
- experiencia de usuario consistente
- ausencia de errores críticos
- preparación para publicación en tiendas

---

# 1. VERIFICACIÓN FUNCIONAL

## Temporizador

Verificar funcionamiento en todos los modos:

AMRAP  
EMOM  
TABATA  
FOR TIME  

Confirmar:

- el timer inicia correctamente
- el countdown funciona
- los sonidos se reproducen
- la vibración háptica funciona
- el progreso del círculo es correcto

---

## Pausa

Verificar:

- el timer puede pausarse
- el icono de pausa se muestra correctamente
- el timer continúa correctamente al reanudar

---

## Descanso

Confirmar:

- el color rojo aparece en descanso
- los últimos 3 segundos cambian a rojo
- el cambio de fase es claro

---

## Finalización del entrenamiento

Verificar:

- el workout termina correctamente
- la pantalla final aparece
- el historial se guarda

Para FOR TIME verificar:

- finalización manual funciona
- el tiempo real se registra correctamente

---

# 2. HISTORIAL

Verificar:

- los entrenamientos aparecen en historial
- el orden es correcto
- el tiempo total es correcto
- el subtítulo del workout se muestra correctamente

---

# 3. DETALLE DEL ENTRENAMIENTO

Confirmar:

- metadata se muestra correctamente
- fecha correcta
- desglose correcto

Para cada modo:

TABATA  
EMOM  
AMRAP  
FOR TIME  

---

# 4. NOTAS

Verificar:

- las notas se pueden escribir
- la caja de texto crece automáticamente
- el texto se guarda correctamente
- al volver al historial la nota sigue presente

---

# 5. UI / UX

Confirmar:

- el temporizador se ve claramente a distancia
- el tamaño de números es adecuado
- los iconos del Home funcionan
- el flujo de navegación es claro

---

# 6. PRUEBAS DE ESTABILIDAD

Realizar pruebas reales:

- workout de 20 minutos
- workout de intervalos largos
- pausas múltiples
- cambiar de app y regresar

Confirmar que:

- el timer sigue funcionando
- wakelock funciona
- la app no se congela

---

# 7. RENDIMIENTO

Verificar:

- no hay caídas de FPS
- la UI responde rápido
- no hay bloqueos de interfaz

---

# 8. VERSIONADO

Confirmar que:

Nombre de app:
Emmora

Versión:
1.0.0

Version code incrementado.

---

# 9. ICONO DE APP

Confirmar:

- icono correcto
- resolución adecuada
- se ve bien en launcher

---

# 10. BUILD DE TEST

Generar:

APK de testing

Probar en:

- varios dispositivos
- diferentes tamaños de pantalla

---

# 11. PREPARACIÓN PARA STORE

Preparar:

- nombre final de la app
- descripción
- capturas de pantalla
- icono 512x512

---

# 12. TEST CON USUARIOS

Antes de publicar:

entregar APK a testers

Solicitar feedback sobre:

- claridad del timer
- facilidad de uso
- visibilidad en gimnasio

---

# 13. ERRORES CRÍTICOS

Confirmar que NO existen:

- crashes
- timers incorrectos
- datos corruptos en historial

---

# 14. DECISIÓN DE RELEASE

Si todos los puntos anteriores están correctos:

Publicar **Emmora v1.0**