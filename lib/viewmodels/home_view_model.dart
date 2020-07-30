import 'package:keep_notes_clone/models/note.dart';

class HomeViewModel {
  final List<Note> _pinned;

  final List<Note> _unpinned;

  final List<Note> _all;

  List<Note> get pinned => List.unmodifiable(_pinned);

  List<Note> get unpinned => List.unmodifiable(_unpinned);

  List<Note> get all => List.unmodifiable(_all);

  HomeViewModel(List<Note> notes)
      : _pinned = [],
        _unpinned = [],
        _all = [] {
    for (var note in notes) {
      if (!note.archived && !note.deleted) {
        _all.add(note);
        if (note.pinned) {
          _pinned.add(note);
        } else {
          _unpinned.add(note);
        }
      }
    }
  }
}
