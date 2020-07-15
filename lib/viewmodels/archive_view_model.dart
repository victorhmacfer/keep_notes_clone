import 'package:keep_notes_clone/models/note.dart';

class ArchiveViewModel {
  final List<Note> _notes;

  List<Note> get notes => List.unmodifiable(_notes);

  ArchiveViewModel(List<Note> notes) : _notes = [] {
    for (var note in notes) {
      if (note.archived) {
        _notes.add(note);
      }
    }
  }
}
