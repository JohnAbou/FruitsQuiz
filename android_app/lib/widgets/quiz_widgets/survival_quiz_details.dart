import 'dart:async';
import 'package:android_app/services/games/game_creation_service.dart';
import 'package:android_app/services/questions_services.dart';
import 'package:flutter/material.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/quizzes/quizzes_services.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/services/notification_service.dart';

class RepeatButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  const RepeatButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  bool _isPressed = false;
  Timer? _timer;

  void _startRepeating() {
    if (_isPressed) return;

    _isPressed = true;
    _timer?.cancel();

    widget.onPressed();
    _timer = Timer(const Duration(milliseconds: 500), () {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (_isPressed) {
          widget.onPressed();
        }
      });
    });
  }

  void _stopRepeating() {
    _isPressed = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startRepeating(),
      onTapUp: (_) => _stopRepeating(),
      onTapCancel: _stopRepeating,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: widget.style,
        child: widget.child,
      ),
    );
  }
}

class QuestionCountInput extends ConsumerStatefulWidget {
  const QuestionCountInput({
    super.key,
    required this.questionCount,
    required this.availableQuestions,
    required this.onChanged,
  });

  final int questionCount;
  final int availableQuestions;
  final void Function(int) onChanged;

  @override
  ConsumerState<QuestionCountInput> createState() => _QuestionCountInputState();
}

class _QuestionCountInputState extends ConsumerState<QuestionCountInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.questionCount.toString());
  }

  @override
  void didUpdateWidget(QuestionCountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionCount != widget.questionCount) {
      _controller.text = widget.questionCount.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final customColors = Theme.of(context).extension<CustomColors>();

    return SizedBox(
      width: 72,
      height: 48,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
            width: 3,
          ),
        ),
        child: TextFormField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 12,
            ),
            isDense: true,
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: customColors?.textColor,
          ),
          onChanged: (value) {
            if (value.isEmpty) return;
            final newValue = int.tryParse(value);
            if (newValue != null) {
              widget.onChanged(newValue.clamp(5, widget.availableQuestions));
            }
          },
        ),
      ),
    );
  }
}

class SurvivalQuizDetails extends ConsumerWidget {
  final VoidCallback? onBackPressed;
  
  const SurvivalQuizDetails({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final customColors = theme.extension<CustomColors>();
    final gameCreationService = ref.watch(gameCreationServiceProvider);
    final availableQuestions = ref.watch(questionsStateProvider.select((state) => state.specialQuestionCount));
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: primaryColor),
                      onPressed: onBackPressed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        S.of(context).game_creation_survival_mode,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        S.of(context).game_creation_survival_description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, color: primaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context).game_creation_question_count,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: RepeatButton(
                      onPressed: () {
                        final currentCount = ref.read(gameCreationServiceProvider).questionCount;
                        ref.read(gameCreationServiceProvider).questionCount = (currentCount - 1).clamp(5, availableQuestions);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: customColors?.buttonBox ?? Colors.white,
                        foregroundColor: customColors?.buttonText ?? primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: primaryColor,
                            width: 3,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                      child: Icon(Icons.remove, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  QuestionCountInput(
                    questionCount: ref.watch(gameCreationServiceProvider).questionCount,
                    availableQuestions: availableQuestions,
                    onChanged: (value) {
                      ref.read(gameCreationServiceProvider).questionCount = value;
                    },
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: RepeatButton(
                      onPressed: () {
                        final currentCount = ref.read(gameCreationServiceProvider).questionCount;
                        ref.read(gameCreationServiceProvider).questionCount = (currentCount + 1).clamp(5, availableQuestions);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: customColors?.buttonBox ?? Colors.white,
                        foregroundColor: customColors?.buttonText ?? primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: primaryColor,
                            width: 3,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                      child: Icon(Icons.add, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => ref.read(gameCreationServiceProvider).questionCount = availableQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customColors?.buttonBox ?? Colors.white,
                        foregroundColor: customColors?.buttonText ?? primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: primaryColor,
                            width: 3,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                      child: Text(
                        'MAX ${availableQuestions}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: customColors?.buttonText ?? primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final questionCount = gameCreationService.questionCount;
                      if (questionCount < 5) {
                        ref.read(notificationServiceProvider).showBottomLeftNotification(
                          S.of(context).game_creation_not_enough_questions,
                        );
                        return;
                      }
                      if (questionCount > availableQuestions) {
                        ref.read(notificationServiceProvider).showBottomLeftNotification(
                          S.of(context).game_creation_max_questions(availableQuestions),
                        );
                        return;
                      }
                      gameCreationService.createGame(survivalQuiz.id, true);
                      context.go('/game-view');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors?.buttonBox ?? Colors.white,
                      foregroundColor: customColors?.buttonText ?? primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: primaryColor,
                          width: 3,
                        ),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                    ),
                    child: Text(
                      S.of(context).game_creation_create_game,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: customColors?.buttonText ?? primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
