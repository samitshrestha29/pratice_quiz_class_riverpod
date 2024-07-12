import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api_quiz_copywith/services/service.dart';
import 'dart:math';
import '../models/quiz_state.dart';

final quizServiceProvider = Provider((ref) => QuizService());

final quizControllerProvider =
    StateNotifierProvider<QuizController, QuizState>((ref) {
  return QuizController(ref.read(quizServiceProvider));
});

class QuizController extends StateNotifier<QuizState> {
  final QuizService quizService;

  QuizController(this.quizService) : super(QuizState(questions: [])) {
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final questions = await quizService.fetchQuestions();
      state = state.copyWith(questions: questions);
      fetchAnswers();
    } catch (e) {
      // Handle error
    }
  }

  void fetchAnswers() {
    if (state.questions.isNotEmpty) {
      final currentQuestion = state.questions[state.currentIndex];
      final answers = [
        ...currentQuestion.inCorrectAnswer,
        currentQuestion.correctAnswer,
      ];

      answers.shuffle(Random(DateTime.now().millisecondsSinceEpoch));

      state = state.copyWith(
        shuffledAnswers: answers,
      );
    }
  }

  void nextQuestion() {
    if (state.currentIndex + 1 < state.questions.length) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      fetchAnswers();
    } else {
      state = state.copyWith(quizFinished: true);
    }
  }

  void answerQuestion(String userAnswer) {
    if (userAnswer == state.questions[state.currentIndex].correctAnswer) {
      state = state.copyWith(score: state.score + 1);
    }
    nextQuestion();
  }

  void resetQuiz() {
    state = QuizState(questions: []);
    fetchQuestions();
  }
}
