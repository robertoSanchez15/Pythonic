//lib\features\content\domain\exercise_node.dart

import 'activity_icon.dart';

enum ExerciseStatus { locked, unlocked, current, completed }

class ExerciseNode {
  final String id;
  final ActivityIcon icon;
  final ExerciseStatus status;

  const ExerciseNode({
    required this.id,
    required this.icon,
    required this.status,
  });

  ExerciseNode copyWith({ExerciseStatus? status}) => ExerciseNode(
        id: id,
        icon: icon,
        status: status ?? this.status,
      );
}