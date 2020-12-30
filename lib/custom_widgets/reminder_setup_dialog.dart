import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_setup_bloc.dart';
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

    var nextMinute = DateTime.now().add(Duration(minutes: 1));

    String reminderDayText =
        translateReminderDay(notifier.changingReminder ?? nextMinute);
    String reminderTimeText =
        translateReminderTime(notifier.changingReminder ?? nextMinute);

    var twoYearsFromNow = DateTime.now().add(Duration(days: 366 * 2));

    var hasSavedReminder = notifier.savedReminder != null;

    String timeSettingFailureText =
        (chosenTimeIsPast) ? 'The time has passed' : '';

    Widget _deleteButton(bool hasSaved) {
      if (hasSaved) {
        return FlatButton(
          child: Text('Delete'),
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
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
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
                    fontSize: 16),
              ),
              GestureDetector(
                onTap: () async {
                  var chosenDate = await showDatePicker(
                      context: context,
                      initialDate: notifier.changingReminder ?? nextMinute,
                      firstDate: nextMinute,
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
                  padding: EdgeInsets.only(top: 24, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(reminderDayText),
                      Icon(Icons.calendar_today)
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
                    initialTime: TimeOfDay.fromDateTime(
                        notifier.changingReminder ?? nextMinute),
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
                  padding: EdgeInsets.only(top: 24, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(reminderTimeText),
                      Icon(Icons.schedule)
                    ],
                  ),
                ),
              ),
              _Divider(color: (chosenTimeIsPast) ? Colors.red : appDividerGrey),
              Container(
                  // color: Colors.brown,
                  alignment: Alignment.centerLeft,
                  height: 20,
                  child: Text(
                    timeSettingFailureText,
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _deleteButton(hasSavedReminder),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      notifier.resetChangingReminder();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    key: ValueKey('reminder_dialog_save_button'),
                    color: NoteColor.orange.getColor(),
                    child: Text('Save'),
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
