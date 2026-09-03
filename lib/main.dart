import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pythonic/core/l10n/locale_controller.dart';
import 'package:pythonic/core/l10n/l10n.dart';
import 'package:pythonic/core/router/app_router.dart';
import 'package:pythonic/core/theme/app_theme.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // ================================================================
  // Mantenemos visible el splash NATIVO (el que aparece al instante
  // al tocar el ícono, antes incluso de que Flutter esté listo)
  // hasta que se pinte el primer frame de Flutter.
  //
  // Con esto: usuario toca el ícono -> splash nativo (blanco,
  // instantáneo, sin negro) -> primer frame de Flutter listo
  // (SplashPage) -> se retira el splash nativo. El usuario nunca
  // ve una pantalla negra.
  // ================================================================
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    ProviderScope(
      child: const PythonicApp(),
    ),
  );

  // ================================================================
  // Retiramos el splash nativo justo después del primer frame.
  // ================================================================
  widgetsBinding.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}

class PythonicApp extends ConsumerWidget {
  const PythonicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'Pythonic',
      debugShowCheckedModeBanner: false,

      // ============================================================
      // TEMA GLOBAL
      // ============================================================

      theme: AppTheme.light,

      // ============================================================
      // LOCALIZACIÓN
      // ============================================================

      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // ============================================================
      // ROUTER
      // ============================================================

      routerConfig: appRouter,
    );
  }
}