import 'question_model.dart';

class QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;
  final bool quizFinished;

  QuizState({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.quizFinished = false,
  });

  Question currentQuestion() => questions[currentQuestionIndex];
}
