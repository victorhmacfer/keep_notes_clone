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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    final noteSetupBloc = Provider.of<NoteSetupBloc>(context);

    final notifier = Provider.of<NoteSetupScreenController>(context);

    String reminderDayText = translateReminderDay(
        notifier.reminderTimeInConstruction ?? DateTime.now());
    String reminderTimeText = translateReminderTime(
        notifier.reminderTimeInConstruction ?? DateTime.now());

    var now = DateTime.now();
    var twoYearsFromNow = now.add(Duration(days: 366 * 2));

    bool hasSavedReminder = notifier.savedReminderTime != null;

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
                      initialDate:
                          notifier.reminderTimeInConstruction ?? DateTime.now(),
                      firstDate: now,
                      lastDate: twoYearsFromNow);
                  if (chosenDate != null) {
                    var now = DateTime.now();
                    var inConstruction =
                        notifier.reminderTimeInConstruction ?? now;

                    var chosenInstant = DateTime(
                        chosenDate.year,
                        chosenDate.month,
                        chosenDate.day,
                        inConstruction.hour,
                        inConstruction.minute);

                    notifier.futureReminderCalendarDay = chosenDate;

                    setState(() {
                      chosenTimeIsPast = chosenInstant.isBefore(now);
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
                  var chosenTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        notifier.reminderTimeInConstruction ?? DateTime.now()),
                  );
                  if (chosenTime != null) {
                    var now = DateTime.now();
                    var inConstruction =
                        notifier.reminderTimeInConstruction ?? now;

                    var chosenInstant = DateTime(
                        inConstruction.year,
                        inConstruction.month,
                        inConstruction.day,
                        chosenTime.hour,
                        chosenTime.minute);

                    notifier.futureReminderHourMinute = DateTime(
                        9999, 12, 12, chosenTime.hour, chosenTime.minute);

                    setState(() {
                      chosenTimeIsPast = chosenInstant.isBefore(now);
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
                      notifier.resetReminderTimeToSavedOrNow();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: NoteColor.orange.getColor(),
                    child: Text('Save'),
                    onPressed: () async {
                      if (chosenTimeIsPast == false) {
                        if (notifier.savedReminderTime != null) {
                          notifier.removeSavedReminder();
                        }

                        // I only do this to grab an auto-incremented id
                        // for scheduling the new reminder
                        var newAlarmId = await noteSetupBloc.addReminderAlarm();

                        notifier.saveReminderTime(newAlarmId);
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
