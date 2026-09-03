import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/exercise_node.dart';

class LevelInfoCard extends StatelessWidget {
  final ExerciseNode? exercise;
  final String? lessonTitle;
  final VoidCallback onPressed;
  final String buttonLabel;

  const LevelInfoCard({
    super.key,
    required this.exercise,
    required this.lessonTitle,
    required this.onPressed,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (exercise == null || lessonTitle == null) return const SizedBox.shrink();
    final isLocked = exercise!.status == ExerciseStatus.locked;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 20), // 👈 reducido verticalmente
      decoration: const BoxDecoration(
        color: AppColors.homeSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lessonTitle!.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14, // 👈 un poco más pequeño
              letterSpacing: 0.5,
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 10), // 👈 menos espacio
          SizedBox(
            width: double.infinity,
            height: 46, // 👈 botón más compacto
            child: ElevatedButton(
              onPressed: isLocked ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                disabledBackgroundColor: AppColors.homeLocked,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 15, // 👈 reducido
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Arimo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
