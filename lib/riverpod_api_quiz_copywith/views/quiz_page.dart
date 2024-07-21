import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/riverpod_api_quiz_copywith/controllers/quiz_controller.dart';

class QuizCopyWith extends ConsumerWidget {
  const QuizCopyWith({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizControllerProvider);
    final quizController = ref.read(quizControllerProvider.notifier);

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
                        quizController.restart();
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
                                quizController.setAnswer(e);
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
          quizController.nextQuestion();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
