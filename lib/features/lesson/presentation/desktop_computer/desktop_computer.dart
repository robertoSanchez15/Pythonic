import 'package:flutter/material.dart';
import '../../domain/desktop_app_type.dart';
import '../../domain/exercise_config.dart';
import 'app_dock.dart';
import 'desktop_monitor_frame.dart';

/// Widget raíz de la PC dentro de ExercisePage. Cada "pantalla" es
/// placeholder por ahora — se reemplaza por JupyterApp, ExcelDocument,
/// etc. en el siguiente paso.
class DesktopComputer extends StatefulWidget {
  final ExerciseConfig config;
  final double width;

  const DesktopComputer({
    super.key,
    required this.config,
    required this.width,
  });

  @override
  State<DesktopComputer> createState() => _DesktopComputerState();
}

class _DesktopComputerState extends State<DesktopComputer> {
  late DesktopAppType _activeApp = DesktopAppType.alwaysAvailable;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopMonitorFrame(
          width: widget.width,
          screen: _PlaceholderScreen(app: _activeApp),
        ),
        const SizedBox(height: 16),
        AppDock(
          apps: widget.config.dockApps,
          activeApp: _activeApp,
          onAppSelected: (app) => setState(() => _activeApp = app),
        ),
      ],
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final DesktopAppType app;

  const _PlaceholderScreen({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF3F8),
      alignment: Alignment.center,
      child: Text(
        app.label,
        style: TextStyle(
          color: app.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}