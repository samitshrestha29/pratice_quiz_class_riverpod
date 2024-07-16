import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/models/quiz.state.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/services/service.dart';

class QuizController extends StateNotifier<QuizState> {
  final QuizService quizService;

  QuizController(this.quizService)
      : super(QuizState(
          questions: [],
        )) {
    fetchQuestion();
  }

  Future<void> fetchQuestion() async {
    try {
      final questions = await quizService.fetchQuestions();
      state = QuizState(questions: questions, score: state.score);
    } catch (e) {
      state = QuizState(
        questions: [],
        errorMessage: 'Failed to load questions: ${e.toString()}',
      );
    }
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = QuizState(
        questions: state.questions,
        currentQuestionIndex: state.currentQuestionIndex + 1,
        score: state.score,
      );
    } else {
      state = QuizState(
        questions: state.questions,
        currentQuestionIndex: state.currentQuestionIndex,
        quizFinished: true,
        score: state.score,
      );
    }
  }

  void setAnswer(String userAnswer) {
    if (state.questions[state.currentQuestionIndex].correctAnswer ==
        userAnswer) {
      state = QuizState(
        questions: state.questions,
        currentQuestionIndex: state.currentQuestionIndex + 1,
        score: state.score + 1,
      );
    }
    nextQuestion();
  }

  restart() {
    state = QuizState(
        questions: state.questions,
        score: 0,
        quizFinished: false,
        currentQuestionIndex: 0);
  }
}

final quizcontrollerProvider =
    StateNotifierProvider<QuizController, QuizState>((ref) {
  return QuizController(ref.read(quizServiceProvider));
});
