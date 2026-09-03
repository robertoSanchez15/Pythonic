import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../mascot/data/svgator/pip_controller_service.dart';
import '../../../mascot/data/svgator/pip_greeting.dart';
import '../../../../core/l10n/locale_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  // Se activa cuando Pip ya terminó de precargar y vamos a
  // mostrar Language Select. Montamos a Pip de forma invisible
  // aquí mismo para "calentar" el WebView (PlatformView nativo)
  // antes de que el usuario lo vea en Language Select.
  bool _warmUpPip = false;

  @override
  void initState() {
    super.initState();

    // El splash NATIVO (flutter_native_splash) ya se mostró al
    // instante al abrir la app, así que no hace falta esperar al
    // primer frame para empezar a trabajar: arrancamos de inmediato.
    _startSplash();
  }

  Future<void> _startSplash() async {
    // ================================================================
    // 1. DURACIÓN MÍNIMA DE ESTA PANTALLA (SplashPage de Flutter)
    // ================================================================
    final splashFuture = Future.delayed(
      const Duration(milliseconds: 1200),
    );

    // ================================================================
    // 2. PRECARGA DE PIP
    // ================================================================
    final pipFuture = PipControllerService.instance.preload();

    // ================================================================
    // 3. CARGAR IDIOMA GUARDADO
    // ================================================================
    final initialLocaleFuture = loadInitialLocale();

    // ================================================================
    // 4. COMPROBAR SI YA VIO LANGUAGE SELECT
    // ================================================================
    final seenLanguageSelectFuture = hasSeenLanguageSelect();

    // ================================================================
    // 5. ESPERAR TODAS LAS TAREAS
    // ================================================================
    final results = await Future.wait([
      splashFuture,
      pipFuture,
      initialLocaleFuture,
      seenLanguageSelectFuture,
    ]);

    if (!mounted) return;

    final initialLocale = results[2] as Locale;
    final seenLanguageSelect = results[3] as bool;

    // ================================================================
    // 6. ACTUALIZAR EL IDIOMA
    // ================================================================
    ref
        .read(localeControllerProvider.notifier)
        .initializeLocale(initialLocale);

    // ================================================================
    // 7. CALENTAR EL WEBVIEW DE PIP (solo si vamos a Language Select)
    // ================================================================
    if (!seenLanguageSelect) {
      setState(() => _warmUpPip = true);
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
    }

    // ================================================================
    // 8. NAVEGACIÓN
    // ================================================================
    // Usamos pushReplacement (no go) para que Splash y la pantalla
    // siguiente animen SU TRANSICIÓN SIMULTÁNEAMENTE (crossfade real),
    // en vez de que Splash desaparezca de golpe.

    if (seenLanguageSelect) {
      context.pushReplacement('/home');
    } else {
      context.pushReplacement('/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Center(
            child: Text(
              'PYTHONIC',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ================================================================
          // PIP — montado fuera de pantalla, solo para precalentar
          // el WebView antes de llegar a Language Select.
          // ================================================================
          if (_warmUpPip)
            const Positioned(
              left: -9999,
              top: -9999,
              child: IgnorePointer(
                child: Pipgreeting(width: 244, height: 244),
              ),
            ),
        ],
      ),
    );
  }
}
