import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';
import 'package:provider/provider.dart';

class ReminderSetupDialog extends StatefulWidget {
  @override
  _ReminderSetupDialogState createState() => _ReminderSetupDialogState();
}

class _ReminderSetupDialogState extends State<ReminderSetupDialog> {
  bool chosenTimeIsPast = false;

  String translateReminderDay(DateTime dateTimeOfDay) {
    String zeroOrNothing = (dateTimeOfDay.day < 10) ? '0' : '';

    return '${monthNames[dateTimeOfDay.month]} $zeroOrNothing${dateTimeOfDay.day}';
  }

  String translateReminderTime(DateTime dateTime) {
    String hourZeroOrNothing = (dateTime.hour < 10) ? '0' : '';
    String minuteZeroOrNothing = (dateTime.minute < 10) ? '0' : '';

    return '$hourZeroOrNothing${dateTime.hour}:$minuteZeroOrNothing${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    final noteSetupBloc = Provider.of<NoteSetupBloc>(context);

    final notifier = Provider.of<NoteSetupScreenController>(context);

    String reminderDayText = translateReminderDay(notifier.changingReminder);
    String reminderTimeText = translateReminderTime(notifier.changingReminder);

    var twoYearsFromNow = DateTime.now().add(Duration(days: 366 * 2));

    var hasSavedReminder = notifier.savedReminder != null;

    String timeSettingFailureText =
        (chosenTimeIsPast) ? 'The time has passed' : '';

    Widget _deleteButton(bool hasSaved) {
      if (hasSaved) {
        return FlatButton(
          key: ValueKey('reminder_dialog_delete_button'),
          child: Text(
            'Delete',
            style: TextStyle(fontSize: mqScreenSize.width * 0.034),
          ),
          onPressed: () {
            notifier.removeSavedReminder();
            Navigator.pop(context);
          },
        );
      }

      return Container();
    }

    return Center(
        child: Material(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: screenWidth * 0.93,
        padding: EdgeInsets.fromLTRB(mqScreenSize.width * 0.039,
            mqScreenSize.width * 0.039, mqScreenSize.width * 0.039, 4),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Add reminder',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: mqScreenSize.width * 0.039),
              ),
              GestureDetector(
                onTap: () async {
                  var chosenDate = await showDatePicker(
                      context: context,
                      initialDate: notifier.changingReminder,
                      firstDate: DateTime.now().add(Duration(minutes: 1)),
                      lastDate: twoYearsFromNow);
                  if (chosenDate != null) {
                    notifier.reminderDate = chosenDate;

                    setState(() {
                      chosenTimeIsPast =
                          notifier.changingReminder.isBefore(DateTime.now());
                    });
                  }
                },
                child: Container(
                  color: appWhite,
                  padding: EdgeInsets.only(
                      top: mqScreenSize.width * 0.058, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        reminderDayText,
                        style: TextStyle(fontSize: mqScreenSize.width * 0.034),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: mqScreenSize.width * 0.058,
                      )
                    ],
                  ),
                ),
              ),
              _Divider(
                color: appDividerGrey,
              ),
              GestureDetector(
                onTap: () async {
                  var chosenTimeOfDay = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(notifier.changingReminder),
                  );
                  if (chosenTimeOfDay != null) {
                    int whateverYear = 9999;
                    int whateverMonth = 99;
                    int whateverDay = 99;

                    var inDateTime = DateTime(
                        whateverYear,
                        whateverMonth,
                        whateverDay,
                        chosenTimeOfDay.hour,
                        chosenTimeOfDay.minute);

                    notifier.reminderHourMinute = inDateTime;

                    setState(() {
                      chosenTimeIsPast =
                          notifier.changingReminder.isBefore(DateTime.now());
                    });
                  }
                },
                child: Container(
                  color: appWhite,
                  padding: EdgeInsets.only(
                      top: mqScreenSize.width * 0.058, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        reminderTimeText,
                        style: TextStyle(fontSize: mqScreenSize.width * 0.034),
                      ),
                      Icon(
                        Icons.schedule,
                        size: mqScreenSize.width * 0.058,
                      )
                    ],
                  ),
                ),
              ),
              _Divider(color: (chosenTimeIsPast) ? Colors.red : appDividerGrey),
              Container(
                  // color: Colors.brown,
                  alignment: Alignment.centerLeft,
                  height: mqScreenSize.width * 0.049,
                  child: Text(
                    timeSettingFailureText,
                    style: TextStyle(
                        fontSize: mqScreenSize.width * 0.029,
                        color: Colors.red),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _deleteButton(hasSavedReminder),
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: mqScreenSize.width * 0.034),
                    ),
                    onPressed: () {
                      notifier.resetChangingReminder();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    key: ValueKey('reminder_dialog_save_button'),
                    color: NoteColor.orange.getColor(),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: mqScreenSize.width * 0.034),
                    ),
                    onPressed: () async {
                      if (chosenTimeIsPast == false) {
                        if (notifier.savedReminder != null) {
                          notifier.removeSavedReminder();
                        }

                        // I only do this to grab an auto-incremented id
                        // for scheduling the new reminder
                        var newAlarmId = await noteSetupBloc.addReminderAlarm();

                        notifier.saveReminder(newAlarmId);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class _Divider extends StatelessWidget {
  final Color color;

  _Divider({@required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: color,
    );
  }
}
