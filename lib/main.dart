import 'package:flutter/material.dart';

import 'package:rebuilder/rebuilder.dart';

import 'src/homepage.dart';
import 'src/datamodels/app_data.dart';
import 'src/models/settings.dart';
import 'src/models/theme.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new BannerScreen(),
      routes: <String, WidgetBuilder>{
        '/trivia': (BuildContext context) => new App(),
      },
    );
  }
}

class BannerScreen extends StatefulWidget {
  @override
  BannerScreenState createState() => new BannerScreenState();
}

class BannerScreenState extends State<BannerScreen>
    with AfterLayoutMixin<BannerScreen> {
  void openApp(BuildContext context) {
    var duration = const Duration(seconds: 5);
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
  Widget build(BuildContext context) {
    // return new Scaffold(body: new Container(color: Colors.red));
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
              fit: BoxFit.cover
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  final appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: appModel.settingsModel.loadTheme(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : DataModelProvider<AppModel>(
                  dataModel: appModel,
                  child: MaterialPage(),
                );
        });
  }
}

class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return Rebuilder<Settings>(
        dataModel: appModel.settingsModel.settings,
        rebuilderState: appModel.states.materialPage,
        builder: (state, data) {
          // To rebuild the widget tree, use the materialState
          return MaterialApp(
              title: 'Trivia example',
              theme: themes[data.currentTheme],
              home: HomePage());
        });
  }
}
