import 'package:flutter/material.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../../../core/theme/app_colors.dart'; // ajusta al nombre real de tu clase de colores

class XpChip extends StatelessWidget {
  final int xp;
  const XpChip({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return StatChip(
      icon: Icons.bolt_rounded,
      label: '$xp XP',
      color: AppColors.primaryGreen, // reemplaza por tu constante real en app_colors.dart
    );
  }
}