import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/models/quiz.state.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/services/service.dart';

final quizControllerProvider = StateNotifierProvider<QuizController, QuizState>(
  (ref) => QuizController(ref.read(quizServiceProvider)),
);

class QuizController extends StateNotifier<QuizState> {
  final QuizService quizService;

  QuizController(this.quizService) : super(QuizState(questions: [])) {
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final questions = await quizService.fetchQuestions();
      state = QuizState(questions: questions);
    } catch (e) {
      // Handle error
    }
  }

  void answerQuestion(String answer) {
    if (state.quizFinished) return;

    final isCorrect =
        state.questions[state.currentQuestionIndex].correctAnswer == answer;
    final newScore = isCorrect ? state.score + 1 : state.score;

    final isFinished = state.currentQuestionIndex + 1 >= state.questions.length;

    state = QuizState(
      questions: state.questions,
      currentQuestionIndex: state.currentQuestionIndex + 1,
      score: newScore,
      quizFinished: isFinished,
    );
  }

  void resetQuiz() {
    state = QuizState(questions: state.questions);
  }
}
