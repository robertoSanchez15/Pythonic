//lib\features\mascot\dialogue_engine\presentation\dialogue_bubble_for.dart

import 'package:flutter/material.dart';

import '../domain/dialogue_line.dart';
import 'dialogue_bubble.dart';

/// Adapta un DialogueLine + locale al DialogueBubble existente, sin
/// modificar DialogueBubble (que se sigue usando también en feedback
/// de error, boss, etc.).
class DialogueBubbleFor extends StatelessWidget {
  final DialogueLine line;
  final Locale locale;
  final bool isLast;
  final bool isEn;
  final VoidCallback onContinue;

  const DialogueBubbleFor({
    super.key,
    required this.line,
    required this.locale,
    required this.isLast,
    required this.isEn,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return DialogueBubble(
      text: line.text(locale),
      continueLabel: isLast
          ? (isEn ? 'Start' : 'Empezar')
          : (isEn ? 'Continue' : 'Continuar'),
      onContinue: onContinue,
    );
  }
}