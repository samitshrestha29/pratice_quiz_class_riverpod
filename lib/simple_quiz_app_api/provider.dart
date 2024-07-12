// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// final quizProvider =
//     StateNotifierProvider<QuizNotifier, QuizState>((ref) => QuizNotifier());

// class QuizNotifier extends StateNotifier<QuizState> {
//   QuizNotifier() : super(QuizState()) {
//     fetchQuestions();
//   }

//   Future<void> fetchQuestions() async {
//     final response = await http.get(Uri.parse(
//         'https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       state.questions = data['results'];
//       state = QuizState(
//         questions: state.questions,
//         currentQuestionIndex: state.currentQuestionIndex,
//         score: state.score,
//         isCompleted: state.isCompleted,
//       );
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   }

//   void checkAnswer(String selectedAnswer) {
//     if (selectedAnswer ==
//         state.questions[state.currentQuestionIndex]['correct_answer']) {
//       state.score += 1;
//     }
//     state.currentQuestionIndex += 1;

//     if (state.currentQuestionIndex >= state.questions.length) {
//       state.isCompleted = true;
//     }
//     state = QuizState(
//       questions: state.questions,
//       currentQuestionIndex: state.currentQuestionIndex,
//       score: state.score,
//       isCompleted: state.isCompleted,
//     );
//   }

//   void restartQuiz() {
//     state = QuizState();
//     fetchQuestions();
//   }
// }

// class QuizState {
//   List questions;
//   int currentQuestionIndex;
//   int score;
//   bool isCompleted;

//   QuizState({
//     this.questions = const [],
//     this.currentQuestionIndex = 0,
//     this.score = 0,
//     this.isCompleted = false,
//   });
// }

// class QuizPage extends ConsumerWidget {
//   const QuizPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final quizState = ref.watch(quizProvider);

//     if (quizState.questions.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Quiz App'),
//         ),
//         body: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (quizState.isCompleted) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Quiz App'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Quiz Completed! Your score is ${quizState.score}.'),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => ref.read(quizProvider.notifier).restartQuiz(),
//                 child: const Text('Restart'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
//     final options = [
//       ...currentQuestion['incorrect_answers'],
//       currentQuestion['correct_answer']
//     ];
//     options.shuffle();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quiz App'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               currentQuestion['question'],
//               style: const TextStyle(fontSize: 18.0),
//             ),
//             const SizedBox(height: 20.0),
//             ...options.map((option) => ElevatedButton(
//                   onPressed: () =>
//                       ref.read(quizProvider.notifier).checkAnswer(option),
//                   child: Text(option),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
