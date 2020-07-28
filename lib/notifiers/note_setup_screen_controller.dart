import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keep_notes_clone/main.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/note_setup_model.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/datetime_translation.dart';

class NoteSetupScreenController with ChangeNotifier {
  final NoteSetupModel _noteSetupModel;

  Note _noteBeingEdited;

  final bool _editing;

  bool _noteIsDirty = false;

  NoteSetupScreenController()
      : _noteSetupModel = NoteSetupModel(),
        _editing = false;

  NoteSetupScreenController.withLabel(Label label)
      : _noteSetupModel = NoteSetupModel.withLabel(label),
        _editing = false;

  NoteSetupScreenController.fromNote(Note note)
      : _noteBeingEdited = note,
        _noteSetupModel = NoteSetupModel.fromNote(note),
        _editing = true;

  TextEditingController get titleController => _noteSetupModel.titleController;
  TextEditingController get textController => _noteSetupModel.textController;

  FocusNode get titleFocusNode => _noteSetupModel.titleFocusNode;
  FocusNode get textFocusNode => _noteSetupModel.textFocusNode;

  int get selectedColorIndex => _noteSetupModel.selectedColorIndex;

  DateTime get futureReminderDateTime => _noteSetupModel.reminderDateTime;

  DateTime get savedReminderTime => _noteSetupModel.savedReminderTime;

  DateTime get noteLastEdited => _noteSetupModel.noteLastEdited;

  bool get reminderExpired => _noteSetupModel.reminderExpired;

  NoteSetupModel get noteSetupModel => _noteSetupModel;

  bool get canApplySetupModelToNote =>
      titleController.text.isNotEmpty ||
      textController.text.isNotEmpty ||
      _noteSetupModel.hasSavedReminder;

  set futureReminderTime(DateTime newTime) {
    _noteSetupModel.reminderTime = newTime;
    notifyListeners();
  }

  set futureReminderDay(DateTime newReminderDate) {
    _noteSetupModel.reminderDay = newReminderDate;
    notifyListeners();
  }

  void resetReminderTimeToSavedOrNow() {
    _noteSetupModel.reminderDateTime =
        _noteSetupModel.savedReminderTime ?? DateTime.now();
  }

  void saveReminderTime(int alarmId) async {
    _noteSetupModel.saveReminderTime(alarmId);

    await _scheduleReminderNotification(
        id: alarmId,
        noteTitle: _noteSetupModel.title,
        noteText: _noteSetupModel.text,
        scheduledNotificationDateTime: _noteSetupModel.savedReminderTime);

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

    return flnp.schedule(id, notificationTitle,
        notificationText, scheduledNotificationDateTime, notifDetails, payload: id.toString());
  }

  void removeSavedReminder() async {
    var alarmId = _noteSetupModel.savedReminderAlarmId;
    _noteSetupModel.removeSavedReminder();

    if (alarmId != null) {
      await flnp.cancel(alarmId);
    }
    notifyListeners();
  }

  int get savedReminderAlarmId => _noteSetupModel.savedReminderAlarmId;

  Note get noteBeingEdited => _noteBeingEdited;

  bool get editing => _editing;
  bool get notEditing => !editing;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_noteSetupModel.selectedColorIndex);

  set selectedColorIndex(int newValue) {
    _noteSetupModel.selectedColorIndex = newValue;
    notifyListeners();
  }

  void markNoteAsDirty() {
    _noteIsDirty = true;
    notifyListeners();
  }

  void tryToUpdateLastEdited() {
    if (_noteIsDirty) {
      _noteSetupModel.noteLastEdited = DateTime.now();
    }
  }

  bool get isPinned => _noteSetupModel.isPinned;

  List<Label> get futureLabels => List.unmodifiable(_noteSetupModel.labels);

  void pinNote() {
    _noteSetupModel.isPinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _noteSetupModel.isPinned = false;
    notifyListeners();
  }

  void checkLabel(Label label) {
    _noteSetupModel.labels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    var foundLabelIndex =
        _noteSetupModel.labels.indexWhere((lab) => lab.id == label.id);

    _noteSetupModel.labels.removeAt(foundLabelIndex);
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
