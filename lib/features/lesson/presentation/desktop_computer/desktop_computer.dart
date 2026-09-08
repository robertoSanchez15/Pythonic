//lib\features\lesson\presentation\desktop_computer\desktop_computer.dart
import 'package:flutter/material.dart';
import '../../data/mock_python_executor.dart';
import '../../domain/desktop_app_type.dart';
import '../../domain/exercise_config.dart';
import 'app_dock.dart';
import 'apps/jupyter_app.dart';
import 'desktop_monitor_frame.dart';

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
  late final List<DesktopAppType> _apps = widget.config.dockApps;
  late final List<Widget> _screens = _apps.map(_buildScreen).toList();

  Widget _buildScreen(DesktopAppType app) {
    switch (app) {
      case DesktopAppType.jupyter:
        return JupyterApp(onExecute: mockPythonExecutor);
      case DesktopAppType.excel:
      case DesktopAppType.pdf:
      case DesktopAppType.csv:
      case DesktopAppType.json:
        return _PlaceholderScreen(app: app);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopMonitorFrame(
          width: widget.width,
          // Todas las apps montadas SIEMPRE y siempre PINTADAS (con
          // opacidad 0 la inactiva) — a propósito. Antes usábamos
          // IndexedStack, que deja de pintar al hijo no activo; eso
          // hacía que el teclado nativo se cerrara solo al cambiar de
          // app mientras el TextField de Jupyter tenía foco, porque
          // Flutter cierra la conexión con el teclado cuando el campo
          // enfocado deja de componerse visualmente. Con Opacity, el
          // widget sigue pintándose (solo invisible), así que el foco
          // y el teclado se mantienen intactos al cambiar de app.
          screen: Stack(
            fit: StackFit.expand,
            children: [
              for (var i = 0; i < _apps.length; i++)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: _apps[i] != _activeApp,
                    child: Opacity(
                      opacity: _apps[i] == _activeApp ? 1.0 : 0.0,
                      child: _screens[i],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppDock(
          apps: _apps,
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
      child: Text(app.label,
          style: TextStyle(
              color: app.accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}