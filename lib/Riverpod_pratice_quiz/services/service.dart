import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_marcus_ng/Riverpod_pratice_quiz/models/model.dart';

class Service {
  Future<List<Question>> getQuestions() async {
    final response = await http.get(Uri.parse(
        "https://opentdb.com/api.php?amount=10&category=9&difficulty=medium&type=multiple"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final questions =
          (data['results'] as List).map((e) => Question.fromJson(e)).toList();
      return questions;
    } else {
      throw Exception('Questions not found');
    }
  }
}

final serviceProvider = Provider((ref) {
  return Service();
});
