import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/models/quiz_state.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/services/service.dart';

class QuizController extends StateNotifier<QuizState> {
//   Quiz Game Manager:
// The QuizController is like a manager or teacher who runs the quiz game,
// keeps track of questions, scores, and more.
// Quiz State:
// The QuizState is like a special notebook or board where all the current details
// of the quiz game are written down. It includes:
// The list of quiz questions.
// The current question being asked.
// The player's current score.
// Any other important information about the game.
  final QuizService quizService;

  // Constructor initializes the state and fetches questions
// The QuizService instance (quizService) in the QuizController class holds the logic to fetch
//quiz questions from an external source, such as an API. This instance is used to call the method
//fetchQuestions which retrieves the quiz questions and provides them to the QuizController.
  QuizController(this.quizService) : super(QuizState(questions: [])) {
    fetchQuestions();
  }
// When we create a QuizController, we want it to start with a
//blank quiz (no questions). The super(QuizState(questions: [])) part does this.
// Let's break it down step by step:
// QuizController is like a special box that manages the quiz state.
// StateNotifier<QuizState> is a special kind of box that keeps track of
//changes and notifies others when things change.
// When we create a new QuizController, we call its constructor.
// super(QuizState(questions: [])) tells the parent box (StateNotifier) to start
//with an empty quiz (no questions).
// Example
// super(QuizState(questions: [])) means: "Start with an empty list of questions."
// So, when we create a new QuizController, it starts with no questions and then goes
// to fetch questions to fill it up.
// In very simple terms: It means "start with an empty quiz."
  Future<void> fetchQuestions() async {
    try {
      final question = await quizService.fetchQuestions();
      //  The fetchQuestions method in the QuizController returns
      // void instead of Future<List<Question>> because its primary purpose
      //is to update the state of the QuizController with the fetched questions,
      //rather than returning the questions themselves.
      state = QuizState(questions: question);
    } catch (e) {
      state = QuizState(
        questions: [],
        errorMessage: 'Failed to load questions: ${e.toString()}',
      );
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

  void nextQuestion() {
    final isFinished = state.currentQuestionIndex + 1 >= state.questions.length;

    state = QuizState(
      questions: state.questions,
      currentQuestionIndex: state.currentQuestionIndex + 1,
      score: state.score,
      quizFinished: isFinished,
    );
  }

  void resetQuiz() {
    state = QuizState(questions: state.questions);
  }
}

final quizControllerProvider = StateNotifierProvider<QuizController, QuizState>(
  (ref) => QuizController(ref.read(quizServiceProvider)),
);

// StateNotifierProvider:
// Think of a magical question box that can give you a new question (QuizController) whenever you need one.
// The Magic of StateNotifierProvider
// Magic Question Box:
// When you open the magical question box, it gives you a new question (QuizController) ready to be used in your quiz game.
// Simplified Explanation
// StateNotifierProvider is like a magical question box.
// It gives you a new question (QuizController) whenever you need one.
// The question knows how to fetch more questions and manage the quiz game.

// (ref) { return QuizController(ref.read(quizServiceProvider)); }:

// This part tells the magical question box how to create our question manager.
// ref: A helper that helps us get the tools we need.
// ref.read(quizServiceProvider): This asks the helper to give us the tool that
// fetches quiz questions from the internet.
// return QuizController(ref.read(quizServiceProvider)): This creates a new question
// manager (QuizController) and gives them the tool to fetch questions.
