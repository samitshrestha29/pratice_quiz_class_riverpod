import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/quiz_controller.dart';

class QuizPageCopyWithRiverpod extends ConsumerWidget {
  const QuizPageCopyWithRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(quizState.quizFinished ? 'Quiz Complete' : 'Quiz'),
      ),
      body: quizState.questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : quizState.quizFinished
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Quiz completed, your score is ${quizState.score}'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(quizControllerProvider.notifier).resetQuiz();
                        },
                        child: const Text('Restart Quiz'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        quizState.questions[quizState.currentIndex].question,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 20.0),
                      ...quizState.shuffledAnswers
                          .map((answer) => ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(quizControllerProvider.notifier)
                                      .answerQuestion(answer);
                                },
                                child: Text(answer),
                              )),
                    ],
                  ),
                ),
    );
  }
}
