//lib\features\mascot\dialogue_engine\domain\dialogue_line.dart

import 'package:flutter/material.dart';

class DialogueLine {
  final String textEs;
  final String textEn;
  final String speaker; // 'pip' por defecto — reservado para 'jefe' u otros a futuro

  const DialogueLine({
    required this.textEs,
    required this.textEn,
    this.speaker = 'pip',
  });

  String text(Locale locale) => locale.languageCode == 'en' ? textEn : textEs;
}