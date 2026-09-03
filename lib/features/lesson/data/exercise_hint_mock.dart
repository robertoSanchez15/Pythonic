// lib/features/lesson/data/exercise_hint_mock.dart
import '../../mascot/dialogue_engine/domain/dialogue_line.dart';
import '../domain/exercise_hint.dart';

ExerciseHint mockGenericHint() {
  return const ExerciseHint(
    mistakeHint: DialogueLine(
      textEs: 'Revisa el nombre de la función que estás usando.',
      textEn: 'Check the name of the function you\'re using.',
    ),
    conceptualExplanation: DialogueLine(
      textEs: 'print() muestra texto en pantalla.',
      textEn: 'print() displays text on screen.',
    ),
    reasoningExplanation: DialogueLine(
      textEs: 'Necesitas llamar a print() con el texto entre paréntesis.',
      textEn: 'You need to call print() with the text inside parentheses.',
    ),
    commentedCodeExplanation: DialogueLine(
      textEs: '# print() muestra lo que le pases\nprint("Hola mundo")',
      textEn: '# print() shows whatever you pass it\nprint("Hello world")',
    ),
  );
}