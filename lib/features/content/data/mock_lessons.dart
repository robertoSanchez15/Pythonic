import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/activity_icon.dart';
import '../domain/exercise_node.dart';
import '../domain/lesson_group.dart';
import '../domain/world_info.dart';

const _defaultPattern = [
  ActivityIcon.quickTask,
  ActivityIcon.coding,
  ActivityIcon.coding,
  ActivityIcon.audit,
  ActivityIcon.toolkit,
  ActivityIcon.coding,
  ActivityIcon.quickTask,
  ActivityIcon.audit,
  ActivityIcon.coding,
  ActivityIcon.boss,
];

final currentWorldProvider = Provider<WorldInfo>((ref) {
  return const WorldInfo(
    labelEs: 'Unidad 1',
    labelEn: 'Unit 1',
    titleEs: 'Estructuras, funciones y herramientas',
    titleEn: 'Data structures, functions and tools',
    accentColor: AppColors.primaryGreen,
  );
});

final lessonGroupsProvider = Provider<List<LessonGroup>>((ref) {
  const titles = [
    ('Variables y tipos de datos', 'Variables and data types'),
    ('Strings: tu primer texto', 'Strings: your first text'),
    ('Operadores y expresiones', 'Operators and expressions'),
    ('Condicionales: if, elif, else', 'Conditionals: if, elif, else'),
    ('Loops: for y while', 'Loops: for and while'),
    ('Boss: resuelve un mini-reto', 'Boss: solve a mini-challenge'),
    ('Tu primera lista', 'Your first list'),
    ('Indexing y slicing', 'Indexing and slicing'),
    ('Tuplas: datos que no cambian', 'Tuples: data that doesn\'t change'),
    ('Diccionarios: pares clave-valor', 'Dictionaries: key-value pairs'),
    ('Sets: colecciones únicas', 'Sets: unique collections'),
    ('Herramientas integradas de secuencias', 'Built-in sequence tools'),
    ('Comprehensions', 'Comprehensions'),
    ('Boss: organiza el inventario', 'Boss: organize the inventory'),
    ('Tus primeras funciones', 'Your first functions'),
    ('Namespaces y alcance', 'Namespaces and scope'),
    ('Retornando múltiples valores', 'Returning multiple values'),
    ('Funciones como objetos', 'Functions as objects'),
    ('Manejo de errores y excepciones', 'Error and exception handling'),
    ('Boss: automatiza una tarea', 'Boss: automate a task'),
    ('Trabajando con archivos de texto', 'Working with text files'),
    ('Boss: genera un reporte de texto', 'Boss: generate a text report'),
    ('Gran Boss: tu primer entregable', 'Grand Boss: your first deliverable'),
  ];

  return List.generate(titles.length, (i) {
    final lessonId = 'm1-l${i + 1}';
    final exercises = List.generate(10, (j) {
      final isVeryFirstExercise = i == 0 && j == 0;
      return ExerciseNode(
        id: '$lessonId-ex${j + 1}',
        icon: _defaultPattern[j],
        status: isVeryFirstExercise ? ExerciseStatus.current : ExerciseStatus.locked,
      );
    });
    return LessonGroup(
      id: lessonId,
      titleEs: titles[i].$1,
      titleEn: titles[i].$2,
      exercises: exercises,
    );
  });
});