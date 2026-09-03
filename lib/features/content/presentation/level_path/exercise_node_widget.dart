import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/exercise_node.dart';
import '../../domain/activity_icon.dart';

const _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

// Si tus SVG traen "aire" dentro de su propio canvas, reducir el padding
// de Flutter no cambia nada visualmente — hay que acercar el dibujo
// dentro de su caja. Sube este número si aún se ven muy separados;
// bájalo a 1.0 si empiezan a recortarse los bordes del ícono.
const _contentScale = 1.3;

class ExerciseNodeWidget extends StatelessWidget {
  final ExerciseNode exercise;
  final VoidCallback onTap;

  const ExerciseNodeWidget({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBoss = exercise.icon == ActivityIcon.boss;
    // 👇 Tamaños reducidos (antes: 120 / 95). Ajusta a gusto.
    final size = isBoss ? 96.0 : 74.0;
    final isLocked = exercise.status == ExerciseStatus.locked;
    final isCompleted = exercise.status == ExerciseStatus.completed;

    Widget icon = SvgPicture.asset(
      exercise.icon.assetPath,
      width: size,
      height: size,
    );

    if (isLocked) {
      icon = ColorFiltered(
        colorFilter: _greyscale,
        child: Opacity(opacity: 0.45, child: icon),
      );
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Transform.scale(scale: _contentScale, child: icon),
            ),
            if (isCompleted)
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
            if (isLocked)
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    color: AppColors.homeBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.homeLocked),
                  ),
                  child: Icon(Icons.lock_rounded, size: 9, color: AppColors.homeLockedIcon),
                ),
              ),
          ],
        ),
      ),
    );
  }
}