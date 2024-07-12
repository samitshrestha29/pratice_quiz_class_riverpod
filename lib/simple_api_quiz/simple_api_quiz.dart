import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SimpleApiQuiz extends StatefulWidget {
  const SimpleApiQuiz({super.key});

  @override
  State<SimpleApiQuiz> createState() => _SimplePracticeApiQuizState();
}

class _SimplePracticeApiQuizState extends State<SimpleApiQuiz> {
  List _questions = [];
  int questionIndex = 0;
  int score = 0;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _questions = data['results'];
        _shuffleOptions();
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _shuffleOptions() {
    if (_questions.isNotEmpty) {
      List<String> incorrectAnswers =
          List<String>.from(_questions[questionIndex]['incorrect_answers']);
      String correctAnswer = _questions[questionIndex]['correct_answer'];
      options = incorrectAnswers..add(correctAnswer);
      options.shuffle(Random());
    }
  }

  void nextQuestion() {
    setState(() {
      if (questionIndex < _questions.length - 1) {
        questionIndex++;
        _shuffleOptions();
      } else {
        _showFinalScore();
      }
    });
  }

  void showAnswer(String selectedAnswer) {
    if (_questions[questionIndex]['correct_answer'] == selectedAnswer) {
      setState(() {
        score++;
      });
    }
    nextQuestion();
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz Completed'),
        content:
            Text('Your final score is $score out of ${_questions.length}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                questionIndex = 0;
                score = 0;
                _shuffleOptions();
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: _questions.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _questions[questionIndex]['question'],
                      style: const TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...options.map((option) => ElevatedButton(
                        onPressed: () {
                          showAnswer(option);
                        },
                        child: Text(option),
                      )),
                ],
              ),
            ),
    );
  }
}



// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class SimplePracticeApiQuiz extends StatefulWidget {
//   const SimplePracticeApiQuiz({super.key});

//   @override
//   State<SimplePracticeApiQuiz> createState() => _SimplePracticeApiQuizState();
// }

// class _SimplePracticeApiQuizState extends State<SimplePracticeApiQuiz> {
//   List _questions = [];
//   int questionIndex = 0;
//   int score = 0;
//   List<String> options = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }

//   Future<void> _fetchQuestions() async {
//     final response = await http.get(Uri.parse(
//         'https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         _questions = data['results'];
//         _shuffleOptions();
//       });
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   }

//   void _shuffleOptions() {
//     if (_questions.isNotEmpty) {
//       List<String> incorrectAnswers = List<String>.from(_questions[questionIndex]['incorrect_answers']);
//       String correctAnswer = _questions[questionIndex]['correct_answer'];
//       options = incorrectAnswers..add(correctAnswer);
//       options.shuffle(Random());
//     }
//   }

//   void nextQuestion() {
//     setState(() {
//       questionIndex++;
//       if (questionIndex < _questions.length) {
//         _shuffleOptions();
//       }
//     });
//   }

//   void showAnswer(String selectedAnswer) {
//     if (_questions[questionIndex]['correct_answer'] == selectedAnswer) {
//       setState(() {
//         score++;
//       });
//     }
//     nextQuestion();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quiz App'),
//       ),
//       body: _questions.isEmpty
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Center(
//               child: questionIndex < _questions.length
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             _questions[questionIndex]['question'],
//                             style: const TextStyle(fontSize: 18.0),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         ...options.map((option) => ElevatedButton(
//                               onPressed: () {
//                                 showAnswer(option);
//                               },
//                               child: Text(option),
//                             )),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Quiz Completed!',
//                           style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Your final score is $score out of ${_questions.length}.',
//                           style: const TextStyle(fontSize: 18.0),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               questionIndex = 0;
//                               score = 0;
//                               _shuffleOptions();
//                             });
//                           },
//                           child: const Text('Restart Quiz'),
//                         ),
//                       ],
//                     ),
//             ),
//     );
//   }
// }


