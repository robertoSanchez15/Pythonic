//lib\core\router\app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pythonic/features/onboarding/splash/presentation/splash_page.dart';
import 'package:pythonic/features/onboarding/language_select/presentation/language_select_page.dart';
import 'package:pythonic/features/home/presentation/home_page.dart';
import '../../features/lesson/presentation/exercise_page.dart';
import '../../features/lesson/data/exercise_config_mock.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  routes: [
    // ================================================================
    // SPLASH
    // ================================================================
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              // Fade IN por si alguna vez se reingresa a Splash (raro).
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: FadeTransition(
                // Fade OUT: se activa cuando pushReplacement trae la
                // siguiente pantalla. Esto es lo que faltaba — ahora
                // Splash sí se desvanece en vez de desaparecer de golpe.
                opacity: Tween<double>(begin: 1, end: 0).animate(
                  CurvedAnimation(
                    parent: secondaryAnimation,
                    curve: Curves.easeIn,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
      },
    ),

    // ================================================================
    // LANGUAGE SELECT
    // ================================================================
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LanguageSelectPage(),
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
      },
    ),

    // ================================================================
    // HOME
    // ================================================================
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ================================================================
    // EXERCISE
    // ================================================================
    GoRoute(
      path: '/exercise/:exerciseId',
      pageBuilder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ExercisePage(
            exerciseId: 'demo-1',
            config: mockPipIntroConfig(),
          ),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
    ),
  ],
);
