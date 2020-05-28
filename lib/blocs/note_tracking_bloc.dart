import 'package:keep_notes_clone/models/note.dart';
import 'package:rxdart/subjects.dart';

class NoteTrackingBloc {
  // FIXME: later it will be initialized from the DB.
  List<Note> _notes = [];

  final _notesBS = BehaviorSubject<List<Note>>();

  Stream<List<Note>> get noteListStream => _notesBS.stream;

  void onCreateNewNote(String title, String text, int colorIndex) {
    var newNote = Note(title: title, text: text, colorIndex: colorIndex);

    _notes.add(newNote);
    _notesBS.add(_notes);
  }

  void dispose() {
    _notesBS.close();
  }
}
