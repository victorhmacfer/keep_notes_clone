import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';

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
}
