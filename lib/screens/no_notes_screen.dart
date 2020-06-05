import 'package:flutter/material.dart';

import 'package:keep_notes_clone/utils/styles.dart';

class NoNotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/icons/keep-logo.png',
            height: 100,
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Notes you add appear here',
            style: cardSmallTextStyle,
          ),
        ],
      ),
    );
  }
}
