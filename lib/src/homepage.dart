import 'package:flutter/material.dart';
import 'package:quiz_app/src/screens/about_page.dart';

import 'package:rebuilder/rebuilder.dart';
import 'package:quiz_app/login/login_page_widget.dart';

import 'datamodels/app_data.dart';
import 'models/models.dart';
import 'models/question.dart';
import 'screens/main_page.dart';
import 'screens/settings_page.dart';
import 'screens/summary_page.dart';
import 'screens/trivia_page.dart';

/// Styles
const textStyle = TextStyle(color: Colors.blue);
const iconColor = Colors.blueGrey;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('HOMEPAGE REBUILDING');
    final appModel = DataModelProvider.of<AppModel>(context);

    return Rebuilder<RebuilderObject>(
        dataModel: appModel.tab,
        rebuilderState: appModel.states.tab,
        builder: (state, data) => Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: data.value != AppTab.main ? null : AppBar(),
            drawer: DrawerWidget(),
            body: SwitchTabWidget(
              appModel: appModel,
            )));
  }
}

class SwitchTabWidget extends StatelessWidget {
  const SwitchTabWidget({Key key, this.appModel}) : super(key: key);

  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    switch (appModel.tab.value) {
      case AppTab.main:
        // Future categoriesFuture = appModel.repository.loadCategories();

        return Rebuilder(
          rebuilderState: appModel.states.mainPage,
          builder: (state, _) => FutureBuilder(
              // future: categoriesFuture,
              builder: (context, snapshot) => MainPageSF()),
        );
        break;
      case AppTab.trivia:
        final Future questionsFuture = appModel.repository.loadQuestions(
            numQuestions: appModel.settingsModel.settings.numQuestions,
            // category: appModel.settingsModel.settings.categoryChosen,
            // difficulty: appModel.settingsModel.settings.questionsDifficulty,
            type: QuestionType.multiple);

        return Rebuilder(
          rebuilderState: appModel.states.triviaPage,
          builder: (state, _) => FutureBuilder<List<Question>>(
              future: questionsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return TriviaPage(
                    appModel: appModel,
                    questions: snapshot.data,
                  );
                }
              }),
        );
        break;
      case AppTab.summary:
        return Rebuilder(
            rebuilderState: appModel.states.summaryPage,
            builder: (state, _) =>
                SummaryPage(triviaStats: appModel.triviaModel.triviaStats));
        break;
      case AppTab.settings:
        return Rebuilder(
            rebuilderState: appModel.states.settingsPage,
            builder: (state, _) => SettingsPage());
        break;
      case AppTab.login:
        return Rebuilder(
            rebuilderState: appModel.states.loginPage,
            builder: (state, _) => const LogInPage());
        break;
      case AppTab.about:
        return Rebuilder(
            rebuilderState: appModel.states.aboutPage,
            builder: (state, _) => AboutPage());
        break;

      default:
        return Container();
    }
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: const Center(
              child: Text(
                'AREDA',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 4.0,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.lightBlueAccent,
                      offset: Offset(3.0, 4.5),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              appModel.tab.value = AppTab.settings;
            },
          ),
          ListTile(
            title: const Text('Hakkında'),
            onTap: () {
              Navigator.pop(context);
              appModel.tab.value = AppTab.about;
            },
          ),
          const AboutListTile(
            child: Text('Made with Flutter'),
          ),
        ],
      ),
    );
  }
}
