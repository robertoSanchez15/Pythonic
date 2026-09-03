import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Arimo',
      scaffoldBackgroundColor: AppColors.homeBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
      ),
      textTheme: const TextTheme().apply(
        fontFamily: 'Arimo',
      ),
    );
  }
}