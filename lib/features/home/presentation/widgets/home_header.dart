import 'package:flutter/material.dart';
import '../../../gamification/streaks/presentation/streak_chip.dart';
import '../../../gamification/xp_levels/presentation/xp_chip.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;
  final int streakDays;
  final int xp;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.streakDays,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              userName != null ? '¡Hola, $userName!' : 'Pythonic',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          StreakChip(streakDays: streakDays),
          const SizedBox(width: 8),
          XpChip(xp: xp),
        ],
      ),
    );
  }
}