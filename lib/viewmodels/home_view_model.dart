import 'package:keep_notes_clone/models/note.dart';

class HomeViewModel {
  final List<Note> _pinned;

  final List<Note> _unpinned;

  List<Note> get pinned => List.unmodifiable(_pinned);

  List<Note> get unpinned => List.unmodifiable(_unpinned);

  HomeViewModel(List<Note> notes)
      : _pinned = [],
        _unpinned = [] {
    for (var note in notes) {
      if (!note.archived && !note.deleted) {
        if (note.pinned) {
          _pinned.add(note);
        } else {
          _unpinned.add(note);
        }
      }
    }
  }
}
