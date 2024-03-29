import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rebuilder/rebuilder.dart';
import 'package:quiz_app/src/models/models.dart';
import 'package:after_layout/after_layout.dart';

import 'src/datamodels/app_data.dart';
import 'src/homepage.dart';
import 'src/models/settings.dart';
import 'src/models/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      home: BannerScreen(),
      routes: <String, WidgetBuilder>{
        '/trivia': (BuildContext context) => App(),
      },
    );
}

class BannerScreen extends StatefulWidget {
  @override
  BannerScreenState createState() => BannerScreenState();
}

class BannerScreenState extends State<BannerScreen>
    with AfterLayoutMixin<BannerScreen> {
  void openApp(BuildContext context) {
    const duration = Duration(seconds: 2);
    Timer(duration, () => getRoute(context));
  }

  void getRoute(BuildContext context) {
    Navigator.of(context).pushNamed('/trivia');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    openApp(context);
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
            fit: BoxFit.cover),
      ),
    );
}

class App extends StatelessWidget {
  final appModel = AppModel();

  BuildContext _context;
  Future<bool> _onWillPop() {
    print(appModel.tab.value);
    if (appModel.tab.value != AppTab.main) {
      appModel.tab.value = AppTab.main;
    } else {
      print('uygulamadan çık');
      showDialog<bool>(
        context: _context,
        builder: (c) => AlertDialog(
          title: const Text('Dikkat'),
          content: const Text('Çıkmak istiyor musunuz?'),
          actions: [
            FlatButton(
              child: const Text('Evet'),
              onPressed: () => exit(0),
            ),
            FlatButton(
              child: const Text('Hayır'),
              onPressed: () => Navigator.pop(_context, false),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return FutureBuilder<bool>(
        future: appModel.settingsModel.loadTheme(),
        builder: (context, snapshot) => !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : DataModelProvider<AppModel>(
                  dataModel: appModel,
                  child: WillPopScope(
                    onWillPop: _onWillPop,
                    child: MaterialPage(),
                  ),
                ));
  }
}

class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return Rebuilder<Settings>(
        dataModel: appModel.settingsModel.settings,
        rebuilderState: appModel.states.materialPage,
        builder: (state, data) => MaterialApp(
              title: 'Areda Quiz',
              theme: themes[data.currentTheme],
              home: HomePage()));
  }
}
