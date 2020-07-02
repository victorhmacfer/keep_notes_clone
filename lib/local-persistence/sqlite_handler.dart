import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHandler {
  Database _database;

  SQLiteHandler() {
    _initialized = _openOrCreateDatabase();
  }

  Future<bool> _initialized;

  Future<bool> get initialized => _initialized;

  Future<bool> _openOrCreateDatabase() async {
    var databasesPath = await getDatabasesPath();

    String dbName = '02jul20201540.db';
    String path = '$databasesPath/$dbName';

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute('''CREATE TABLE note (
              id INTEGER PRIMARY KEY, 
              title TEXT, 
              text TEXT, 
              pinned INTEGER, 
              archived INTEGER, 
              deleted INTEGER, 
              colorIndex INTEGER, 
              lastEdited TEXT, 
              reminderTime TEXT,
              reminderAlarmId INTEGER
        );''');
      db.execute('''CREATE TABLE label (
              id INTEGER PRIMARY KEY, 
              name TEXT
        );''');
      db.execute('''CREATE TABLE note_label (
              note_id INTEGER,
              label_id INTEGER,
              FOREIGN KEY(note_id) REFERENCES note(id),
              FOREIGN KEY(label_id) REFERENCES label(id)
        );''');
      db.execute('''CREATE TABLE reminder_alarm (
              id INTEGER PRIMARY KEY,
              unused_field TEXT
        );''');
    });
    return true;
  }

  /// returns the auto-incremented id generated by the local DB
  Future<int> insertNote(Note note) async {
    var initialized = await _initialized;
    assert(initialized);

    String noteTitle = note.title;
    String noteText = note.text;
    int notePinned = (note.pinned) ? 1 : 0;
    int noteArchived = (note.archived) ? 1 : 0;
    int noteDeleted = (note.deleted) ? 1 : 0;
    int noteColorIndex = note.colorIndex;
    String noteLastEdited = note.lastEdited.toString();
    String noteReminderTime = note.reminderTime.toString();
    int noteReminderAlarmId = note.reminderAlarmId;

    var insertedNoteId = await _database.rawInsert(
        '''INSERT INTO note (title, text, pinned, archived, deleted, colorIndex, lastEdited, reminderTime, reminderAlarmId) 
      VALUES ("$noteTitle", "$noteText", $notePinned, $noteArchived, $noteDeleted,
              $noteColorIndex, "$noteLastEdited", "$noteReminderTime", $noteReminderAlarmId);''');

    for (var label in note.labels) {
      _database.rawInsert('''INSERT INTO note_label (note_id, label_id)
           VALUES ($insertedNoteId, ${label.id});''');
    }

    return insertedNoteId;
  }

  Future<int> insertLabel(Label label) async {
    var initialized = await _initialized;
    assert(initialized);

    String labelName = label.name;

    return _database
        .rawInsert('''INSERT INTO label (name) VALUES ("$labelName");''');
  }

  Future<void> updateNote(Note note) async {
    var initialized = await _initialized;
    assert(initialized);

    String noteTitle = note.title;
    String noteText = note.text;
    int notePinned = (note.pinned) ? 1 : 0;
    int noteArchived = (note.archived) ? 1 : 0;
    int noteDeleted = (note.deleted) ? 1 : 0;
    int noteColorIndex = note.colorIndex;
    String noteLastEdited = note.lastEdited.toString();
    String noteReminderTime = note.reminderTime.toString();
    int noteReminderAlarmId = note.reminderAlarmId;

    await _database.rawUpdate('''UPDATE note
         SET title = "$noteTitle",
             text = "$noteText",
             pinned = $notePinned,
             archived = $noteArchived,
             deleted = $noteDeleted,
             colorIndex = $noteColorIndex,
             lastEdited = "$noteLastEdited",
             reminderTime = "$noteReminderTime",
             reminderAlarmId = $noteReminderAlarmId
         WHERE id = ${note.id};''');

    await _database.rawDelete('''
        DELETE FROM note_label WHERE note_id = ${note.id}''');

    for (var label in note.labels) {
      _database.rawInsert('''INSERT INTO note_label (note_id, label_id)
           VALUES (${note.id}, ${label.id});''');
    }
  }

  Future<void> updateLabel(Label label) async {
    var initialized = await _initialized;
    assert(initialized);

    String newLabelName = label.name;

    _database.rawUpdate('''UPDATE label
          SET name = "$newLabelName"
          WHERE id = ${label.id};''');
  }

  Future<int> insertReminderAlarm() async {
    return _database.rawInsert(
        '''INSERT INTO reminder_alarm (unused_field) VALUES ("blabla");''');
  }

  Future<List<Note>> readAllNotes() async {
    var initialized = await _initialized;
    assert(initialized);

    var rows = await _database.rawQuery(
        '''SELECT id, title, text, pinned, archived, deleted, colorIndex, lastEdited, reminderTime, reminderAlarmId, label_id, name
         FROM note LEFT JOIN
         (SELECT note_id, label_id, name FROM note_label INNER JOIN label ON label_id = label.id)
         ON note.id = note_id''');

    return _mapReadQueryRowsToNoteList(rows);
  }

  List<Note> _mapReadQueryRowsToNoteList(List<Map<String, dynamic>> rows) {
    List<Note> theNotes = [];

    for (var r in rows) {
      int theNoteId = r['id'];
      String theTitle = r['title'];
      String theText = r['text'];
      bool thePinned = (r['pinned'] == 0) ? false : true;
      bool theArchived = (r['archived'] == 0) ? false : true;
      bool theDeleted = (r['deleted'] == 0) ? false : true;
      int theColorIndex = r['colorIndex'];
      DateTime theLastEdited = DateTime.parse(r['lastEdited']);
      int theReminderAlarmId = r['reminderAlarmId'];

      String reminderTimeInDb = r['reminderTime'];
      DateTime theReminderTime = (reminderTimeInDb != 'null')
          ? DateTime.parse(reminderTimeInDb)
          : null;

      int theLabelId = r['label_id'];
      String theLabelName = r['name'];

      var index = theNotes.indexWhere((note) => note.id == theNoteId);
      if (index == -1) {
        var theNote = Note(
            id: theNoteId,
            title: theTitle,
            text: theText,
            pinned: thePinned,
            archived: theArchived,
            deleted: theDeleted,
            colorIndex: theColorIndex,
            lastEdited: theLastEdited,
            reminderTime: theReminderTime,
            reminderAlarmId: theReminderAlarmId);
        if (theLabelId != null) {
          theNote.labels.add(Label(id: theLabelId, name: theLabelName));
        }
        theNotes.add(theNote);
      } else {
        var foundNote = theNotes[index];
        foundNote.labels.add(Label(id: theLabelId, name: theLabelName));
      }
    }
    return theNotes;
  }

  Future<List<Map<String, dynamic>>> readAllLabels() async {
    var initialized = await _initialized;
    assert(initialized);

    return _database.rawQuery('SELECT * FROM label');
  }
}
