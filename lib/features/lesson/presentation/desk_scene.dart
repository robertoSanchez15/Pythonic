import 'package:flutter/material.dart';

import '../../code_editor/keyboard_snippets/presentation/smart_keyboard_bar.dart';
import '../domain/desktop_app_type.dart';
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
  final TextEditingController jupyterInputController;
  final FocusNode jupyterInputFocusNode;
  final bool isEn;
  final DesktopAppType activeApp;
  final ValueChanged<DesktopAppType>? onActiveAppChanged;

  // Altura fija de SmartKeyboardBar (Container height: 44 en ese
  // widget) y separación respecto al dock — constantes conocidas, no
  // requieren medir el árbol en tiempo real.
  static const _barHeight = 44.0;
  static const _barGap = 10.0;

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
    required this.jupyterInputController,
    required this.jupyterInputFocusNode,
    required this.isEn,
    required this.activeApp,
    this.onActiveAppChanged,
  });

  @override
  Widget build(BuildContext context) {
    final deskBottom = deskTopY - deskHeight + deskPositionOffset;
    // desktopBottom es la altura del borde INFERIOR del dock (última
    // pieza de la Column de DesktopComputer) respecto al borde
    // inferior de pantalla.
    final desktopBottom = deskTopY + desktopPositionOffset;
    // La barra se ancla debajo del dock, restando su propia altura —
    // cálculo puramente aritmético, sin tocar la Column de la PC.
    final barBottom = desktopBottom - _barGap - _barHeight;

    final showSmartBar = activeApp == DesktopAppType.jupyter;

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
              child: DesktopComputer(
                config: config,
                width: desktopWidth,
                jupyterInputController: jupyterInputController,
                jupyterInputFocusNode: jupyterInputFocusNode,
                onActiveAppChanged: onActiveAppChanged,
              ),
            ),
          ),
        ),
        if (showSmartBar)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: (screenWidth - desktopWidth) / 2,
            bottom: barBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: pipDocked ? 1.0 : 0.35,
              child: IgnorePointer(
                ignoring: !pipDocked,
                child: SizedBox(
                  width: desktopWidth,
                  child: SmartKeyboardBar(
                    controller: jupyterInputController,
                    focusNode: jupyterInputFocusNode,
                    isEn: isEn,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}