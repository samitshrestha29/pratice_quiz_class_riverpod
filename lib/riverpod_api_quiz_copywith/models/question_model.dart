class Question {
  final String correctAnswer;
  final List<String> inCorrectAnswer;
  final String question;

  Question({
    required this.correctAnswer,
    required this.inCorrectAnswer,
    required this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      correctAnswer: json['correct_answer'],
      inCorrectAnswer: List<String>.from(json['incorrect_answers']),
      question: json['question'],
    );
  }
}
