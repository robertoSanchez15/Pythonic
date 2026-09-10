import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../mascot/dialogue_engine/presentation/pip_companion.dart';
import '../domain/desktop_app_type.dart';
import '../domain/exercise_config.dart';
import 'desk_scene.dart';

class ExercisePage extends ConsumerStatefulWidget {
  final String exerciseId;
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
  late bool _pipDocked = widget.config.introDialogue.isEmpty;

  final _jupyterController = TextEditingController();
  final _jupyterFocusNode = FocusNode();
  DesktopAppType _activeApp = DesktopAppType.alwaysAvailable;

  @override
  void dispose() {
    _jupyterController.dispose();
    _jupyterFocusNode.dispose();
    super.dispose();
  }

  void _onPipChipTapped() {
    // TODO: conectar ExerciseConfig.hintFor
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
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardOpen = keyboardHeight > 0;

    final deskHeight = size.height * 0.14;
    final desktopWidth = size.width * 0.82;
    final baseGap = size.height * 0.03;
    final baseDeskTopY = baseGap + deskHeight;
    final liveDeskTopY = baseDeskTopY + keyboardHeight;

    const deskPositionOffsetFactor = 70.0 / 873.0;
    const desktopPositionOffsetFactor = -60.0 / 873.0;
    const pipPositionOffsetFactor = 360.0 / 873.0;

    final deskPositionOffset = size.height * deskPositionOffsetFactor;
    final desktopPositionOffset = size.height * desktopPositionOffsetFactor;
    final pipPositionOffset = size.height * pipPositionOffsetFactor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleExitRequest();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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

            DeskScene(
              config: widget.config,
              screenWidth: size.width,
              deskHeight: deskHeight,
              desktopWidth: desktopWidth,
              deskTopY: liveDeskTopY,
              deskPositionOffset: deskPositionOffset,
              desktopPositionOffset: desktopPositionOffset,
              pipDocked: _pipDocked,
              jupyterInputController: _jupyterController,
              jupyterInputFocusNode: _jupyterFocusNode,
              isEn: isEn,
              activeApp: _activeApp,
              onActiveAppChanged: (app) => setState(() => _activeApp = app),
            ),

            Positioned.fill(
              child: IgnorePointer(
                ignoring: keyboardOpen,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: keyboardOpen ? 0.0 : 1.0,
                  child: PipCompanion(
                    lines: widget.config.introDialogue,
                    locale: locale,
                    screenWidth: size.width,
                    standBottom: liveDeskTopY + pipPositionOffset,
                    bubbleAnchorBottom: baseDeskTopY + pipPositionOffset,
                    onFinished: () => setState(() => _pipDocked = true),
                    onDockedTap: _onPipChipTapped,
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