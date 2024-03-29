import 'package:flutter/material.dart';
import '../models/question.dart';
import '../styles.dart';

class SummaryAnswers extends StatelessWidget {
  const SummaryAnswers({Key key, this.index, this.question}) : super(key: key);

  final int index;
  final Question question;

  List<Widget> _buildAnswers(Question question) {
    final widgets = List<Widget>()
      ..addAll(
        question.answers.map((answer) => Text(
            answer.answerText,
            style: question.isCorrect(answer)
                ? correctAnswerStyle
                : question.isChosen(answer) ? wrongAnswerStyle : notChosenStyle,
          )),
      );

    return widgets;
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: CircleAvatar(
                  backgroundColor: circleAvatarBackground,
                  radius: circleAvatarRadius,
                  child: Text(
                    '$index',
                    style: questionStyle,
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${question.question}',
                        style: questionStyle, textAlign: TextAlign.center),
                  )),
            ],
          ),
          Column(children: _buildAnswers(question)),
        ],
      ),
    );
}
