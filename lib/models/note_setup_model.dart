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

  DateTime reminderDateTime = DateTime.now();

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
    if (note.reminderTime != null) {
      reminderDateTime = note.reminderTime;
      _savedReminderDateTime = note.reminderTime;
      _reminderExpired = _savedReminderDateTime.isBefore(DateTime.now());
      _savedReminderAlarmId = note.reminderAlarmId;
    }
  }

  String get title => titleController.text;
  String get text => textController.text;

  DateTime get savedReminderTime => _savedReminderDateTime;

  bool get hasSavedReminder => savedReminderTime != null;

  bool get reminderExpired => _reminderExpired;

  set reminderTime(DateTime newTime) {
    reminderDateTime = DateTime(
        reminderDateTime?.year ?? 9999,
        reminderDateTime?.month ?? 12,
        reminderDateTime?.day ?? 12,
        newTime.hour,
        newTime.minute);
  }

  set reminderDay(DateTime newReminderDate) {
    var currentHour = reminderDateTime?.hour ?? 12;
    var currentMinute = reminderDateTime?.minute ?? 12;
    reminderDateTime = DateTime(newReminderDate.year, newReminderDate.month,
        newReminderDate.day, currentHour, currentMinute);
  }

  void saveReminderTime(int alarmId) {
    _savedReminderDateTime = reminderDateTime;
    _savedReminderAlarmId = alarmId;
  }

  void removeSavedReminder() {
    _savedReminderDateTime = null;
    _savedReminderAlarmId = null;
  }

  int get savedReminderAlarmId => _savedReminderAlarmId;
}
