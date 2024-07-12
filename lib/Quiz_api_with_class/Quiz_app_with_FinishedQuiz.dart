import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Question> questions = [];
  int currentIndex = 0;
  List<String> shuffleAnswer = [];
  int score = 0;
  bool quizFinished = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchQuestion();
  }

  Future<void> _fetchQuestion() async {
    final response = await http.get((Uri.parse(
        "https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple")));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        questions =
            (data['results'] as List).map((e) => Question.fromJson(e)).toList();
        _fetchAnswer();
      });
    }
  }

  _fetchAnswer() {
    List<String> answers = [
      ...questions[currentIndex].inCorrectAnswer,
      questions[currentIndex].correctAnswer
    ];
    shuffleAnswer = answers;
    shuffleAnswer.shuffle(Random());
  }

  nextQuestion() {
    setState(() {
      currentIndex++;
      if (currentIndex < questions.length) {
        _fetchAnswer();
      } else {
        quizFinished = true;
      }
    });
  }

  _setAnswer(String userAnswer) {
    setState(() {
      if (userAnswer == questions[currentIndex].correctAnswer) {
        score++;
      }
      nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: questions.isNotEmpty
            ? quizFinished
                ? Center(
                    child: Text('Quiz completed your score is $score'),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(questions[currentIndex].question),
                        ...shuffleAnswer.map((e) => ElevatedButton(
                            onPressed: () {
                              _setAnswer(e);
                            },
                            child: Text(e)))
                      ],
                    ),
                  )
            : const Center(child: CircularProgressIndicator()));
  }
}

class Question {
  final String correctAnswer;
  final List<String> inCorrectAnswer;
  final String question;
  Question(
      {required this.correctAnswer,
      required this.inCorrectAnswer,
      required this.question});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        correctAnswer: json['correct_answer'],
        inCorrectAnswer: List<String>.from(json['incorrect_answers']),
        question: json['question']);
  }
}
