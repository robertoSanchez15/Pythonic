import '../domain/jupyter_execution_result.dart';

/// Placeholder mientras no existe core/code_execution conectado a
/// Piston. Simula latencia de red real para que la UI de "ejecutando…"
/// se pueda probar desde ya. Se borra cuando exista el executor real.
Future<JupyterExecutionResult> mockPythonExecutor(String code) async {
  await Future.delayed(const Duration(milliseconds: 500));

  if (code.trim().isEmpty) {
    return const JupyterExecutionResult(output: '');
  }

  return JupyterExecutionResult(
    output: 'Salida simulada para:\n$code',
  );
}