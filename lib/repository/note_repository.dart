import 'package:keep_notes_clone/local-persistence/local_database_handler.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:rxdart/rxdart.dart';

class GlobalRepository {
  LocalDatabaseHandler dbHandler;

  final notesBS = BehaviorSubject<List<Note>>();
  final _labelsBS = BehaviorSubject<List<Label>>();

  final String username;

  Stream<List<Note>> get notes => notesBS.stream;
  Stream<List<Label>> get allLabels => _labelsBS.stream;

  GlobalRepository(this.username) {
    dbHandler = SembastLocalDatabaseHandler(username: username);

    _fetchNotes();
    _fetchLabels();
  }

  void _fetchNotes() async {
    await dbHandler.initialized;
    var notes = await dbHandler.readAllNotes();
    notesBS.add(notes);
  }

  void _fetchLabels() async {
    await dbHandler.initialized;
    var labels = await dbHandler.readAllLabels();
    _labelsBS.add(labels);
  }

  Future<int> addNote(Note note) async {
    List<Note> currentNotes = (notesBS.hasValue) ? notesBS.value : [];

    var insertedNoteId = await dbHandler.insertNote(note);

    note.id = insertedNoteId;
    currentNotes.add(note);
    notesBS.add(currentNotes);
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

    List<Note> currentNotes = notesBS.value;
    notesBS.add(currentNotes);
  }

  void updateLabel(Label label) async {
    await dbHandler.updateLabel(label);

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
    List<Note> currentNotes = notesBS.value;

    var index = currentNotes.indexWhere((n) => n.id == note.id);
    currentNotes.removeAt(index);
    notesBS.add(currentNotes);

    dbHandler.deleteNote(note);
  }

  void deleteManyNotes(List<Note> notes) {
    List<Note> currentNotes = notesBS.value;

    for (var note in notes) {
      var index = currentNotes.indexWhere((n) => n.id == note.id);
      currentNotes.removeAt(index);
      dbHandler.deleteNote(note);
    }
    notesBS.add(currentNotes);
  }

  void updateManyNotes(List<Note> notes) {
    List<Note> currentNotes = notesBS.value;

    for (var note in notes) {
      dbHandler.updateNote(note);
    }
    notesBS.add(currentNotes);
  }

  Future<int> addReminderAlarm() {
    return dbHandler.insertReminderAlarm();
  }
}
