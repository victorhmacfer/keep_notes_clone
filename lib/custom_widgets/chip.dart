import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/reminder_setup_dialog.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/screens/note_labeling_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';
import 'package:provider/provider.dart';

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
  final bool deleted;

  NoteSetupLabelChip({@required this.label, this.deleted = false});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    return GestureDetector(
      onTap: () {
        notifier.titleFocusNode.unfocus();
        notifier.textFocusNode.unfocus();
        notifier.closeRightBottomSheet();
        notifier.closeLeftBottomSheet();

        if (!deleted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<NoteSetupScreenController>.value(
                        value: notifier,
                        child: NoteLabelingScreen(),
                      )));
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Can't edit in Trash")));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: _noteSetupChipDecoration,
        child: Text(
          label.name,
          style: drawerItemStyle.copyWith(fontSize: 13),
        ),
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
    final notifier = Provider.of<NoteSetupScreenController>(context);

    Color textColor = (reminderExpired) ? appGreyForColoredBg : appBlack;
    Color alarmIconColor = (reminderExpired) ? appGreyForColoredBg : appBlack;

    TextDecoration textDecoration =
        (reminderExpired) ? TextDecoration.lineThrough : TextDecoration.none;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>
              ChangeNotifierProvider<NoteSetupScreenController>.value(
                  value: notifier),
          child: ReminderSetupDialog(),
        );
      },
      child: Container(
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
