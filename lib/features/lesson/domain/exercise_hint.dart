import '../../mascot/dialogue_engine/domain/dialogue_line.dart';

/// Diálogo de Pip para cuando el usuario falla. Autorado una sola vez
/// (por ejercicio o reutilizado por categoría de error) — nunca
/// generado por IA en runtime. Ver ExerciseConfig para cómo se elige
/// cuál mostrar según el tipo de fallo.
class ExerciseHint {
  final DialogueLine mistakeHint;              // 1er fallo: pista, sin revelar la respuesta
  final DialogueLine conceptualExplanation;    // "ver respuesta" nivel 1
  final DialogueLine reasoningExplanation;     // nivel 2
  final DialogueLine commentedCodeExplanation; // nivel 3, código comentado línea por línea

  const ExerciseHint({
    required this.mistakeHint,
    required this.conceptualExplanation,
    required this.reasoningExplanation,
    required this.commentedCodeExplanation,
  });
}