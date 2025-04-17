import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/games/qre_answer_service.dart';
import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/game_state_service.dart';
import '../../services/games/game_current_question_service.dart';
import 'package:android_app/generated/l10n.dart';

class QreAnswer extends ConsumerStatefulWidget {
  const QreAnswer({super.key});

  @override
  ConsumerState<QreAnswer> createState() => _QreAnswerState();
}

class _QreAnswerState extends ConsumerState<QreAnswer> {
  late TextEditingController _textController;
  double? _currentValue;

  final Color correctColor = const Color(0xFF009688);

  List<double> _getBoundsAndMiddle() {
    final question =
        ref.read(gameCurrentQuestionProvider.select((state) => state.question));
    final estimations = question.estimations;
    final double lowerBound = estimations?.lowerBound.toDouble() ?? 0;
    final double upperBound = estimations?.upperBound.toDouble() ?? 100;
    final double middleValue = lowerBound + (upperBound - lowerBound) / 2;
    return [lowerBound, upperBound, middleValue];
  }

  @override
  void initState() {
    super.initState();
    final userAnswer =
        ref.read(qreAnswerStateProvider.select((state) => state.userAnswer));
    final [_, _, middleValue] = _getBoundsAndMiddle();

    _currentValue = userAnswer != null ? userAnswer.toDouble() : middleValue;
    _textController =
        TextEditingController(text: _currentValue!.toStringAsFixed(0));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userAnswer == null) {
        ref
            .read(qreAnswerServiceProvider)
            .updateNumericAnswer(_currentValue!.toInt());
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateValue(double newValue) {
    setState(() {
      _currentValue = newValue;
      _textController.text = newValue.toStringAsFixed(0);
    });
    ref.read(qreAnswerServiceProvider).updateNumericAnswer(newValue.toInt());
  }

  void _updateToCorrectAnswer() {
    final correctAnswer =
        ref.read(qreAnswerStateProvider.select((state) => state.correctAnswer));
    setState(() {
      _currentValue = correctAnswer.toDouble();
      _textController.text = correctAnswer.toString();
    });
  }

  Widget _buildNumericInput({required double width}) {
    final showCorrectAnswer = ref.watch(
        qreAnswerStateProvider.select((state) => state.showCorrectAnswer));
    final correctAnswer = ref
        .watch(qreAnswerStateProvider.select((state) => state.correctAnswer));
    final gameRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));
    final isPlayer = gameRole == UserGameRole.player;

    final [lowerBound, upperBound, middleValue] = _getBoundsAndMiddle();

    if (showCorrectAnswer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateToCorrectAnswer();
      });
    }

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPlayer && showCorrectAnswer)
            Text(
              S.of(context).qre_correct_answer_is(correctAnswer.toString()),
              style: TextStyle(
                fontSize: width * 0.08,
                color: correctColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          TextField(
            enabled: isPlayer && !showCorrectAnswer,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.1,
              color: (isPlayer && !showCorrectAnswer)
                  ? const Color.fromARGB(255, 23, 23, 23)
                  : showCorrectAnswer
                      ? correctColor
                      : Colors.grey,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: showCorrectAnswer ? correctColor : Colors.grey,
                  width: showCorrectAnswer ? 2.0 : 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: showCorrectAnswer ? correctColor : Colors.grey,
                  width: showCorrectAnswer ? 2.0 : 1.0,
                ),
              ),
              hintText: S.of(context).enter_answer,
            ),
            controller: _textController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
            ],
            onChanged: isPlayer
                ? (value) {
                    if (value.isEmpty) {
                      setState(() {});
                      return;
                    }
                    final parsedValue = double.tryParse(value);
                    if (parsedValue != null) {
                      setState(() {
                        _currentValue = parsedValue;
                      });
                    }
                  }
                : null,
            onEditingComplete: () {
              if (_textController.text.isEmpty) {
                _updateValue(lowerBound);
              } else {
                final parsedValue =
                    double.tryParse(_textController.text) ?? middleValue;
                _updateValue(parsedValue);
              }
            },
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 10.0,
              activeTrackColor: showCorrectAnswer ? correctColor : null,
              thumbColor: showCorrectAnswer ? correctColor : null,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value:
                  (_currentValue ?? lowerBound).clamp(lowerBound, upperBound),
              min: lowerBound,
              max: upperBound,
              divisions: (upperBound - lowerBound).toInt(),
              onChanged: (isPlayer && !showCorrectAnswer)
                  ? (value) {
                      _updateValue(value);
                    }
                  : null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context)
                    .qre_slider_min_value(lowerBound.toStringAsFixed(0)),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 34, 34, 34)),
              ),
              Text(
                S.of(context)
                    .qre_slider_max_value(upperBound.toStringAsFixed(0)),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 34, 34, 34)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimations() {
    final question = ref
        .watch(gameCurrentQuestionProvider.select((state) => state.question));
    if (question.estimations == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            question.estimations!.toleranceMargin == 0
                ? S.of(context).qre_correct_answer_is(
                    question.estimations!.exactValue.toString())
                : S.of(context).qre_correct_answer_with_tolerance(
                      question.estimations!.exactValue.toString(),
                      question.estimations!.toleranceMargin.toString(),
                    ),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: correctColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth * 0.3;
    final isOrganizer = gameRole == UserGameRole.organizer;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNumericInput(width: inputWidth),
          if (isOrganizer) _buildEstimations(),
        ],
      ),
    );
  }
}
