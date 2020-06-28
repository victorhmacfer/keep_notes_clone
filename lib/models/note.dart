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

  List<Label> labels;

  Note(
      {this.id,
      this.title = '',
      this.text = '',
      this.colorIndex = 0,
      labels,
      @required this.lastEdited,
      this.reminderTime,
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

  factory Note.fromMap(Map<String, dynamic> noteMap) {
    String theTitle = noteMap['title'] ?? '';
    String theText = noteMap['text'] ?? '';
    bool thePinned = (noteMap['pinned'] == 0) ? false : true;
    bool theArchived = (noteMap['archived'] == 0) ? false : true;
    bool theDeleted = (noteMap['deleted'] == 0) ? false : true;

    // assumes it will never be null in the DB.

    DateTime theLastEdited = DateTime.parse(noteMap['lastEdited']);

    String reminderTimeInDb = noteMap['reminderTime'];


    DateTime theReminderTime =
        (reminderTimeInDb != 'null') ? DateTime.parse(reminderTimeInDb) : null;

    return Note(
      id: noteMap['id'],
      title: theTitle,
      text: theText,
      colorIndex: noteMap['colorIndex'],
      pinned: thePinned,
      archived: theArchived,
      deleted: theDeleted,
      lastEdited: theLastEdited,
      reminderTime: theReminderTime,
      labels: [], //FIXME: always creating note without labels
    );
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
