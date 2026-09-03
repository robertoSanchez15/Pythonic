import 'package:flutter/material.dart';
import '../../../../core/widgets/stat_chip.dart';

class StreakChip extends StatelessWidget {
  final int streakDays;
  const StreakChip({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return StatChip(
      icon: Icons.local_fire_department_rounded,
      label: '$streakDays',
      color: Colors.orange,
    );
  }
}