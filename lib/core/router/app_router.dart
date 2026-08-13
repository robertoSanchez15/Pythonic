import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pythonic/features/onboarding/splash/presentation/splash_page.dart';
import 'package:pythonic/features/onboarding/language_select/presentation/language_select_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: SplashPage(),
        );
      },
    ),

    GoRoute(
      path: '/language',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LanguageSelectPage(),
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 500),

          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
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

    // Más adelante:
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
);