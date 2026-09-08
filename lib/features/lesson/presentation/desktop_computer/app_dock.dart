import 'package:flutter/material.dart';
import '../../domain/desktop_app_type.dart';

class AppDock extends StatelessWidget {
  final List<DesktopAppType> apps;
  final DesktopAppType activeApp;
  final ValueChanged<DesktopAppType> onAppSelected;
  final double iconSize;
  final double spacing;

  const AppDock({
    super.key,
    required this.apps,
    required this.activeApp,
    required this.onAppSelected,
    this.iconSize = 48,
    this.spacing = 24,
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
            size: iconSize,
          ),
          SizedBox(width: spacing),
        ],
      ],
    );
  }
}

class _DockIcon extends StatelessWidget {
  final DesktopAppType app;
  final bool isActive;
  final VoidCallback onTap;
  final double size;

  const _DockIcon({
    required this.app,
    required this.isActive,
    required this.onTap,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? app.accentColor : Colors.white,
          borderRadius: BorderRadius.circular(size * 0.29),
          border: Border.all(
            color: isActive ? app.accentColor : Colors.black12,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(app.icon,
            color: isActive ? Colors.white : app.accentColor, size: size * 0.5),
      ),
    );
  }
}