import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/question_model.dart';

class QuizService {
  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final questionText =
          (data['results'] as List).map((e) => Question.fromJson(e)).toList();
      return questionText;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

final quizServiceProvider = Provider((ref) => QuizService());
