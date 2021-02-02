import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_labeling_bloc.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/reminder_setup_dialog.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/reminder.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/screens/note_labeling_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/main.dart';

BoxDecoration _noteSetupChipDecoration(double mediaQueryScreenWidth) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(mediaQueryScreenWidth * 0.078),
      border: Border.all(color: appGreyForColoredBg, width: 1),
    );

BoxDecoration _expiredReminderChipDecoration(double mediaQueryScreenWidth) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(mqScreenSize.width * 0.078),
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
                  builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider<
                              NoteSetupScreenController>.value(value: notifier),
                          Provider<NoteLabelingBloc>(
                            create: (context) => NoteLabelingBloc(repo),
                          ),
                        ],
                        child: NoteLabelingScreen(),
                      )));
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Can't edit in Trash")));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: mqScreenSize.width * 0.017,
            horizontal: mqScreenSize.width * 0.034),
        decoration: _noteSetupChipDecoration(mqScreenSize.width),
        child: Text(
          label.name,
          style: drawerItemStyle.copyWith(fontSize: mqScreenSize.width * 0.032),
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
  final Reminder reminder;

  NoteSetupReminderChip(this.reminder);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<NoteSetupScreenController>(context);

    Color textColor = (reminder.expired) ? appGreyForColoredBg : appBlack;
    Color alarmIconColor = (reminder.expired) ? appGreyForColoredBg : appBlack;

    TextDecoration textDecoration =
        (reminder.expired) ? TextDecoration.lineThrough : TextDecoration.none;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<NoteSetupScreenController>.value(
                  value: notifier),
              Provider(create: (context) => NoteSetupBloc(repo)),
            ],
            child: ReminderSetupDialog(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
            mqScreenSize.width * 0.019, 6, mqScreenSize.width * 0.034, 6),
        decoration: (reminder.expired)
            ? _expiredReminderChipDecoration(mqScreenSize.width)
            : _noteSetupChipDecoration(mqScreenSize.width),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.alarm,
              size: mqScreenSize.width * 0.044,
              color: alarmIconColor,
            ),
            SizedBox(
              width: mqScreenSize.width * 0.019,
            ),
            Text(
              chipReminderText(reminder.time),
              style: drawerItemStyle.copyWith(
                  fontSize: mqScreenSize.width * 0.029,
                  color: textColor,
                  decoration: textDecoration),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteCardReminderChip extends StatelessWidget {
  final Reminder reminder;

  NoteCardReminderChip(this.reminder);

  @override
  Widget build(BuildContext context) {
    Color textColor = (reminder.expired) ? appGreyForColoredBg : appBlack;

    Color alarmIconColor = (reminder.expired) ? appGreyForColoredBg : appBlack;

    TextDecoration textDecoration =
        (reminder.expired) ? TextDecoration.lineThrough : TextDecoration.none;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: (reminder.expired)
          ? _expiredReminderChipDecoration(mqScreenSize.width)
          : _noteSetupChipDecoration(mqScreenSize.width),
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
            chipReminderText(reminder.time),
            style: drawerItemStyle.copyWith(
                fontSize: 12, color: textColor, decoration: textDecoration),
          ),
        ],
      ),
    );
  }
}
