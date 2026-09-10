import 'package:flutter/material.dart';

import '../../../domain/jupyter_execution_result.dart';

class _ExecutedCell {
  final String input;
  JupyterExecutionResult? result;
  _ExecutedCell({required this.input, this.result});
}

class JupyterApp extends StatefulWidget {
  final Future<JupyterExecutionResult> Function(String code) onExecute;
  final TextEditingController controller;
  final FocusNode focusNode;

  const JupyterApp({
    super.key,
    required this.onExecute,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<JupyterApp> createState() => _JupyterAppState();
}

class _JupyterAppState extends State<JupyterApp> {
  final _cells = <_ExecutedCell>[];
  final _scrollController = ScrollController();

  static const _codeStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Color(0xFF1F2937),
  );

  @override
  void dispose() {
    // controller y focusNode NO se destruyen aquí — su dueño es
    // ExercisePage, que los mantiene vivos entre cambios de app.
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _runCell() async {
    final code = widget.controller.text;
    if (code.trim().isEmpty) return;

    final cell = _ExecutedCell(input: code);
    setState(() => _cells.add(cell));
    widget.controller.clear();
    _scrollToBottom();

    final result = await widget.onExecute(code);
    setState(() => cell.result = result);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < _cells.length; i++)
                    _CellRow(index: i + 1, cell: _cells[i]),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          _InputBar(
            index: _cells.length + 1,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onRun: _runCell,
          ),
        ],
      ),
    );
  }
}

class _CellRow extends StatelessWidget {
  final int index;
  final _ExecutedCell cell;

  const _CellRow({required this.index, required this.cell});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('In [$index]:',
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(cell.input, style: _JupyterAppState._codeStyle),
                ),
              ],
            ),
          ),
          if (cell.result == null)
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 8),
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (cell.result!.output.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Out[$index]:',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cell.result!.isError
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cell.result!.output,
                      style: _JupyterAppState._codeStyle.copyWith(
                        color: cell.result!.isError
                            ? const Color(0xFFDC2626)
                            : _JupyterAppState._codeStyle.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onRun;

  const _InputBar({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onRun,
  });

  static const _maxHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('In [$index]:',
                style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: _maxHeight),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: IntrinsicWidth(
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              maxLines: null,
                              style: _JupyterAppState._codeStyle,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Color(0xFF16A34A)),
            onPressed: onRun,
          ),
        ],
      ),
    );
  }
}