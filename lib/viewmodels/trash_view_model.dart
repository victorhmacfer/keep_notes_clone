import 'package:keep_notes_clone/models/note.dart';

class TrashViewModel {
  final List<Note> _notes;

  List<Note> get notes => List.unmodifiable(_notes);

  TrashViewModel(List<Note> notes) : _notes = [] {
    for (var note in notes) {
      if (note.deleted) {
        _notes.add(note);
      }
    }
  }
}