import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/Riverpod_pratice_quiz/models/quiz_state.dart';
import 'package:quiz_marcus_ng/Riverpod_pratice_quiz/services/service.dart';

class QuizController extends StateNotifier<QuizState> {
  Service quizservice;
  QuizController(this.quizservice) : super(QuizState(questions: [])) {
    fetchquestion();
  }
  Future<void> fetchquestion() async {
    try {
      final questions = await quizservice.getQuestions();
      state = QuizState(questions: questions);
    } catch (e) {
      state = QuizState(
          questions: [],
          errorMessage: 'FAILED TO LOAD QUESTION"${e.toString()}');
    }
  }

  nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = QuizState(
        questions: state.questions,
        score: state.score,
        currentIndex: state.currentIndex + 1,
        quizFinished: false,
      );
    } else {
      state = QuizState(
        questions: state.questions,
        score: state.score,
        currentIndex: state.currentIndex,
        quizFinished: true,
      );
    }
  }

  setAnswer(String userAnswer) {
    if (state.questions[state.currentIndex].correctAnswer == userAnswer) {
      state = QuizState(
        questions: state.questions,
        score: state.score + 1,
        currentIndex: state.currentIndex + 1,
      );
    } else {
      nextQuestion();
    }
  }

  restart() {
    state = QuizState(
      questions: state.questions,
    );
  }
}

final quizControllerProvider =
    StateNotifierProvider<QuizController, QuizState>((ref) {
  return QuizController(ref.read(serviceProvider));
});
