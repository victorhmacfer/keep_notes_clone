import 'package:flutter/material.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class NoLabelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NoScreenWithMaterialIcon(
      icon: Icons.label_outline,
      message: 'No notes with this label yet',
    );
  }
}

class NoRemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NoScreenWithMaterialIcon(
        icon: Icons.notifications_none,
        message: 'Notes with upcoming reminders appear here');
  }
}

class NoSearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NoScreenWithMaterialIcon(
        icon: Icons.search, message: 'No matching notes');
  }
}

class _NoScreenWithMaterialIcon extends StatelessWidget {
  final IconData icon;
  final String message;

  _NoScreenWithMaterialIcon({@required this.icon, @required this.message});

  @override
  Widget build(BuildContext context) {
    var screenHeight = mqScreenSize.height;
    var screenWidth = mqScreenSize.width;

    return Container(
      height: screenHeight * 0.82,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: NoteColor.orange.getColor(),
            size: screenWidth * 0.292,
          ),
          SizedBox(
            height: screenWidth * 0.039,
          ),
          Text(
            message,
            style: noNotesMessageTextStyle(screenWidth),
          ),
        ],
      ),
    );
  }
}

class NoNotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = mqScreenSize.height;
    var screenWidth = mqScreenSize.width;

    return Container(
      height: screenHeight * 0.8,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/icons/keep-logo.png',
            height: screenWidth * 0.243,
          ),
          SizedBox(
            height: screenWidth * 0.058,
          ),
          Text(
            'Notes you add appear here',
            style: noNotesMessageTextStyle(screenWidth),
          ),
        ],
      ),
    );
  }
}
