/// Categoriza por qué falló la ejecución del usuario, siempre por
/// comportamiento (nunca comparando texto de código).
enum FailureCategory {
  wrongOutput,
  exceptionRaised,
  timeout,
  missingConstruct,
}