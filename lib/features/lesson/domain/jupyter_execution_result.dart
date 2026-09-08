/// Resultado de ejecutar una celda. isError decide el color del output
/// (rojo si es un traceback, negro si es print/return normal).
class JupyterExecutionResult {
  final String output;
  final bool isError;

  const JupyterExecutionResult({
    required this.output,
    this.isError = false,
  });
}