import 'package:flutter/material.dart';

/// Paleta central del proyecto. Todo widget debe referenciar estas
/// constantes en vez de hardcodear valores hex.
class AppColors {
  AppColors._();

  // Marca
  static const Color primaryGreen = Color(0xFF2EA043);
  static const Color primaryGreenSoft = Color(0xFFF0FDF4); // fondo activo/seleccionado

  // Texto (pantallas de tema claro)
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Fondo (pantallas de tema claro)
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;

  // Bordes y estados neutros (nodos bloqueados, inputs, etc.)
  static const Color border = Color(0xFFD1D5DB);
  static const Color disabled = Color(0xFF9CA3AF);
  static const Color lockedBg = Color(0xFFE5E7EB);

  // Gamificación
  static const Color streakFlame = Color(0xFFF97316);
  static const Color xp = primaryGreen;

  // Semántico
  static const Color success = primaryGreen;
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);

  // Home (tema oscuro específico de esta pantalla)
  static const Color homeBackground = Color(0xFF1F2C31);
  static const Color homeSurface = Color(0xFF28363C);
  static const Color homeTextPrimary = Colors.white;
  static const Color homeTextSecondary = Color(0xFFAEB8BB);
  static const Color homeLocked = Color(0xFF3A4A50);
 static const Color languajePageColor = Color(0xFFAAAAAA);
 static const Color lesson1 = Color(0xFF00B4D8);


  static const Color homeLockedIcon = Color(0xFF6B7A80);
}