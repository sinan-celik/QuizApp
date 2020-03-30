import 'package:quiz_app/src/models/answer.dart';

enum QuestionDifficulty { easy, medium, hard }

enum QuestionType { boolean, multiple }

class QuestionModel {
  QuestionModel(
      {this.questionImage,
      this.question,
      this.correctAnswer,
      this.incorrectAnswers,
      this.answerType});

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        questionImage: json['questionImage'],
        question: json['question'],
        answerType: json['answerType'],
        correctAnswer : Answer.fromAnswerModel(AnswerModel.fromJson(json['correct_answer'])),
            // .map((ans) => Answer.fromAnswerModel(AnswerModel.fromJson(ans))),
        incorrectAnswers: (json['incorrect_answers'] as List)
            // .map((answer) => answer.toString())
            .map((answer) =>
                Answer.fromAnswerModel(AnswerModel.fromJson(answer)))
            .toList());

  String questionImage;
  String question;
  Answer correctAnswer;
  List<Answer> incorrectAnswers;
  String answerType;
}

class Question {
  Question(
      {this.questionImage,
      this.question,
      this.answers,
      this.answerType,
      this.correctAnswerIndex});
  factory Question.fromQuestionModel(QuestionModel model) {
    final List<Answer> answers = []
      ..add(model.correctAnswer)
      ..addAll(model.incorrectAnswers)
      ..shuffle();

    final index = answers.indexOf(model.correctAnswer);

    return Question(
        questionImage: model.questionImage,
        question: model.question,
        answerType: model.answerType,
        answers: answers,
        correctAnswerIndex: index);
  }

// bytes:  base64.decode(''),
  String questionImage;
  String question;
  List<Answer> answers;
  String answerType;
  int correctAnswerIndex;
  int chosenAnswerIndex;

  bool isCorrect(Answer answer) => answers.indexOf(answer) == correctAnswerIndex;

  bool isChosen(Answer answer) => answers.indexOf(answer) == chosenAnswerIndex;
}
