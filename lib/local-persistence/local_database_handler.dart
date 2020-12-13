import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/reminder.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';

abstract class LocalDatabaseHandler {
  Future<List<Note>> readAllNotes();
  Future<int> insertNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(Note note);

  Future<bool> get initialized;

  Future<List<Label>> readAllLabels();
  Future<int> insertLabel(Label label);
  Future<void> updateLabel(Label label);
  Future<void> deleteLabel(Label label);

  Future<int> insertReminderAlarm();
}

class SembastLocalDatabaseHandler implements LocalDatabaseHandler {
  Database _db;
  Future<bool> _initialized;

  final noteStore = intMapStoreFactory.store('notes');
  final labelStore = intMapStoreFactory.store('labels');
  final reminderStore = intMapStoreFactory.store('reminders');

  SembastLocalDatabaseHandler({@required String username}) {
    assert(username != null);
    assert(username.isNotEmpty);
    _initialized = _openOrCreateDatabase(username);
  }

  Future<bool> get initialized => _initialized;

  Future<List<Note>> readAllNotes() async {
    var noteSnapshots = await noteStore.find(_db);
    return noteSnapshots.map(_noteFromRecordSnapshot).toList();
  }

  Future<List<Label>> readAllLabels() async {
    var labelSnapshots = await labelStore.find(_db);
    return labelSnapshots.map(_labelFromRecordSnapshot).toList();
  }

  Future<int> insertNote(Note note) async {
    return noteStore.add(_db, _noteInsertionMap(note));
  }

  Future<int> insertLabel(Label label) async {
    return labelStore.add(_db, _labelInsertionMap(label));
  }

  Future<void> updateLabel(Label label) async {
    // update this label in labels collection
    assert(label.id != null);
    var labelRecord = labelStore.record(label.id);
    await labelRecord.update(_db, _labelInsertionMap(label));

    // update all notes that have this label
    var hasLabelAndIsOutdated = Finder(filter: Filter.custom((rs) {
      List<Map<String, dynamic>> labelMapsList =
          (rs.value['labels'] != null) ? List.from(rs.value['labels']) : [];
      return labelMapsList
          .any((map) => (map['id'] == label.id) && (map['name'] != label.name));
    }));

    while (true) {
      var rs = await noteStore.findFirst(_db, finder: hasLabelAndIsOutdated);
      if (rs == null) break;

      var recordMap = await noteStore.record(rs.key).get(_db);

      List<Map<String, dynamic>> labelMapsList = List.from(recordMap['labels']);
      var i = labelMapsList.indexWhere((m) => m['id'] == label.id);
      labelMapsList[i] = {'id': label.id, 'name': label.name};

      await noteStore.record(rs.key).update(_db, {'labels': labelMapsList});
    }
  }

  Future<void> updateNote(Note note) async {
    assert(note.id != null);
    var noteRecord = noteStore.record(note.id);
    noteRecord.update(_db, _noteInsertionMap(note));
  }

  Future<void> deleteLabel(Label label) async {
    // delete label record
    assert(label.id != null);
    var labelRecord = labelStore.record(label.id);
    await labelRecord.delete(_db);

    // remove label from notes
    var hasThisLabel = Finder(filter: Filter.custom((rs) {
      List<Map<String, dynamic>> labelMapsList =
          (rs.value['labels'] != null) ? List.from(rs.value['labels']) : [];
      return labelMapsList.any((map) => (map['id'] == label.id));
    }));

    while (true) {
      var recSnap = await noteStore.findFirst(_db, finder: hasThisLabel);
      if (recSnap == null) break;

      var key = recSnap.key;

      var recordMap = await noteStore.record(key).get(_db);
      List<Map<String, dynamic>> labelMapsList = List.from(recordMap['labels']);
      var i = labelMapsList.indexWhere((m) => m['id'] == label.id);
      labelMapsList.removeAt(i);
      await noteStore.record(key).update(_db, {'labels': labelMapsList});
    }
  }

  Future<void> deleteNote(Note note) async {
    assert(note.id != null);
    var noteRecord = noteStore.record(note.id);
    noteRecord.delete(_db);
  }

  Future<bool> _openOrCreateDatabase(String username) async {
    var path = await _dbPath(username);
    _db = await databaseFactoryIo.openDatabase(path);
    return true;
  }

  Future<String> _dbPath(String username) async {
    assert(username != null);
    assert(username.isNotEmpty);
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return join(dir.path, '$username.db');
  }

  Map<String, dynamic> _noteInsertionMap(Note note) {
    var labelMaps =
        note.labels.map((lab) => {'id': lab.id, 'name': lab.name}).toList();

    var reminderMap = (note.reminder != null)
        ? {
            'id': note.reminder.id,
            'time': Timestamp.fromDateTime(note.reminder.time)
          }
        : {};

    return {
      'title': note.title,
      'text': note.text,
      'pinned': note.pinned,
      'archived': note.archived,
      'deleted': note.deleted,
      'colorIndex': note.colorIndex,
      'lastEdited': Timestamp.fromDateTime(note.lastEdited),
      'reminder': reminderMap,
      'labels': labelMaps,
    };
  }

  // Only used for maps destined to labels collection!
  // Should not be used for producing label maps for the notes collection since
  // those need a label id
  Map<String, dynamic> _labelInsertionMap(Label label) {
    return {
      'name': label.name,
    };
  }

  Note _noteFromRecordSnapshot(RecordSnapshot<int, Map<String, dynamic>> rs) {
    var theLabels = rs.value['labels']?.map((labelMap) {
      return Label(id: labelMap['id'], name: labelMap['name']);
    })?.toList();

    Reminder theReminder;

    if (rs.value['reminder'] != null) {
      Map<String, dynamic> theMap = rs.value['reminder'];
      if (theMap.isNotEmpty) {
        theReminder = Reminder(
            id: rs.value['reminder']['id'],
            time: rs.value['reminder']['time']?.toDateTime());
      }
    }

    return Note(
      id: rs.key,
      title: rs.value['title'] ?? '',
      text: rs.value['text'] ?? '',
      pinned: rs.value['pinned'] ?? false,
      archived: rs.value['archived'] ?? false,
      deleted: rs.value['deleted'] ?? false,
      colorIndex: rs.value['colorIndex'] ?? 0,
      lastEdited: rs.value['lastEdited']?.toDateTime(),
      reminder: theReminder,
      labels: theLabels,
    );
  }

  Label _labelFromRecordSnapshot(RecordSnapshot<int, Map<String, dynamic>> rs) {
    return Label(
      id: rs.key,
      name: rs.value['name'] ?? '',
    );
  }

  //FIXME: this is temporary !
  Future<int> insertReminderAlarm() {
    return reminderStore.add(_db, {'useless_field': 'bla'});
  }
}
