class Question {
  String questionText;
  bool correctAnswer;
  Question(this.questionText, this.correctAnswer);
}

List<Question> getquestion() {
  return [
    Question('i am superman', false),
    Question('bird can fly', true),
    Question('dog can bark', true),
  ];
}
