import 'package:flutter/material.dart';

/// Snapshot de "dónde está el cursor" dentro del texto completo:
/// la línea actual, su indentación, y los límites de esa línea en el
/// texto. Es la base sobre la que se construyen las acciones
/// inteligentes — se recalcula en cada toque de botón, nunca se
/// mantiene en el tiempo.
class CursorContext {
  final String text;
  final int cursorOffset;
  final int lineStart;
  final int lineEnd;
  final String lineText;
  final String indent; // espacios iniciales de la línea actual

  const CursorContext({
    required this.text,
    required this.cursorOffset,
    required this.lineStart,
    required this.lineEnd,
    required this.lineText,
    required this.indent,
  });

  factory CursorContext.from(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;
    final cursor = selection.start >= 0 ? selection.start : text.length;

    final lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
    var lineEnd = text.indexOf('\n', cursor);
    if (lineEnd == -1) lineEnd = text.length;

    final lineText = text.substring(lineStart, lineEnd);
    final indent = RegExp(r'^[ ]*').stringMatch(lineText) ?? '';

    return CursorContext(
      text: text,
      cursorOffset: cursor,
      lineStart: lineStart,
      lineEnd: lineEnd,
      lineText: lineText,
      indent: indent,
    );
  }
}