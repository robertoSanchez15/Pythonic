// lib/features/lesson/data/exercise_config_mock.dart
import '../../content/domain/activity_icon.dart';
import '../../mascot/dialogue_engine/domain/dialogue_line.dart';
import '../domain/desktop_app_type.dart';
import '../domain/exercise_config.dart';
import '../domain/failure_category.dart';
import 'exercise_hint_mock.dart'; // ver nota abajo

ExerciseConfig mockPipIntroConfig() {
  return ExerciseConfig(
    id: 'demo-1',
    activityType: ActivityIcon.coding,
    cycleStep: LearningCycleStep.pipExample,
    introDialogue: const [
      DialogueLine(
        textEs:
            'Hola, felicidades por entrar a la empresa. Yo soy Pip, una inteligencia artificial que te va a acompañar en tu día a día en esta oficina.',
        textEn:
            "Hi, congratulations on joining the company. I'm Pip, an AI that's going to be with you day to day in this office.",
      ),
      DialogueLine(
        textEs:
            'Cuando te trabes en un ejercicio, solo tócame y te ayudo a encontrar el camino — sin darte la respuesta de una vez.',
        textEn:
            "Whenever you get stuck, just tap me and I'll help you find the way — without just giving you the answer.",
      ),
      DialogueLine(
        textEs: '¿Listo para tu primer día? Vamos a tu escritorio.',
        textEn: "Ready for your first day? Let's go to your desk.",
      ),
    ],
    instructions: const DialogueLine(
      textEs: 'Abre Jupyter y saluda al mundo con print().',
      textEn: 'Open Jupyter and greet the world with print().',
    ),
    requiredApps: const [DesktopAppType.excel, DesktopAppType.pdf],
    datasets: const [],
    starterCode: '',
    testCases: const [],
    hints: const {},
    genericHint: mockGenericHint(),
  );
}