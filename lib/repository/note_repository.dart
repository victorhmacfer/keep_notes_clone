import 'package:keep_notes_clone/local-persistence/sqlite_handler.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:rxdart/rxdart.dart';

class NoteRepository {
  SQLiteHandler dbHandler;

  final _notesBS = BehaviorSubject<List<Note>>();
  final _labelsBS = BehaviorSubject<List<Label>>();

  Stream<List<Note>> get notes => _notesBS.stream;
  Stream<List<Label>> get allLabels => _labelsBS.stream;

  NoteRepository() {
    dbHandler = SQLiteHandler();

    _fetchNotes();
    _fetchLabels();
  }

  void _fetchNotes() async {
    await dbHandler.initialized;

    var notes = await dbHandler.readAllNotes();

    _notesBS.add(notes);
  }

  void _fetchLabels() async {
    await dbHandler.initialized;

    List<Map<String, dynamic>> labelMaps = await dbHandler.readAllLabels();

    List<Label> labels = labelMaps.map((m) => Label.fromMap(m)).toList();

    _labelsBS.add(labels);
  }

  Future<int> addNote(Note note) async {
    List<Note> currentNotes = (_notesBS.hasValue) ? _notesBS.value : [];

    var insertedNoteId = await dbHandler.insertNote(note);

    note.id = insertedNoteId;
    currentNotes.add(note);
    _notesBS.add(currentNotes);
    return insertedNoteId;
  }

  Future<int> addLabel(Label label) async {
    List<Label> currentLabels = (_labelsBS.hasValue) ? _labelsBS.value : [];

    var insertedLabelId = await dbHandler.insertLabel(label);

    label.id = insertedLabelId;

    currentLabels.add(label);
    _labelsBS.add(currentLabels);
    return insertedLabelId;
  }

  void updateNote(Note note) async {
    await dbHandler.updateNote(note);

    List<Note> currentNotes = _notesBS.value;
    _notesBS.add(currentNotes);
  }

  void updateLabel(Label label) async {
    dbHandler.updateLabel(label);

    List<Label> currentLabels = _labelsBS.value;
    var index = currentLabels.indexWhere((lab) => lab.id == label.id);
    currentLabels[index] = label;
    _labelsBS.add(currentLabels);

    _fetchNotes();
  }

  void deleteLabel(Label label) async {
    List<Label> currentLabels = _labelsBS.value;

    var index = currentLabels.indexWhere((lab) => lab.id == label.id);
    currentLabels.removeAt(index);
    _labelsBS.add(currentLabels);

    await dbHandler.deleteLabel(label);

    _fetchNotes();
  }

  void deleteNote(Note note) {
    List<Note> currentNotes = _notesBS.value;

    var index = currentNotes.indexWhere((n) => n.id == note.id);
    currentNotes.removeAt(index);
    _notesBS.add(currentNotes);

    dbHandler.deleteNote(note);
  }

  void deleteManyNotes(List<Note> notes) {
    List<Note> currentNotes = _notesBS.value;

    for (var note in notes) {
      var index = currentNotes.indexWhere((n) => n.id == note.id);
      currentNotes.removeAt(index);
      dbHandler.deleteNote(note);
    }
    _notesBS.add(currentNotes);
  }

  void updateManyNotes(List<Note> notes) {
    List<Note> currentNotes = _notesBS.value;

    for (var note in notes) {
      dbHandler.updateNote(note);
    }
    _notesBS.add(currentNotes);
  }

  Future<int> addReminderAlarm() async {
    return dbHandler.insertReminderAlarm();
  }
}
