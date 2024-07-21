import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api__pratice/controllers/quiz_controller.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizControllerProvider);
    final quizcontroller = ref.read(quizControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: quizState.questions.isNotEmpty
          ? quizState.quizFinished
              ? Column(
                  children: [
                    Center(
                      child: Text(
                        '${quizState.score}',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        quizcontroller.resetQuiz();
                      },
                      child: const Text('Restart Quiz'),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quizState
                            .questions[quizState.currentQuestionIndex].question,
                      ),
                      ...quizState.questions[quizState.currentQuestionIndex]
                          .allAnswers()
                          .map(
                            (e) => ElevatedButton(
                              onPressed: () {
                                quizcontroller.answerQuestion(e);
                              },
                              child: Text(e),
                            ),
                          ),
                    ],
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          quizcontroller.nextQuestion();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
