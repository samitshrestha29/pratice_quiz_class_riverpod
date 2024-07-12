import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/quiz_controller.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizControllerProvider);

    if (quizState.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (quizState.quizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Complete'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your score: ${quizState.score}'),
              ElevatedButton(
                onPressed: () {
                  ref.read(quizControllerProvider.notifier).resetQuiz();
                },
                child: const Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = quizState.currentQuestion();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(currentQuestion.question,
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 20.0),
            ...currentQuestion.allAnswers().map(
                  (answer) => ElevatedButton(
                    onPressed: () {
                      ref
                          .read(quizControllerProvider.notifier)
                          .answerQuestion(answer);
                    },
                    child: Text(answer),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
