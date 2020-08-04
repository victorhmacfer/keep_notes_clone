import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note_setup_model.dart';

class Note {
  int id;
  String title;
  String text;
  bool _pinned;
  bool _archived;
  bool _deleted;
  int colorIndex;
  DateTime lastEdited;
  DateTime reminderTime;
  int reminderAlarmId;

  List<Label> labels;

  Note(
      {this.id,
      this.title = '',
      this.text = '',
      this.colorIndex = 0,
      labels,
      @required this.lastEdited,
      this.reminderTime,
      this.reminderAlarmId,
      bool deleted = false,
      pinned = false,
      archived = false}) {
    if (deleted) {
      assert((reminderTime == null) && !pinned && !archived);
    }

    this.labels = labels ?? [];

    _pinned = pinned;
    _archived = archived;
    _deleted = deleted;
  }

  // always used for creating a NEW NOTE
  Note.fromSetupModel(NoteSetupModel setupModel, {bool archived = false})
      : assert(setupModel.selectedColorIndex != null),
        assert(setupModel.noteLastEdited != null) {
    title = (setupModel.title.isNotEmpty) ? setupModel.title : '';
    text = (setupModel.text.isNotEmpty) ? setupModel.text : '';
    _pinned = setupModel.isPinned;
    _archived = archived;
    _deleted = false;
    colorIndex = setupModel.selectedColorIndex;
    lastEdited = setupModel.noteLastEdited;
    reminderTime = setupModel.savedReminderTime;
    if (title.isEmpty && text.isEmpty && (reminderTime != null)) {
      text = 'Empty reminder';
    }
    reminderAlarmId = setupModel.savedReminderAlarmId;
    labels = setupModel.labels ?? [];
  }

  void updateWith(NoteSetupModel setupModel) {
    title = setupModel.title;
    text = setupModel.text;
    colorIndex = setupModel.selectedColorIndex;
    lastEdited = setupModel.noteLastEdited;
    pinned = setupModel.isPinned;
    reminderTime = setupModel.savedReminderTime;
    reminderAlarmId = setupModel.savedReminderAlarmId;
    labels = setupModel.labels;
  }

  bool contains(String substring) {
    if (title.contains(substring)) return true;

    if (text.contains(substring)) return true;

    for (var lab in labels) {
      if (lab.name.contains(substring)) return true;
    }

    return false;
  }

  bool get pinned => _pinned;
  bool get archived => _archived;

  bool get deleted => _deleted;

  // pinning a note should unarchive it
  set pinned(bool newValue) {
    if ((newValue == true) && (_archived)) _archived = false;
    _pinned = newValue;
  }

  // archiving a note should unpin it.
  set archived(bool newValue) {
    if ((newValue == true) && (_pinned)) _pinned = false;
    _archived = newValue;
  }

  void delete() {
    _pinned = false;
    _archived = false;
    _deleted = true;
    reminderTime = null;
  }

  void restore() {
    _deleted = false;
  }
}
