import 'package:flutter/material.dart';
import '../../domain/desktop_app_type.dart';

/// Fila de accesos directos arriba de la PC. Solo muestra lo que el
/// ExerciseConfig declaró (ExerciseConfig.dockApps ya incluye Jupyter).
class AppDock extends StatelessWidget {
  final List<DesktopAppType> apps;
  final DesktopAppType activeApp;
  final ValueChanged<DesktopAppType> onAppSelected;

  const AppDock({
    super.key,
    required this.apps,
    required this.activeApp,
    required this.onAppSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final app in apps) ...[
          _DockIcon(
            app: app,
            isActive: app == activeApp,
            onTap: () => onAppSelected(app),
          ),
          const SizedBox(width: 40),
        ],
      ],
    );
  }
}

class _DockIcon extends StatelessWidget {
  final DesktopAppType app;
  final bool isActive;
  final VoidCallback onTap;

  const _DockIcon({
    required this.app,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? app.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? app.accentColor : Colors.black12,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(
          app.icon,
          color: isActive ? Colors.white : app.accentColor,
          size: 24,
        ),
      ),
    );
  }
}