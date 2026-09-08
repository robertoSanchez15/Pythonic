//lib\features\mascot\dialogue_engine\presentation\pip_companion.dart
import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/svgator/pip_blink.dart';
import 'dialogue_bubble.dart';
import 'dialogue_bubble_for.dart';
import '../domain/dialogue_line.dart';

/// Pip vive siempre en la misma posición/tamaño — nunca crece a
/// pantalla completa. Lo único que cambia es si hay diálogo activo
/// (bubble visible) o no.
class PipCompanion extends StatefulWidget {
  final List<DialogueLine> lines;
  final Locale locale;

  /// Ancho de la pantalla — se usa para calcular el tamaño de Pip,
  /// proporcional al ancho del dispositivo.
  final double screenWidth;

  /// Altura (desde abajo) donde se "para" Pip. Sigue al teclado
  /// (equivale a liveDeskTopY en ExercisePage).
  final double standBottom;

  /// Altura (desde abajo) usada como ancla para la burbuja de
  /// diálogo. Fija, no se mueve con el teclado (equivale a
  /// baseDeskTopY en ExercisePage).
  final double bubbleAnchorBottom;

  /// Se dispara cuando ya no hay más diálogo que mostrar — ExercisePage
  /// lo usa para que la PC pase a opacidad completa.
  final VoidCallback? onFinished;

  /// Se dispara al tocar a Pip cuando no está hablando (pedir ayuda).
  final VoidCallback? onDockedTap;

  const PipCompanion({
    super.key,
    required this.lines,
    required this.locale,
    required this.screenWidth,
    required this.standBottom,
    required this.bubbleAnchorBottom,
    this.onFinished,
    this.onDockedTap,
  });

  @override
  State<PipCompanion> createState() => _PipCompanionState();
}

class _PipCompanionState extends State<PipCompanion> {
  int _lineIndex = 0;
  bool _visible = false; // Pip + burbuja aparecen juntos, 1s tras entrar
  late bool _talking = widget.lines.isNotEmpty;

  Timer? _entryTimer;

  @override
  void initState() {
    super.initState();

    if (widget.lines.isEmpty) {
      // Sin diálogo de entrada: la PC pasa a opacidad completa de una vez.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.onFinished?.call());
    }

    _entryTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _entryTimer?.cancel();
    super.dispose();
  }

  void _onContinue() {
    if (_lineIndex < widget.lines.length - 1) {
      setState(() => _lineIndex++);
    } else {
      setState(() => _talking = false);
      widget.onFinished?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.locale.languageCode == 'en';

    final pipSize = widget.screenWidth * 0.26;
    const pipLeft = 44.0;

    // Pip se para en standBottom (sigue al teclado).
    final pipBottom = widget.standBottom;

    // La burbuja se ancla a bubbleAnchorBottom (fija), no a pipBottom,
    // para que no salte cuando el teclado empuja a Pip hacia arriba.
    final bubbleBottom = widget.bubbleAnchorBottom + pipSize + 2;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible ? 1 : 0,
      child: Stack(
        children: [
          if (_talking)
            Positioned(
              left: 20,
              right: 20,
              bottom: bubbleBottom,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.08),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: DialogueBubble(
                  key: ValueKey(_lineIndex),
                  text: widget.lines[_lineIndex].text(widget.locale),
                  continueLabel: _lineIndex < widget.lines.length - 1
                      ? (isEn ? 'Continue' : 'Continuar')
                      : (isEn ? 'Start' : 'Empezar'),
                  onContinue: _onContinue,
                ),
              ),
            ),
          Positioned(
            left: pipLeft,
            bottom: pipBottom,
            child: GestureDetector(
              onTap: !_talking ? widget.onDockedTap : null,
              child: PipBlink(width: pipSize, height: pipSize),
            ),
          ),
        ],
      ),
    );
  }
}