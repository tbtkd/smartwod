import 'package:flutter/material.dart';

import '../../widgets/wod_button.dart';
import '../screens/emom_config_screen.dart';

import 'tabata_config_screen.dart';
import 'amrap_config_screen.dart';
import 'workout_history_screen.dart';
import 'for_time_config_screen.dart';

import '../../core/workout_type_extension.dart';
import '../../domain/enums/workout_type.dart';

/// ===============================================================
/// HOME SCREEN
///
/// Pantalla principal de la aplicación.
///
/// RESPONSABILIDADES
/// - Mostrar los modos de entrenamiento disponibles
/// - Permitir navegar a las pantallas de configuración
/// - Acceder al historial de entrenamientos
///
/// CARACTERÍSTICAS
/// - Botones visuales por tipo de workout
/// - Iconos representativos por modo
/// - Acceso rápido al historial
///
/// NOTA DE ARQUITECTURA
/// Esta pantalla **no contiene lógica de entrenamiento**.
/// Solo maneja navegación hacia configuraciones.
///
/// LOS ENTRENAMIENTOS SE EJECUTAN EN:
/// TimerScreen
///
/// ===============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const Spacer(),

              // ==================================================
              // ICONO PRINCIPAL
              //
              // Representa la identidad de la app.
              // Puede convertirse en animación en futuras versiones.
              // ==================================================

              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white10,
                  border: Border.all(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TITULO PRINCIPAL
              // ==================================================

              const Text(
                'EMMORA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 40),

              // ==========================
              // MODOS DE ENTRENAMIENTO
              // ==========================
              //
              // Cada botón representa un tipo
              // de entrenamiento disponible.
              //
              // Los iconos ayudan a reconocimiento
              // visual rápido por parte del usuario.
              //

              /// --------------------------------------------------
              /// AMRAP
              /// As Many Rounds As Possible
              /// --------------------------------------------------

              WodButton(
                label: WorkoutType.amrap.displayName,
                color: WorkoutType.amrap.color,
                icon: Icons.loop,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AmrapConfigScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// --------------------------------------------------
              /// FOR TIME
              /// Completar workout lo más rápido posible
              /// --------------------------------------------------

              WodButton(
                label: WorkoutType.forTime.displayName,
                color: WorkoutType.forTime.color,
                icon: Icons.flag,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ForTimeConfigScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// --------------------------------------------------
              /// EMOM
              /// Every Minute On the Minute
              /// --------------------------------------------------

              WodButton(
                label: WorkoutType.emom.displayName,
                color: WorkoutType.emom.color,
                icon: Icons.timer,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmomConfigScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// --------------------------------------------------
              /// TABATA
              /// Intervalos de alta intensidad
              /// --------------------------------------------------

              WodButton(
                label: WorkoutType.tabata.displayName,
                color: WorkoutType.tabata.color,
                icon: Icons.flash_on,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TabataConfigScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /*    //no disponible en esta version
              WodButton(
                label: WorkoutType.mix.displayName,
                color: WorkoutType.mix.color,
                icon: Icons.layers,
                onPressed: () {
                  _showComingSoon(context);
                },
              ),

              const SizedBox(height: 35),
              */

              const SizedBox(height: 35),

              // ==========================
              // ETIQUETA HISTORIAL
              // ==========================
              //
              // Acceso rápido al historial
              // de entrenamientos realizados.
              //

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const WorkoutHistoryScreen(),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 24),

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(30),

                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),

                  child: const Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      /// Icono historial
                      Icon(
                        Icons.history,
                        color: Colors.white70,
                        size: 18,
                      ),

                      SizedBox(width: 8),

                      /// Texto historial
                      Text(
                        'Ver historial de entrenamientos',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ==========================
              // BOTÓN DEBUG (COMENTADO)
              // ==========================
              //
              // Utilizado durante desarrollo
              // para limpiar historial local.
              //
              // NO DEBE ACTIVARSE EN PRODUCCIÓN.
              //

              /*
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await repository.clear();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Historial eliminado'),
                    ),
                  );
                },
                child: const Text('Limpiar historial (Debug)'),
              ),
               *///cierre comentario debug boton */
            
            /// ==================================================
            /// FOOTER VERSION
            ///
            /// Permite identificar la versión de la app
            /// durante pruebas con usuarios.
            /// ==================================================
            const Text(
              'v0.9 Beta',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }

/*
  static void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text(
          'Este modo se implementará después de AMRAP.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
*/
}