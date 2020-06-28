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

    var sqliteNoteReadResult = await dbHandler.readAllNotes();
    var notes = sqliteNoteReadResult.notes;

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

    //TODO: add in webservice
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
}
