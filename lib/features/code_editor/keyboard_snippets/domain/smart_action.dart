enum SmartActionType {
  ifStmt, elifStmt, elseStmt,
  forStmt, whileStmt,
  defStmt, classStmt,
  tryStmt, exceptStmt, finallyStmt,
  withStmt,
  indent, dedent,
}

extension SmartActionMeta on SmartActionType {
  String get keyword {
    switch (this) {
      case SmartActionType.ifStmt: return 'if';
      case SmartActionType.elifStmt: return 'elif';
      case SmartActionType.elseStmt: return 'else';
      case SmartActionType.forStmt: return 'for';
      case SmartActionType.whileStmt: return 'while';
      case SmartActionType.defStmt: return 'def';
      case SmartActionType.classStmt: return 'class';
      case SmartActionType.tryStmt: return 'try';
      case SmartActionType.exceptStmt: return 'except';
      case SmartActionType.finallyStmt: return 'finally';
      case SmartActionType.withStmt: return 'with';
      case SmartActionType.indent: return '⇥';
      case SmartActionType.dedent: return '⇤';
    }
  }

  /// elif/else/except/finally dependen de un bloque existente;
  /// el resto puede crear una estructura nueva libremente.
  bool get isContextual =>
      this == SmartActionType.elifStmt ||
      this == SmartActionType.elseStmt ||
      this == SmartActionType.exceptStmt ||
      this == SmartActionType.finallyStmt;
}