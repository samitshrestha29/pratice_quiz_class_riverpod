import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class QuizService {
  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        "https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((e) => Question.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
