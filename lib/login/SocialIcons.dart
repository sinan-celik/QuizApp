import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({this.iconData});
  final IconData iconData;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(),
        child: Container(
          width: 40.0,
          height: 40.0,
          child: RawMaterialButton(
            onPressed: null,
            shape: const CircleBorder(),
            child: Icon(iconData, color: Colors.white),
          ),
        ),
      );
}
