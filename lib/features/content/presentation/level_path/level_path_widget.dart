import 'package:flutter/material.dart';
import '../../domain/exercise_node.dart';
import '../../domain/lesson_group.dart';
import 'exercise_node_widget.dart';
import 'lesson_header_widget.dart';

sealed class _PathItem {}

class _HeaderItem extends _PathItem {
  final String title;
  final int groupIndex;
  _HeaderItem(this.title, this.groupIndex);
}

class _ExerciseItem extends _PathItem {
  final ExerciseNode exercise;
  final String lessonTitle;
  _ExerciseItem(this.exercise, this.lessonTitle);
}

const _zigzagPattern = [-0.65, 0.0, 0.65, 0.0];

class LevelPathWidget extends StatefulWidget {
  final List<LessonGroup> lessons;
  final Locale locale;
  final ScrollController scrollController;
  final void Function(ExerciseNode exercise, String lessonTitle) onExerciseTap;

  /// Se llama cada vez que cambia la lección "activa" bajo el world banner
  /// (null cuando el usuario todavía ve el encabezado azul directamente).
  final ValueChanged<String?> onLessonInView;

  const LevelPathWidget({
    super.key,
    required this.lessons,
    required this.locale,
    required this.scrollController,
    required this.onExerciseTap,
    required this.onLessonInView,
  });

  @override
  State<LevelPathWidget> createState() => _LevelPathWidgetState();
}

class _LevelPathWidgetState extends State<LevelPathWidget> {
  late List<_PathItem> _items;
  late List<double> _alignments;
  late List<GlobalKey> _headerKeys;
  final GlobalKey _viewportKey = GlobalKey();
  String? _lastReportedTitle;

  @override
  void initState() {
    super.initState();
    _buildItems();
    widget.scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void didUpdateWidget(covariant LevelPathWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessons != widget.lessons || oldWidget.locale != widget.locale) {
      _buildItems();
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
    }
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _buildItems() {
    final items = <_PathItem>[];
    final alignments = <double>[];
    final headerKeys = <GlobalKey>[];

    for (var g = 0; g < widget.lessons.length; g++) {
      final lesson = widget.lessons[g];
      final title = widget.locale.languageCode == 'en' ? lesson.titleEn : lesson.titleEs;
      items.add(_HeaderItem(title, g));
      alignments.add(0.0);
      headerKeys.add(GlobalKey());
      for (var i = 0; i < lesson.exercises.length; i++) {
        items.add(_ExerciseItem(lesson.exercises[i], title));
        alignments.add(_zigzagPattern[i % _zigzagPattern.length]);
      }
    }
    _items = items;
    _alignments = alignments;
    _headerKeys = headerKeys;
  }

  /// Recorre los encabezados de lección actualmente montados y determina
  /// cuál es el último que ya "pasó" por encima del borde superior del
  /// área visible del ListView (que coincide con el borde inferior del
  /// world banner). Ese es la lección "activa" durante el scroll.
  void _handleScroll() {
    final viewportBox = _viewportKey.currentContext?.findRenderObject();
    if (viewportBox is! RenderBox || !viewportBox.attached) return;

    int? activeGroupIndex;
    for (var g = 0; g < _headerKeys.length; g++) {
      final ctx = _headerKeys[g].currentContext;
      if (ctx == null) continue;
      final headerBox = ctx.findRenderObject();
      if (headerBox is! RenderBox || !headerBox.attached) continue;

      final dy = headerBox.localToGlobal(Offset.zero, ancestor: viewportBox).dy;
      if (dy <= 0) {
        activeGroupIndex = g;
      }
    }

    final title = activeGroupIndex == null
        ? null
        : (widget.locale.languageCode == 'en'
            ? widget.lessons[activeGroupIndex].titleEn
            : widget.lessons[activeGroupIndex].titleEs);

    if (title != _lastReportedTitle) {
      _lastReportedTitle = title;
      widget.onLessonInView(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: _viewportKey,
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 220),
      // Cache generoso para que el encabezado de la lección en curso siga
      // "vivo" y medible aunque el usuario avance varios ejercicios y el
      // header ya no esté físicamente en pantalla.
      cacheExtent: 2000,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];

        late final Widget node;
        if (item is _HeaderItem) {
          node = LessonHeaderWidget(
            key: _headerKeys[item.groupIndex],
            title: item.title,
            index: item.groupIndex + 1,
          );
        } else {
          final exerciseItem = item as _ExerciseItem;
          node = Align(
            alignment: Alignment(_alignments[index], 0),
            child: ExerciseNodeWidget(
              exercise: exerciseItem.exercise,
              onTap: () => widget.onExerciseTap(exerciseItem.exercise, exerciseItem.lessonTitle),
            ),
          );
        }

        final isFirstAfterHeader =
            item is _ExerciseItem && index > 0 && _items[index - 1] is _HeaderItem;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            isFirstAfterHeader ? 24 : 8,
            0,
            8,
          ),
          child: node,
        );
      },
    );
  }
}