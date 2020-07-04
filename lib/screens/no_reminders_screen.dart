import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/utils/styles.dart';

class NoRemindersScreen extends StatelessWidget {
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
            Icons.notifications_none,
            color: NoteColor.orange.getColor(),
            size: 120,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Notes with upcoming reminders appear here',
            style: noNotesMessageTextStyle,
          ),
        ],
      ),
    );
  }
}