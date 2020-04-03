import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frideos/frideos.dart';
import 'package:rebuilder/rebuilder.dart';

import '../datamodels/app_data.dart';
import '../models/models.dart';

class MainPageSF extends StatefulWidget {
  @override
  MainPage createState() => MainPage();
}

class MainPage extends State<MainPageSF> {
  final storage = FlutterSecureStorage();
  bool isconnected = true;
  String email;
  bool refreshed = false;

  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    print('MAINPAGE REBUILDING');

    storage.read(key: 'email').then((onValue) {
      if (onValue == null && refreshed == false) {
        refreshed = true;
        setState(() {
          isconnected = false;
        });
      }

      if (onValue != null && refreshed == false) {
        refreshed = true;

        setState(() {
          email = onValue;
        });
      }

      isconnected = email == null ? false : true;
    });

    return FadeInWidget(
      duration: 750,
      // child: Container(
      //   alignment: Alignment.center,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[

      //     ],
      //   ),
      // ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          const SizedBox(
            height: 200,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 72,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue,
                            blurRadius: 2.0,
                            spreadRadius: 2.5),
                      ],
                    ),
                    child: const Text(
                      'Oynamaya Başla',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  onTap: () => appModel.tab.value = AppTab.trivia,
                ),
                const SizedBox(
                  height: 200,
                ),
                Container(
                  child: isconnected
                      ? showSingOut(email, appModel)
                      : showSignUpSignIn(appModel),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showSignUpSignIn(appModel) => Column(
        children: <Widget>[
          const SizedBox(
            width: 300,
            child: Text(
              'Sizi tanıyabilmemiz ve uygulamanın ayrıcalıklarından yararlanabilmeniz için lütfen bağlanın:',
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Text(
                        'Bağlan',
                      ),
                    ),
                    onTap: () => {
                          appModel.tab.value = AppTab.login,
                        }),
              ],
            ),
          )
        ],
      );

  Widget showSingOut(String email, AppModel appModel) => Column(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: Text(
              '$email olarak bağlı. Çıkış yapmak için:',
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Text(
                        'Çıkış yap!',
                      ),
                    ),
                    onTap: () => {
                          storage.deleteAll(),
                          setState(() {
                            isconnected = false;
                          })
                        }),
              ],
            ),
          )
        ],
      );
}
