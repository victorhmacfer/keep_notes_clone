import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/reminder.dart';

class Note {
  int id;
  String title;
  String text;
  bool _pinned;
  bool _archived;
  bool _deleted;
  int colorIndex;
  DateTime lastEdited;
  Reminder reminder;

  List<Label> labels;

  Note(
      {this.id,
      this.title = '',
      this.text = '',
      this.colorIndex = 0,
      labels,
      @required this.lastEdited,
      this.reminder,
      bool deleted = false,
      bool pinned = false,
      bool archived = false}) {
    if (deleted) {
      assert((reminder == null) && !pinned && !archived);
    }

    this.labels = (labels != null) ? (List.from(labels)) : [];

    _pinned = pinned;
    _archived = archived;
    _deleted = deleted;
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

  int delete() {
    _pinned = false;
    _archived = false;
    _deleted = true;
    var alarmId = reminder?.id;
    reminder = null;
    return alarmId;
  }

  void restore() {
    _deleted = false;
  }
}
