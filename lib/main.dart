import 'package:flutter/material.dart';
import 'package:pythonic/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PythonicApp());
}

class PythonicApp extends StatelessWidget {
  const PythonicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pythonic',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}