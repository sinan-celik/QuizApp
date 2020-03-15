// enum AnswerType { boolean, multiple }

class AnswerModel {
  AnswerModel(
      {this.id,
      this.projectCode,
      this.questionId,
      this.answerText,
      this.isTrue,
      this.answerImage});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
        id: json['id'],
        projectCode: json['projectCode'],
        questionId: json['questionId'],
        answerText: json['answerText'],
        isTrue: json['isTrue'],
        answerImage: json['answerImage']
        // incorrectAnswers: (json['incorrect_answers'] as List)
        // .map((answer) => answer.toString())
        // .toList()
        );
  }

  int id;
  String projectCode;
  int questionId;
  String answerText;
  bool isTrue;
  String answerImage;
}

class Answer {
  Answer(
      {this.id,
      this.projectCode,
      this.questionId,
      this.answerText,
      this.isTrue,
      this.answerImage});
  factory Answer.fromAnswerModel(AnswerModel model) {
    return Answer(
        id: model.id,
        projectCode: model.projectCode,
        questionId: model.questionId,
        answerText: model.answerText,
        isTrue: model.isTrue,
        answerImage: model.answerImage);
  }

  int id;
  String projectCode;
  int questionId;
  String answerText;
  bool isTrue;
  String answerImage;
}
