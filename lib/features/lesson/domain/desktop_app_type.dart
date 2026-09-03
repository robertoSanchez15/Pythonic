import 'package:flutter/material.dart';

enum DesktopAppType {
  jupyter,
  excel,
  csv,
  json,
  pdf;

  /// Jupyter siempre está disponible, sin importar lo que declare el
  /// ejercicio — ver ExerciseConfig.dockApps.
  static const DesktopAppType alwaysAvailable = DesktopAppType.jupyter;
}

/// Iconos y colores nativos para el dock — sin SVGs por ahora, fácil de
/// reemplazar por assets propios más adelante si quieres.
extension DesktopAppTypeIcon on DesktopAppType {
  IconData get icon {
    switch (this) {
      case DesktopAppType.jupyter:
        return Icons.terminal_rounded;
      case DesktopAppType.excel:
        return Icons.grid_on_rounded;
      case DesktopAppType.csv:
        return Icons.table_rows_rounded;
      case DesktopAppType.json:
        return Icons.data_object_rounded;
      case DesktopAppType.pdf:
        return Icons.picture_as_pdf_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case DesktopAppType.jupyter:
        return const Color(0xFFF37626); // naranja Jupyter real
      case DesktopAppType.excel:
        return const Color(0xFF1D6F42); // verde Excel real
      case DesktopAppType.csv:
        return const Color(0xFF2E7D32);
      case DesktopAppType.json:
        return const Color(0xFF5B6470);
      case DesktopAppType.pdf:
        return const Color(0xFFD32F2F); // rojo Adobe
    }
  }

  String get label {
    switch (this) {
      case DesktopAppType.jupyter:
        return 'Jupyter';
      case DesktopAppType.excel:
        return 'Excel';
      case DesktopAppType.csv:
        return 'CSV';
      case DesktopAppType.json:
        return 'JSON';
      case DesktopAppType.pdf:
        return 'PDF';
    }
  }
}