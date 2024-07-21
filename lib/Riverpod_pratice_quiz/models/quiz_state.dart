import 'package:quiz_marcus_ng/Riverpod_pratice_quiz/models/model.dart';

class QuizState {
  final List<Question> questions;
  final int score;
  final int currentIndex;
  final String errorMessage;
  bool quizFinished;

  QuizState({
    required this.questions,
    this.score = 0,
    this.currentIndex = 0,
    this.errorMessage = '',
    this.quizFinished = false,
  });
}
