import 'question_model.dart';

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final bool quizFinished;
  final List<String> shuffledAnswers;

  QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.score = 0,
    this.quizFinished = false,
    this.shuffledAnswers = const [],
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    int? score,
    bool? quizFinished,
    List<String>? shuffledAnswers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      quizFinished: quizFinished ?? this.quizFinished,
      shuffledAnswers: shuffledAnswers ?? this.shuffledAnswers,
    );
  }
}
