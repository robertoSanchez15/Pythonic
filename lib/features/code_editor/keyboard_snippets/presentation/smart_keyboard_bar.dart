import 'package:flutter/material.dart';

import '../domain/smart_action.dart';
import '../domain/smart_action_executor.dart';

/// Barra horizontal desplazable con los botones de estructura Python.
/// Solo necesita el controller/focusNode del editor activo — no le
/// importa dónde vive ese editor en el árbol.
class SmartKeyboardBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEn;

  static const _actions = [
    SmartActionType.ifStmt,
    SmartActionType.elifStmt,
    SmartActionType.elseStmt,
    SmartActionType.forStmt,
    SmartActionType.whileStmt,
    SmartActionType.defStmt,
    SmartActionType.classStmt,
    SmartActionType.tryStmt,
    SmartActionType.exceptStmt,
    SmartActionType.finallyStmt,
    SmartActionType.withStmt,
    SmartActionType.dedent,
    SmartActionType.indent,
  ];

  const SmartKeyboardBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEn,
  });

  void _handleTap(BuildContext context, SmartActionType type) {
    if (!focusNode.hasFocus) focusNode.requestFocus();

    final result = SmartActionExecutor.execute(controller, type, isEn: isEn);

    if (!result.success && result.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage!), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1F2937),
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final type = _actions[i];
          return _SmartButton(
            label: type.keyword,
            onTap: () => _handleTap(context, type),
          );
        },
      ),
    );
  }
}

class _SmartButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmartButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF374151),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}