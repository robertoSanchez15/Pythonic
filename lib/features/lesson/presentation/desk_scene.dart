//lib\features\lesson\presentation\desk_scene.dart
import 'package:flutter/material.dart';

import '../domain/exercise_config.dart';
import 'desktop_computer/desktop_computer.dart';
import 'office_desk.dart';

class DeskScene extends StatelessWidget {
  final ExerciseConfig config;
  final double screenWidth;
  final double deskHeight;
  final double desktopWidth;
  final double deskTopY;
  final double deskPositionOffset;
  final double desktopPositionOffset;
  final bool pipDocked;

  const DeskScene({
    super.key,
    required this.config,
    required this.screenWidth,
    required this.deskHeight,
    required this.desktopWidth,
    required this.deskTopY,
    this.deskPositionOffset = 0,
    this.desktopPositionOffset = 0,
    required this.pipDocked,
  });

  @override
  Widget build(BuildContext context) {
    final deskBottom = deskTopY - deskHeight + deskPositionOffset;
    final desktopBottom = deskTopY + desktopPositionOffset;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: 0,
          right: 0,
          bottom: deskBottom,
          child: OfficeDesk(height: deskHeight),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: (screenWidth - desktopWidth) / 2,
          bottom: desktopBottom,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: pipDocked ? 1.0 : 0.35,
            child: IgnorePointer(
              ignoring: !pipDocked,
              child: DesktopComputer(config: config, width: desktopWidth),
            ),
          ),
        ),
      ],
    );
  }
}