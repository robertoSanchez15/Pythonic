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
  final TextEditingController jupyterInputController;
  final FocusNode jupyterInputFocusNode;

  /// Avisa a DeskScene cuál es la app activa (incluida la inicial), para
  /// que decida si mostrar la barra de botones — sin que la barra viva
  /// dentro de este widget ni afecte su altura/posición.
  final ValueChanged<DesktopAppType>? onActiveAppChanged;

  const DesktopComputer({
    super.key,
    required this.config,
    required this.width,
    required this.jupyterInputController,
    required this.jupyterInputFocusNode,
    this.onActiveAppChanged,
  });

  @override
  State<DesktopComputer> createState() => _DesktopComputerState();
}

class _DesktopComputerState extends State<DesktopComputer> {
  late DesktopAppType _activeApp = DesktopAppType.alwaysAvailable;
  late final List<DesktopAppType> _apps = widget.config.dockApps;
  late final List<Widget> _screens = _apps.map(_buildScreen).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.onActiveAppChanged?.call(_activeApp));
  }

  Widget _buildScreen(DesktopAppType app) {
    switch (app) {
      case DesktopAppType.jupyter:
        return JupyterApp(
          onExecute: mockPythonExecutor,
          controller: widget.jupyterInputController,
          focusNode: widget.jupyterInputFocusNode,
        );
      case DesktopAppType.excel:
      case DesktopAppType.pdf:
      case DesktopAppType.csv:
      case DesktopAppType.json:
        return _PlaceholderScreen(app: app);
    }
  }

  void _selectApp(DesktopAppType app) {
    setState(() => _activeApp = app);
    widget.onActiveAppChanged?.call(app);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopMonitorFrame(
          width: widget.width,
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
          onAppSelected: _selectApp,
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