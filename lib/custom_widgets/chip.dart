import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

var _noteSetupChipDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  border: Border.all(color: appGreyForColoredBg, width: 1),
);

class NoteSetupLabelChip extends StatelessWidget {
  final Label label;

  NoteSetupLabelChip({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: _noteSetupChipDecoration,
      child: Text(
        label.name,
        style: drawerItemStyle.copyWith(fontSize: 13),
      ),
    );
  }
}

class NoteCardLabelChip extends StatelessWidget {
  final String labelText;

  NoteCardLabelChip(this.labelText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appGreyForColoredBg, width: 1),
      ),
      child: Text(
        labelText,
        style: drawerItemStyle.copyWith(fontSize: 12),
      ),
    );
  }
}

class NoteSetupReminderChip extends StatelessWidget {
  final DateTime reminderTime;

  NoteSetupReminderChip(this.reminderTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 6, 14, 6),
      decoration: _noteSetupChipDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.alarm,
            size: 18,
            color: appBlack,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            chipReminderText(reminderTime),
            style: drawerItemStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class NoteCardReminderChip extends StatelessWidget {
  final DateTime reminderTime;

  NoteCardReminderChip(this.reminderTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appGreyForColoredBg, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.alarm,
            size: 15,
            color: appBlack,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            chipReminderText(reminderTime),
            style: drawerItemStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
