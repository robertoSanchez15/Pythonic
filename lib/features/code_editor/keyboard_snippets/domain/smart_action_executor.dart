import 'package:flutter/material.dart';

import '../../free_editor/domain/cursor_context.dart';
import '../../free_editor/domain/python_block_scanner.dart';
import 'smart_action.dart';

const _indentUnit = '    '; // 4 espacios, nunca \t

class SmartActionResult {
  final bool success;
  final String? errorMessage; // solo si success == false

  const SmartActionResult.ok() : success = true, errorMessage = null;
  const SmartActionResult.failed(String message)
      : success = false, errorMessage = message;
}

/// Palabras de placeholder — bilingües, nunca se guardan literalmente
/// en el código: siempre quedan SELECCIONADAS al insertarse, así que
/// el primer caracter que el usuario escriba las reemplaza por
/// completo, sin dejar corchetes ni marcadores.
class _Placeholders {
  static String condition(bool isEn) => isEn ? 'condition' : 'condición';
  static String variable(bool isEn) => isEn ? 'variable' : 'variable';
  static String iterable(bool isEn) => isEn ? 'iterable' : 'iterable';
  static String name(bool isEn) => isEn ? 'name' : 'nombre';
  static String parameters(bool isEn) => isEn ? 'parameters' : 'parámetros';
  static String className(bool isEn) => isEn ? 'Name' : 'Nombre';
  static String errorType(bool isEn) => isEn ? 'Error' : 'Error';
  static String expression(bool isEn) => isEn ? 'expression' : 'expresión';
}

class SmartActionExecutor {
  /// Ejecuta la acción sobre [controller], modificando su texto y
  /// selección directamente. [isEn] decide el idioma de los
  /// placeholders y de cualquier mensaje de error.
  static SmartActionResult execute(
    TextEditingController controller,
    SmartActionType type, {
    required bool isEn,
  }) {
    if (type == SmartActionType.indent) {
      _applyIndentToSelection(controller, add: true);
      return const SmartActionResult.ok();
    }
    if (type == SmartActionType.dedent) {
      _applyIndentToSelection(controller, add: false);
      return const SmartActionResult.ok();
    }

    if (type.isContextual) {
      return _insertContextual(controller, type, isEn: isEn);
    }
    return _insertStructural(controller, type, isEn: isEn);
  }

  // ================================================================
  // ESTRUCTURAS NUEVAS: if, for, while, def, class, try, with
  // ================================================================
  static SmartActionResult _insertStructural(
    TextEditingController controller,
    SmartActionType type, {
    required bool isEn,
  }) {
    final ctx = CursorContext.from(controller);
    final selection = controller.selection;
    final hasSelection = selection.isValid && !selection.isCollapsed;
    final selectedText =
        hasSelection ? controller.text.substring(selection.start, selection.end) : null;

    final indent = ctx.indent;

    // headSegment: lo que va antes del placeholder/selección; keyword
    // ya incluye el espacio final donde aplica.
    late String keywordPrefix; // ej. "if "
    late String? placeholderWord; // null si no hay placeholder (raro aquí)
    late String suffix; // lo que va después del placeholder, antes de ':'

    switch (type) {
      case SmartActionType.ifStmt:
        keywordPrefix = 'if ';
        placeholderWord = _Placeholders.condition(isEn);
        suffix = '';
        break;
      case SmartActionType.forStmt:
        keywordPrefix = 'for ';
        placeholderWord = _Placeholders.variable(isEn);
        suffix = ' in ${_Placeholders.iterable(isEn)}';
        break;
      case SmartActionType.whileStmt:
        keywordPrefix = 'while ';
        placeholderWord = _Placeholders.condition(isEn);
        suffix = '';
        break;
      case SmartActionType.defStmt:
        keywordPrefix = 'def ';
        placeholderWord = _Placeholders.name(isEn);
        suffix = '(${_Placeholders.parameters(isEn)})';
        break;
      case SmartActionType.classStmt:
        keywordPrefix = 'class ';
        placeholderWord = _Placeholders.className(isEn);
        suffix = '';
        break;
      case SmartActionType.tryStmt:
        keywordPrefix = 'try';
        placeholderWord = null;
        suffix = '';
        break;
      case SmartActionType.withStmt:
        keywordPrefix = 'with ';
        placeholderWord = _Placeholders.expression(isEn);
        suffix = '';
        break;
      default:
        return const SmartActionResult.failed('unreachable');
    }

    // Si el usuario ya seleccionó texto (ej. "edad >= 18"), se usa
    // como contenido ya resuelto del placeholder en vez de dejarlo
    // como plantilla genérica — sección 22 de la especificación.
    final placeholderContent = selectedText ?? placeholderWord ?? '';
    final headLine = '$indent$keywordPrefix$placeholderContent$suffix:';
    final bodyLine = '$indent$_indentUnit';

    final insertStart = hasSelection ? selection.start : ctx.cursorOffset;
    final insertEnd = hasSelection ? selection.end : ctx.cursorOffset;

    final newText = ctx.text.replaceRange(insertStart, insertEnd, '$headLine\n$bodyLine');

    late TextSelection newSelection;
    if (selectedText != null) {
      // El placeholder ya viene resuelto: el cursor pasa al cuerpo,
      // listo para que el usuario escriba la primera línea del bloque.
      final bodyOffset = insertStart + headLine.length + 1 + bodyLine.length;
      newSelection = TextSelection.collapsed(offset: bodyOffset);
    } else if (placeholderWord != null) {
      // Selecciona el placeholder recién insertado, para que el
      // primer caracter que el usuario escriba lo reemplace entero.
      final placeholderStart = insertStart + keywordPrefix.length;
      final placeholderEnd = placeholderStart + placeholderWord.length;
      newSelection = TextSelection(
        baseOffset: placeholderStart,
        extentOffset: placeholderEnd,
      );
    } else {
      // Sin placeholder (ej. try): cursor directo en el cuerpo.
      final bodyOffset = insertStart + headLine.length + 1 + bodyLine.length;
      newSelection = TextSelection.collapsed(offset: bodyOffset);
    }

    controller.value = TextEditingValue(text: newText, selection: newSelection);
    return const SmartActionResult.ok();
  }

  // ================================================================
  // CONTEXTUALES: elif, else, except, finally
  // ================================================================
  static SmartActionResult _insertContextual(
    TextEditingController controller,
    SmartActionType type, {
    required bool isEn,
  }) {
    final ctx = CursorContext.from(controller);

    final openers = (type == SmartActionType.elifStmt || type == SmartActionType.elseStmt)
        ? const ['if', 'elif']
        : const ['try', 'except'];

    final match = PythonBlockScanner.findCompatibleBlock(ctx.text, ctx.lineStart, openers);

    if (match == null) {
      final blockWord = openers.first; // 'if' o 'try'
      final message = isEn
          ? 'No compatible "$blockWord" block found here.'
          : 'No se encontró un bloque "$blockWord" compatible aquí.';
      return SmartActionResult.failed(message);
    }

    final targetIndent = ' ' * match.indentLevel;
    String headLine;
    String? placeholderWord;

    switch (type) {
      case SmartActionType.elifStmt:
        placeholderWord = _Placeholders.condition(isEn);
        headLine = '${targetIndent}elif $placeholderWord:';
        break;
      case SmartActionType.elseStmt:
        placeholderWord = null;
        headLine = '${targetIndent}else:';
        break;
      case SmartActionType.exceptStmt:
        placeholderWord = _Placeholders.errorType(isEn);
        headLine = '${targetIndent}except $placeholderWord:';
        break;
      case SmartActionType.finallyStmt:
        placeholderWord = null;
        headLine = '${targetIndent}finally:';
        break;
      default:
        return const SmartActionResult.failed('unreachable');
    }

    final bodyLine = '$targetIndent$_indentUnit';
    // Se inserta al final de la línea actual del cursor — así, sin
    // importar qué tan anidado esté el cursor dentro del bloque, el
    // nuevo elif/else/except/finally siempre "sale" al nivel correcto.
    final insertAt = ctx.lineEnd;
    final newText = ctx.text.replaceRange(insertAt, insertAt, '\n$headLine\n$bodyLine');

    late TextSelection newSelection;
    if (placeholderWord != null) {
      final placeholderStart = insertAt + 1 + targetIndent.length + type.keyword.length + 1;
      final placeholderEnd = placeholderStart + placeholderWord.length;
      newSelection = TextSelection(baseOffset: placeholderStart, extentOffset: placeholderEnd);
    } else {
      final bodyOffset = insertAt + 1 + headLine.length + 1 + bodyLine.length;
      newSelection = TextSelection.collapsed(offset: bodyOffset);
    }

    controller.value = TextEditingValue(text: newText, selection: newSelection);
    return const SmartActionResult.ok();
  }

  // ================================================================
  // TAB / SHIFT+TAB — soporta selección multilínea
  // ================================================================
  static void _applyIndentToSelection(TextEditingController controller, {required bool add}) {
    final text = controller.text;
    final selection = controller.selection;

    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    var blockStart = text.lastIndexOf('\n', start - 1) + 1;
    var blockEnd = text.indexOf('\n', end - 1);
    if (blockEnd == -1) blockEnd = text.length;

    final block = text.substring(blockStart, blockEnd);
    final lines = block.split('\n');

    var deltaFirstLine = 0;
    final newLines = lines.map((line) {
      if (add) {
        return '$_indentUnit$line';
      }
      final removable = line.length - line.trimLeft().length;
      final toRemove = removable < _indentUnit.length ? removable : _indentUnit.length;
      if (lines.indexOf(line) == 0) deltaFirstLine = -toRemove;
      return line.substring(toRemove);
    }).toList();

    final newBlock = newLines.join('\n');
    final newText = text.replaceRange(blockStart, blockEnd, newBlock);

    final delta = add ? _indentUnit.length : deltaFirstLine;
    final newSelection = TextSelection(
      baseOffset: (start + delta).clamp(blockStart, newText.length),
      extentOffset: (end + (newBlock.length - block.length)).clamp(blockStart, newText.length),
    );

    controller.value = TextEditingValue(text: newText, selection: newSelection);
  }
}