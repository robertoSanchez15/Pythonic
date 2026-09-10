/// Ubica el bloque "compatible" para elif/else/except/finally, sin
/// necesidad de un parser Python completo. Python define sus bloques
/// enteramente por indentación, así que escanear hacia arriba
/// comparando niveles de indentación es una solución alineada con el
/// lenguaje, no una búsqueda de texto frágil.
class BlockMatch {
  final int indentLevel; // cantidad de espacios de la línea encontrada
  const BlockMatch({required this.indentLevel});
}

class PythonBlockScanner {
  /// Busca, subiendo desde la línea anterior a [cursorLineStart], la
  /// línea no vacía más cercana cuya indentación sea IGUAL a la
  /// primera línea no vacía encontrada (el "techo" de búsqueda), y que
  /// además empiece con alguna palabra de [openers]. Si en el camino
  /// aparece una línea con MENOR indentación antes de encontrar un
  /// opener válido, se considera que no hay bloque compatible.
  static BlockMatch? findCompatibleBlock(
    String text,
    int cursorLineStart,
    List<String> openers,
  ) {
    final before = text.substring(0, cursorLineStart);
    final lines = before.split('\n');

    int? targetIndent;

    for (var i = lines.length - 1; i >= 0; i--) {
      final line = lines[i];
      if (line.trim().isEmpty) continue;

      final indent = RegExp(r'^[ ]*').stringMatch(line)!.length;
      final trimmed = line.trimLeft();

      targetIndent ??= indent;

      if (indent > targetIndent) continue; // más anidada, seguir subiendo
      if (indent < targetIndent) return null; // salimos del bloque, no hay match

      final isOpener = openers.any((o) =>
          trimmed == '$o:' ||
          trimmed.startsWith('$o ') ||
          trimmed.startsWith('$o('));

      if (isOpener) return BlockMatch(indentLevel: indent);

      // Misma indentación pero no es un opener válido (ej. otra
      // sentencia normal al mismo nivel) → no hay bloque compatible.
      return null;
    }
    return null;
  }
}