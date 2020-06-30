import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

var _noteSetupChipDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  border: Border.all(color: appGreyForColoredBg, width: 1),
);

var _expiredReminderChipDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1), width: 1),
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
  final bool reminderExpired;

  NoteSetupReminderChip(this.reminderTime, this.reminderExpired);

  @override
  Widget build(BuildContext context) {
    Color textColor = (reminderExpired) ? appGreyForColoredBg : appBlack;
    Color alarmIconColor = (reminderExpired) ? appGreyForColoredBg : appBlack;

    TextDecoration textDecoration =
        (reminderExpired) ? TextDecoration.lineThrough : TextDecoration.none;

    return Container(
      padding: EdgeInsets.fromLTRB(8, 6, 14, 6),
      decoration: (reminderExpired)
          ? _expiredReminderChipDecoration
          : _noteSetupChipDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.alarm,
            size: 18,
            color: alarmIconColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            chipReminderText(reminderTime),
            style: drawerItemStyle.copyWith(
                fontSize: 12, color: textColor, decoration: textDecoration),
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
    //FIXME: this should not be computed by Ui
    final reminderExpired = reminderTime.isBefore(DateTime.now());

    Color textColor = (reminderExpired) ? appGreyForColoredBg : appBlack;

    Color alarmIconColor = (reminderExpired) ? appGreyForColoredBg : appBlack;

    TextDecoration textDecoration =
        (reminderExpired) ? TextDecoration.lineThrough : TextDecoration.none;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: (reminderExpired)
          ? _expiredReminderChipDecoration
          : _noteSetupChipDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.alarm,
            size: 15,
            color: alarmIconColor,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            chipReminderText(reminderTime),
            style: drawerItemStyle.copyWith(
                fontSize: 12, color: textColor, decoration: textDecoration),
          ),
        ],
      ),
    );
  }
}
