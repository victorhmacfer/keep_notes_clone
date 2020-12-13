import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';

class NoteSetupModel {
  final TextEditingController titleController;
  final TextEditingController textController;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  int selectedColorIndex;

  bool isPinned;

  DateTime noteLastEdited;

  List<Label> labels;

  DateTime reminderTimeInConstruction;

  DateTime _savedReminderDateTime;

  bool _reminderExpired = false;

  int _savedReminderAlarmId;

  NoteSetupModel()
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        selectedColorIndex = 0,
        isPinned = false,
        noteLastEdited = DateTime.now(),
        labels = [];

  NoteSetupModel.withLabel(Label label)
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        selectedColorIndex = 0,
        isPinned = false,
        noteLastEdited = DateTime.now(),
        labels = [label];

  NoteSetupModel.fromNote(Note note)
      : titleController = TextEditingController(text: note.title),
        textController = TextEditingController(text: note.text),
        selectedColorIndex = note.colorIndex,
        isPinned = note.pinned,
        noteLastEdited = note.lastEdited,
        labels = List.from(note.labels) {
    if (note.reminder != null) {
      reminderTimeInConstruction = note.reminder.time;
      _savedReminderDateTime = note.reminder.time;
      _reminderExpired = note.reminder.expired;
      _savedReminderAlarmId = note.reminder.id;
    }
  }

  String get title => titleController.text;
  String get text => textController.text;

  DateTime get savedReminderTime => _savedReminderDateTime;

  bool get hasSavedReminder => savedReminderTime != null;

  bool get reminderExpired => _reminderExpired;

  set reminderHourMinute(DateTime newTime) {
    var now = DateTime.now();
    reminderTimeInConstruction = DateTime(
        reminderTimeInConstruction?.year ?? now.year,
        reminderTimeInConstruction?.month ?? now.month,
        reminderTimeInConstruction?.day ?? now.day,
        newTime.hour,
        newTime.minute);
  }

  set reminderDay(DateTime newReminderDate) {
    var now = DateTime.now();
    reminderTimeInConstruction = DateTime(
        newReminderDate.year,
        newReminderDate.month,
        newReminderDate.day,
        reminderTimeInConstruction?.hour ?? now.hour,
        reminderTimeInConstruction?.minute ?? now.minute);
  }

  void saveReminderTime(int alarmId) {
    _savedReminderDateTime = reminderTimeInConstruction;
    _savedReminderAlarmId = alarmId;
  }

  void removeSavedReminder() {
    _savedReminderDateTime = null;
    _savedReminderAlarmId = null;
  }

  int get savedReminderAlarmId => _savedReminderAlarmId;
}
