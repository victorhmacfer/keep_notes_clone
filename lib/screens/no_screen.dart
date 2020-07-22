import 'package:flutter/material.dart';
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
      icon: Icons.search, 
      message: 'No matching notes'
    );
  }
}

class _NoScreenWithMaterialIcon extends StatelessWidget {
  final IconData icon;
  final String message;

  _NoScreenWithMaterialIcon({@required this.icon, @required this.message});

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
            icon,
            color: NoteColor.orange.getColor(),
            size: 120,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            message,
            style: noNotesMessageTextStyle,
          ),
        ],
      ),
    );
  }
}

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
            style: noNotesMessageTextStyle,
          ),
        ],
      ),
    );
  }
}
