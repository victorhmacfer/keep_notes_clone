import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keep_notes_clone/main.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/reminder.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

class NoteSetupScreenController with ChangeNotifier {
  final bool _creating;

  final TextEditingController _titleController;
  final TextEditingController _textController;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  Note _noteBeingSetUp;

  DateTime _changingReminder = DateTime.now().add(Duration(minutes: 1));

  bool _noteIsDirty = false;

  NoteSetupScreenController()
      : _noteBeingSetUp = Note(lastEdited: DateTime.now()),
        _titleController = TextEditingController(),
        _textController = TextEditingController(),
        _creating = true {
    _titleController.addListener(() {
      _noteBeingSetUp.title = _titleController.text;
    });
    _textController.addListener(() {
      _noteBeingSetUp.text = _textController.text;
    });
  }

  NoteSetupScreenController.withLabel(Label label)
      : _noteBeingSetUp = Note(lastEdited: DateTime.now(), labels: [label]),
        _titleController = TextEditingController(),
        _textController = TextEditingController(),
        _creating = true {
    _titleController.addListener(() {
      _noteBeingSetUp.title = _titleController.text;
    });
    _textController.addListener(() {
      _noteBeingSetUp.text = _textController.text;
    });
  }

  NoteSetupScreenController.fromNote(Note note)
      : _noteBeingSetUp = note,
        _titleController = TextEditingController(text: note.title),
        _textController = TextEditingController(text: note.text),
        _creating = false {
    _titleController.addListener(() {
      _noteBeingSetUp.title = _titleController.text;
    });
    _textController.addListener(() {
      _noteBeingSetUp.text = _textController.text;
    });

    if (note.reminder != null) _changingReminder = note.reminder.time;
  }

  Note get noteBeingSetUp => _noteBeingSetUp;

  TextEditingController get titleController => _titleController;
  TextEditingController get textController => _textController;

  int get selectedColorIndex => _noteBeingSetUp.colorIndex;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_noteBeingSetUp.colorIndex);

  set selectedColorIndex(int newValue) {
    _noteBeingSetUp.colorIndex = newValue;
    notifyListeners();
  }

  bool get creating => _creating;
  bool get editing => !creating;

  bool get pinned => _noteBeingSetUp.pinned;

  bool get archived => _noteBeingSetUp.archived;

  DateTime get lastEdited => _noteBeingSetUp.lastEdited;

  List<Label> get futureLabels => List.unmodifiable(_noteBeingSetUp.labels);

  Reminder get savedReminder => _noteBeingSetUp.reminder;

  DateTime get changingReminder => _changingReminder;

  void resetChangingReminder() {
    var nextMinute = DateTime.now().add(Duration(minutes: 1));
    _changingReminder = _noteBeingSetUp.reminder?.time ?? nextMinute;
  }

  set reminderHourMinute(DateTime hourMinute) {
    _changingReminder = DateTime(
        _changingReminder.year,
        _changingReminder.month,
        _changingReminder.day,
        hourMinute.hour,
        hourMinute.minute);
  }

  set reminderDate(DateTime date) {
    _changingReminder = DateTime(date.year, date.month, date.day,
        _changingReminder.hour, _changingReminder.minute);
  }

  void saveReminder(int alarmId) async {
    _noteBeingSetUp.reminder = Reminder(id: alarmId, time: _changingReminder);

    await _scheduleReminderNotification(
        id: alarmId,
        noteTitle: _noteBeingSetUp.title,
        noteText: _noteBeingSetUp.text,
        scheduledNotificationDateTime: _noteBeingSetUp.reminder.time);

    notifyListeners();
  }

  Future<void> _scheduleReminderNotification(
      {@required int id,
      @required String noteTitle,
      @required String noteText,
      @required DateTime scheduledNotificationDateTime}) {
    var androidNotifDetails = AndroidNotificationDetails(
      'bla bla idk',
      'Reminders',
      '',
      importance: Importance.High,
    );

    var notifDetails =
        NotificationDetails(androidNotifDetails, IOSNotificationDetails());

    String notificationTitle;
    String notificationText;
    if (noteTitle.isNotEmpty && noteText.isNotEmpty) {
      notificationTitle = noteTitle;
      notificationText = noteText;
    } else {
      notificationText =
          reminderNotificationDateText(scheduledNotificationDateTime);
      if (noteTitle.isNotEmpty) {
        notificationTitle = noteTitle;
      } else if (noteText.isNotEmpty) {
        notificationTitle = noteText;
      } else {
        notificationTitle = 'Untitled note';
      }
    }

    return flnp.schedule(id, notificationTitle, notificationText,
        scheduledNotificationDateTime, notifDetails,
        payload: id.toString());
  }

  void removeSavedReminder() async {
    var alarmId = _noteBeingSetUp.reminder?.id;
    _noteBeingSetUp.reminder = null;

    _changingReminder = DateTime.now().add(Duration(minutes: 1));

    if (alarmId != null) {
      await flnp.cancel(alarmId);
    }
    notifyListeners();
  }

  bool get canCreateNote =>
      titleController.text.isNotEmpty ||
      textController.text.isNotEmpty ||
      (_noteBeingSetUp.reminder != null);

  void markNoteAsDirty() {
    _noteIsDirty = true;
    notifyListeners();
  }

  void tryToUpdateLastEdited() {
    if (_noteIsDirty) {
      _noteBeingSetUp.lastEdited = DateTime.now();
    }
  }

  void pinNote() {
    _noteBeingSetUp.pinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _noteBeingSetUp.pinned = false;
    notifyListeners();
  }

  void deleteNote() {
    var alarmId = _noteBeingSetUp.delete();
    if (alarmId != null) removeSavedReminder();
  }

  void restoreNote() {
    _noteBeingSetUp.restore();
  }

  void togglePinned() {
    _noteBeingSetUp.pinned = !_noteBeingSetUp.pinned;
    notifyListeners();
  }

  void toggleArchived() {
    _noteBeingSetUp.archived = !_noteBeingSetUp.archived;
    notifyListeners();
  }

  void checkLabel(Label label) {
    _noteBeingSetUp.labels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    var foundLabelIndex =
        _noteBeingSetUp.labels.indexWhere((lab) => lab.id == label.id);

    _noteBeingSetUp.labels.removeAt(foundLabelIndex);
    notifyListeners();
  }

  // ===========================================================================
  // THIS IS TRASH DESIGN BUT IT HAS TO BE THIS WAY.. FRAMEWORK WONT LET ME
  // SEPARATE BOTTOMSHEET STUFF INTO ANOTHER NOTIFIER.. CANT GET ACCESS TO SOME
  // THINGS.. ITS ALL DUE TO THE WAY THE BOTTOM SHEET IS SHOWN...
  //  Scaffold.of(context).showBottomSheet(blabla)..  I need context to call
  // showBottomSheet()  and I cant create the notifier giving it the result of
  // Scaffold.of  because the notifier is created before the Scaffold exists.
  // So I cant encapsulate this bottomsheet mess into the notifier.. awful.
  // ===========================================================================

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

  bool get leftBottomSheetOpen => _leftBottomSheetOpen;
  bool get rightBottomSheetOpen => _rightBottomSheetOpen;

  bool shouldManuallyCloseLeftSheet;
  bool shouldManuallyCloseRightSheet;

  void openLeftBottomSheet() {
    closeRightBottomSheet();
    _leftBottomSheetOpen = true;
  }

  void closeLeftBottomSheet() {
    if (leftBottomSheetOpen) {
      _leftBottomSheetOpen = false;
      if (leftBottomSheetController != null && shouldManuallyCloseLeftSheet) {
        leftBottomSheetController.close();
      }
    }
  }

  void openRightBottomSheet() {
    closeLeftBottomSheet();
    _rightBottomSheetOpen = true;
  }

  void closeRightBottomSheet() {
    if (rightBottomSheetOpen) {
      _rightBottomSheetOpen = false;
      if (rightBottomSheetController != null && shouldManuallyCloseRightSheet) {
        rightBottomSheetController.close();
      }
    }
  }
}
