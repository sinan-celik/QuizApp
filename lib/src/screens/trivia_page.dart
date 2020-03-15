import 'package:flutter/material.dart';

import 'package:rebuilder/rebuilder.dart';

import '../styles.dart';
import '../datamodels/app_data.dart';
import '../datamodels/trivia_data.dart';
import '../models/models.dart';
import '../models/question.dart';
import '../widgets/answers_widget.dart';
import '../widgets/photo_answer_widget.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/question_widget.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({@required this.appModel, @required this.questions});

  final AppModel appModel;
  final List<Question> questions;

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  @override
  void initState() {
    super.initState();
    widget.appModel.triviaModel.setupTrivia(widget.questions);
  }

  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return Rebuilder<TriviaModel>(
        dataModel: appModel.triviaModel,
        rebuilderState: appModel.states.triviaPage,
        builder: (state, data) {
          return data.currentQuestion == null
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 22),
                  child: TriviaMain(
                      triviaStatus: data.triviaStatus,
                      question: data.currentQuestion),
                );
        });
  }
}

class TriviaMain extends StatelessWidget {
  const TriviaMain({this.triviaStatus, this.question})
      : assert(question != null, 'TriviaMain');

  final TriviaStatus triviaStatus;
  final Question question;

  @override
  Widget build(BuildContext context) {
    final triviaModel = DataModelProvider.of<AppModel>(context).triviaModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: const Color(0xff283593),
            borderRadius: const BorderRadius.only(
                // topLeft: Radius.circular(10),
                // topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              // BoxShadow(color: Colors.blue, blurRadius: 3.0, spreadRadius: 1.5),
            ],
          ),
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Text(
              //         'SCORE: ${triviaModel.triviaStats.score}',
              //         style: scoreHeaderStyle,
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Doğru: ${triviaModel.triviaStats.corrects.length}',
                    style: questionsHeaderStyle,
                  ),
                  Text(
                    'Yanlış: ${triviaModel.triviaStats.wrongs.length}',
                    style: questionsHeaderStyle,
                  ),
                  Text(
                    'Cevapsız: ${triviaModel.triviaStats.noAnswered.length}',
                    style: questionsHeaderStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
        Container(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.all(2),
          child: QuestionWidget(
            triviaModel: triviaModel,
            question: question,
          ),
        ),
        Container(
          height: 1,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: question.answerType == "IMAGE"
                ? PhotoAnswersWidget(
                    triviaModel: triviaModel,
                    question: question,
                    answerAnimation: triviaModel.answersAnimation,
                    isTriviaEnd: triviaStatus.isTriviaEnd,
                  )
                : question.answerType == "TEXT"
                    ? AnswersWidget(
                        triviaModel: triviaModel,
                        question: question,
                        answerAnimation: triviaModel.answersAnimation,
                        isTriviaEnd: triviaStatus.isTriviaEnd,
                      )
                    : Container(),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              height: 24,
              padding: const EdgeInsets.all(22),
              child: Text(
                'Time left: ${((triviaModel.settings.countdown - triviaModel.currentTime) / 1000)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        Container(
          height: 18,
        ),
        CountdownWidget(
          width: MediaQuery.of(context).size.width,
          duration: triviaModel.settings.countdown,
          triviaStatus: triviaStatus,
        ),
      ],
    );
  }
}
