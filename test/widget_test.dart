import 'package:flutter_test/flutter_test.dart';

// 1. Importa tu archivo main.dart
import 'package:pythonic/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 2. Cambia MyApp() por PythonicApp()
    await tester.pumpWidget(const PythonicApp());

    // Resto del código del test...
  });
}