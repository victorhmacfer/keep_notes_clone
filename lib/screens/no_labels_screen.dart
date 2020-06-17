import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/utils/styles.dart';

class NoLabelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.82,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.label_outline,
            color: NoteColor.orange.getColor(),
            size: 120,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'No notes with this label yet',
            style: cardSmallTextStyle,
          ),
        ],
      ),
    );
  }
}
