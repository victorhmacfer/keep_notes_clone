import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class NoteSetupScreenController with ChangeNotifier {
  final TextEditingController titleController;
  final TextEditingController textController;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  int _selectedColorIndex;

  bool _isPinned;

  List<Label> _futureLabels;

  Note _noteBeingEdited;

  final bool _editing;

  DateTime noteLastEdited;

  bool _noteIsDirty = false;

  DateTime _futureReminderDateTime = DateTime.now();

  DateTime _savedReminderDateTime;
  bool _reminderExpired = false;
  int _savedReminderAlarmId;

  NoteSetupScreenController()
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        _selectedColorIndex = 0,
        _isPinned = false,
        noteLastEdited = DateTime.now(),
        _editing = false,
        _futureLabels = [];

  NoteSetupScreenController.withLabel(Label label)
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        _selectedColorIndex = 0,
        _isPinned = false,
        noteLastEdited = DateTime.now(),
        _editing = false,
        _futureLabels = [label];

  NoteSetupScreenController.fromNote(Note note)
      : titleController = TextEditingController(text: note.title),
        textController = TextEditingController(text: note.text),
        _selectedColorIndex = note.colorIndex,
        _isPinned = note.pinned,
        noteLastEdited = note.lastEdited,
        _editing = true,
        _futureLabels = List.from(note.labels),
        _noteBeingEdited = note {
    if (note.reminderTime != null) {
      _futureReminderDateTime = note.reminderTime;
      _savedReminderDateTime = note.reminderTime;
      _reminderExpired = _savedReminderDateTime.isBefore(DateTime.now());
      _savedReminderAlarmId = note.reminderAlarmId;
    }
  }

  int get selectedColorIndex => _selectedColorIndex;

  DateTime get futureReminderDateTime => _futureReminderDateTime;

  DateTime get savedReminderTime => _savedReminderDateTime;

  bool get reminderExpired => _reminderExpired;

  set futureReminderTime(DateTime newTime) {
    _futureReminderDateTime = DateTime(
        _futureReminderDateTime?.year ?? 9999,
        _futureReminderDateTime?.month ?? 12,
        _futureReminderDateTime?.day ?? 12,
        newTime.hour,
        newTime.minute);
    notifyListeners();
  }

  set futureReminderDay(DateTime newReminderDate) {
    var currentHour = _futureReminderDateTime?.hour ?? 12;
    var currentMinute = _futureReminderDateTime?.minute ?? 12;
    _futureReminderDateTime = DateTime(newReminderDate.year,
        newReminderDate.month, newReminderDate.day, currentHour, currentMinute);
    notifyListeners();
  }

  void resetReminderTimeToSavedOrNow() {
    _futureReminderDateTime = _savedReminderDateTime ?? DateTime.now();
  }

  void saveReminderTime(int alarmId) async {
    _savedReminderDateTime = _futureReminderDateTime;
    _savedReminderAlarmId = alarmId;

    var success = await AndroidAlarmManager.oneShotAt(_savedReminderDateTime,
        alarmId, NoteTrackingBloc.androidAlarmManagerCallback);

    print('sucesso de armar eh: $success');

    notifyListeners();
  }

  void removeSavedReminder() async {
    _savedReminderDateTime = null;

    if (_savedReminderAlarmId != null) {
      var success = await AndroidAlarmManager.cancel(_savedReminderAlarmId);
      print('sucesso de desarmar eh: $success');
    }

    _savedReminderAlarmId = null;

    notifyListeners();
  }

  int get savedReminderAlarmId => _savedReminderAlarmId;

  Note get noteBeingEdited => _noteBeingEdited;

  bool get editing => _editing;
  bool get notEditing => !editing;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_selectedColorIndex);

  set selectedColorIndex(int newValue) {
    _selectedColorIndex = newValue;
    notifyListeners();
  }

  bool get noteIsDirty => _noteIsDirty;

  void markNoteAsDirty() {
    _noteIsDirty = true;
    notifyListeners();
  }

  bool get isPinned => _isPinned;

  List<Label> get futureLabels => List.unmodifiable(_futureLabels);

  void pinNote() {
    _isPinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _isPinned = false;
    notifyListeners();
  }

  void checkLabel(Label label) {
    _futureLabels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    var foundLabelIndex = _futureLabels.indexWhere((lab) => lab.id == label.id);

    _futureLabels.removeAt(foundLabelIndex);
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
