import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:rxdart/subjects.dart';

class NoteTrackingBloc {
  // FIXME: later it will be initialized from the DB.
  List<Note> _notes = [];

  List<Label> _labels = [];

  final _notesBS = BehaviorSubject<List<Note>>();
  final _labelsBS = BehaviorSubject<List<Label>>();

  Stream<List<Note>> get noteListStream => _notesBS.stream;
  Stream<List<Label>> get labelListStream => _labelsBS.stream;

  void onCreateNewNote(String title, String text, int colorIndex) {
    var newNote = Note(title: title, text: text, colorIndex: colorIndex);

    _notes.add(newNote);
    _notesBS.add(_notes);
  }

  void onCreateNewLabel(String text) {
    // TODO: check for label existence

    _labels.add(Label(text: text));
    _labelsBS.add(_labels);
  }

  void dispose() {
    _notesBS.close();
    _labelsBS.close();
  }
}
