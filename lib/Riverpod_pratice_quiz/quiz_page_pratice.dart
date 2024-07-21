import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_marcus_ng/Riverpod_pratice_quiz/controller.dart';

class QuizPageForPratice extends ConsumerWidget {
  const QuizPageForPratice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizstate = ref.watch(quizControllerProvider);
    final quizcontroller = ref.read(quizControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: quizstate.questions.isNotEmpty
          ? quizstate.quizFinished
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ' Quiz completed the score is ${quizstate.score}/${quizstate.questions.length}'),
                      ElevatedButton(
                          onPressed: () {
                            quizcontroller.restart();
                          },
                          child: const Text('Restart'))
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          quizstate.questions[quizstate.currentIndex].question),
                      ...quizstate.questions[quizstate.currentIndex]
                          .allAnswer()
                          .map((e) => ElevatedButton(
                                onPressed: () {
                                  quizcontroller.setAnswer(e);
                                },
                                child: Text(e),
                              ))
                    ],
                  ),
                )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          quizcontroller.nextQuestion();
        },
        child: const Text('Next'),
      ),
    );
  }
}
