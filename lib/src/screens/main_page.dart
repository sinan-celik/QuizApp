import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import 'package:rebuilder/rebuilder.dart';

import '../datamodels/app_data.dart';
import '../models/category.dart';
import '../models/models.dart';
import '../models/settings.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);
    print('MAINPAGE REBUILDING');

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
          SizedBox(
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
                SizedBox(
                  height: 200,
                ),
                SizedBox(
                  width: 300,
                  child: const Text(
                    'Sizi tanıyabilmemiz ve uygulamanın ayrıcalıklarından yararlanabilmeniz için lütfen bağlanın:',
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: const Text(
                            'Bağlan',
                          ),
                        ),
                        onTap: () => appModel.tab.value = AppTab.login,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
