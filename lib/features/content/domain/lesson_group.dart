import 'exercise_node.dart';

class LessonGroup {
  final String id;
  final String titleEs;
  final String titleEn;
  final List<ExerciseNode> exercises; // siempre 10, el último es boss

  const LessonGroup({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.exercises,
  });
}