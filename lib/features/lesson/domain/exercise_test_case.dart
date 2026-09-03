/// Un caso de prueba ejecutable. Nunca comparamos texto del código del
/// usuario: `assertionCode` es Python que corre DESPUÉS del código del
/// usuario dentro del mismo sandbox y debe lanzar AssertionError si el
/// resultado es incorrecto. Cualquier solución válida del usuario pasa.
///
/// Nota: esto es un primer borrador — lo afinamos cuando conectemos
/// core/code_execution con Piston.
class ExerciseTestCase {
  final String id;
  final String assertionCode;

  const ExerciseTestCase({
    required this.id,
    required this.assertionCode,
  });
}