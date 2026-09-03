import 'package:flutter/material.dart';

class WorldInfo {
  final String labelEs;
  final String labelEn;
  final String titleEs;
  final String titleEn;
  final Color accentColor;

  const WorldInfo({
    required this.labelEs,
    required this.labelEn,
    required this.titleEs,
    required this.titleEn,
    required this.accentColor,
  });

  String label(Locale locale) => locale.languageCode == 'en' ? labelEn : labelEs;
  String title(Locale locale) => locale.languageCode == 'en' ? titleEn : titleEs;
}