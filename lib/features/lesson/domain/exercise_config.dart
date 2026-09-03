import '../../content/domain/activity_icon.dart';
import '../../mascot/dialogue_engine/domain/dialogue_line.dart';
import 'desktop_app_type.dart';
import 'exercise_hint.dart';
import 'exercise_test_case.dart';
import 'failure_category.dart';
import 'fake_dataset.dart';

/// En qué punto del ciclo de 4 pasos está este ejercicio. Se decide
/// explícitamente por lección, nunca se asume "siempre 4 pasos"
/// (regla de desvanecimiento de andamiaje).
enum LearningCycleStep {
  pipExample,      // paso 1: Pip resuelve pensando en voz alta, usuario no escribe
  guidedPractice,  // paso 2: casi idéntico al ejemplo de Pip, usuario completa el paso final
  freePractice,    // paso 3: mismo patrón, contexto nuevo, solución completa
  mixedPractice,   // paso 4: mezcla con conceptos anteriores
}

/// El contrato completo de un ejercicio. ExercisePage nunca contiene
/// contenido propio: todo lo que necesita para reciclarse viene de aquí.
class ExerciseConfig {
  final String id; // debe matchear ExerciseNode.id
  final ActivityIcon activityType;
  final LearningCycleStep cycleStep;

  // Qué dice Pip antes de que el usuario empiece a trabajar. Puede ser
  // una lista vacía cuando el andamiaje ya se desvaneció para ese mundo.
  final List<DialogueLine> introDialogue;

  final DialogueLine instructions; // el "encargo" del jefe/situación laboral

  // Apps de escritorio que este ejercicio necesita, sin contar Jupyter
  // (Jupyter se agrega siempre automáticamente, ver dockApps).
  final List<DesktopAppType> requiredApps;
  final List<FakeDataset> datasets;

  final String starterCode;
  final List<ExerciseTestCase> testCases;

  // Pistas específicas por tipo de fallo; si una categoría no está
  // definida aquí, se usa genericHint como respaldo.
  final Map<FailureCategory, ExerciseHint> hints;
  final ExerciseHint genericHint;

  const ExerciseConfig({
    required this.id,
    required this.activityType,
    required this.cycleStep,
    required this.introDialogue,
    required this.instructions,
    required this.requiredApps,
    required this.datasets,
    required this.starterCode,
    required this.testCases,
    required this.hints,
    required this.genericHint,
  });

  /// Apps que debe mostrar el dock, con Jupyter siempre incluido y sin
  /// duplicados.
  List<DesktopAppType> get dockApps => {
        DesktopAppType.alwaysAvailable,
        ...requiredApps,
      }.toList();

  ExerciseHint hintFor(FailureCategory category) =>
      hints[category] ?? genericHint;
}