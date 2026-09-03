import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mascot/dialogue_engine/domain/dialogue_line.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../mascot/data/svgator/pip_blink.dart';
import '../domain/exercise_config.dart';
import 'desktop_computer/desktop_computer.dart';
import '../../mascot/dialogue_engine/presentation/dialogue_bubble_for.dart';

/// Pantalla reutilizable para CUALQUIER ejercicio, en cualquier nivel.
/// Todo el contenido (diálogos, apps requeridas, dataset, problema)
/// viene de [config] — esta página no conoce ningún ejercicio en
/// particular.
class ExercisePage extends ConsumerStatefulWidget {
  final String exerciseId; // se mantiene por la ruta /exercise/:exerciseId
  final ExerciseConfig config;

  const ExercisePage({
    super.key,
    required this.exerciseId,
    required this.config,
  });

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  int _lineIndex = 0;
  bool _showBubble = false;

  // Cuando Pip termina de presentarse/explicar, se "acopla" a una
  // esquina y la PC pasa a tener el foco completo.
  bool _pipDocked = false;

  Timer? _entryTimer;

  List<DialogueLine> get _lines => widget.config.introDialogue;

  // Alto lógico (dp) del POCO M5s, donde se calibró desktopBottom = 75.0
  // (1080x2400px físicos ÷ factor de densidad 2.75 xxhdpi ≈ 873dp).
  static const _referenceHeight = 873.0;

  @override
  void initState() {
    super.initState();

    if (_lines.isEmpty) {
      _pipDocked = true;
      return;
    }

    _entryTimer = Timer(
      const Duration(seconds: 1),
      () {
        if (mounted) setState(() => _showBubble = true);
      },
    );
  }

  @override
  void dispose() {
    _entryTimer?.cancel();
    super.dispose();
  }

  void _onContinue() {
    if (_lineIndex < _lines.length - 1) {
      setState(() => _lineIndex++);
    } else {
      setState(() {
        _showBubble = false;
        _pipDocked = true;
      });
    }
  }

  void _onPipChipTapped() {
    // TODO: reabrir diálogo — más adelante aquí conectamos el sistema
    // de pistas (ExerciseConfig.hintFor) cuando el usuario pida ayuda.
  }

  Future<void> _handleExitRequest() async {
    final isEn = ref.read(localeControllerProvider).languageCode == 'en';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.homeSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isEn ? 'Exit exercise?' : '¿Salir del ejercicio?',
          style: const TextStyle(
              color: AppColors.homeTextPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          isEn ? "Your progress won't be saved." : 'Tu progreso no se guardará.',
          style: const TextStyle(color: AppColors.homeTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(isEn ? 'Cancel' : 'Cancelar',
                style: const TextStyle(color: AppColors.homeTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              isEn ? 'Yes, exit' : 'Sí, salir',
              style: const TextStyle(
                  color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locale = ref.watch(localeControllerProvider);
    final isEn = locale.languageCode == 'en';

    final heightScale = size.height / _referenceHeight;

    // Tamaño/posición de Pip en sus dos estados.
    final pipTalkingSize = size.width * 0.40;
    final pipDockedSize = size.width * 0.16;
    final pipSize = _pipDocked ? pipDockedSize : pipTalkingSize;

    final pipLeft = _pipDocked ? 16.0 : size.width * 0.08;
    final pipBottom = _pipDocked ? size.height * 0.62 : size.height * 0.16;

    // PC de escritorio: centrada, sobre el escritorio.
    final desktopWidth = size.width * 0.82; // más ancha
    final desktopBottom = 75.0 * heightScale; // escalado con referencia

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleExitRequest();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/fondo.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // ============================================================
            // PC DE ESCRITORIO
            // ============================================================
            Positioned(
              left: (size.width - desktopWidth) / 2,
              bottom: desktopBottom,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _pipDocked ? 1.0 : 0.35,
                child: IgnorePointer(
                  ignoring: !_pipDocked,
                  child: DesktopComputer(
                    config: widget.config,
                    width: desktopWidth,
                  ),
                ),
              ),
            ),

            // ============================================================
            // PIP
            // ============================================================
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: pipLeft,
              bottom: pipBottom,
              child: GestureDetector(
                onTap: _pipDocked ? _onPipChipTapped : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: pipSize,
                  height: pipSize,
                  child: const PipBlink(),
                ),
              ),
            ),

            // ============================================================
            // DIÁLOGO (arriba de Pip)
            // ============================================================
            if (!_pipDocked)
              Positioned(
                left: 20,
                right: 20,
                bottom: pipBottom + pipSize + 16,
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
                  child: _showBubble
                      ? DialogueBubbleFor(
                          key: ValueKey(_lineIndex),
                          line: _lines[_lineIndex],
                          locale: locale,
                          isLast: _lineIndex == _lines.length - 1,
                          isEn: isEn,
                          onContinue: _onContinue,
                        )
                      : const SizedBox.shrink(),
                ),
              ),

            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _handleExitRequest,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
