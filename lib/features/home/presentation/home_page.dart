import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../content/data/mock_lessons.dart';
import '../../content/domain/exercise_node.dart';
import '../../content/presentation/level_path/level_path_widget.dart';
import '../../content/presentation/level_path/level_info_card.dart';
import '../../content/presentation/level_path/world_banner.dart';
import 'widgets/home_header.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? userName;

  const HomePage({super.key, this.userName});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();

  ExerciseNode? _focusedExercise;
  String? _focusedLessonTitle;
  String? _currentLessonInView;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = ref.watch(lessonGroupsProvider);
    final world = ref.watch(currentWorldProvider);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HomeHeader(
                  userName: widget.userName,
                  streakDays: 0,
                  xp: 0,
                ),

                WorldBanner(
                  label: world.label(locale),
                  title: world.title(locale),
                  accentColor: world.accentColor,
                  currentSubtitle: _currentLessonInView,
                ),

                Expanded(
                  child: LevelPathWidget(
                    lessons: lessons,
                    locale: locale,
                    scrollController: _scrollController,
                    onLessonInView: (title) {
                      setState(() => _currentLessonInView = title);
                    },
                    onExerciseTap: (exercise, lessonTitle) async {
                      // No mostramos la tarjeta al ir hacia el ejercicio —
                      // solo cuando el usuario regresa (pop) hacia Home.
                      await context.push('/exercise/${exercise.id}');

                      if (!mounted) return;

                      setState(() {
                        _focusedExercise = exercise;
                        _focusedLessonTitle = lessonTitle;
                      });
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LevelInfoCard(
                exercise: _focusedExercise,
                lessonTitle: _focusedLessonTitle,
                buttonLabel: _buttonLabelFor(
                  _focusedExercise?.status,
                  locale,
                ),
                onPressed: () {
                  if (_focusedExercise != null) {
                    context.push('/exercise/${_focusedExercise!.id}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buttonLabelFor(
    ExerciseStatus? status,
    Locale locale,
  ) {
    final isEn = locale.languageCode == 'en';

    switch (status) {
      case ExerciseStatus.completed:
        return isEn ? 'Review' : 'Repasar';

      case ExerciseStatus.current:
        return isEn ? 'Continue' : 'Continuar';

      case ExerciseStatus.unlocked:
        return isEn ? 'Start' : 'Comenzar';

      case ExerciseStatus.locked:
      case null:
        return isEn ? 'Locked' : 'Bloqueado';
    }
  }
}