import 'package:keep_notes_clone/models/note.dart';

class LabelFilteredNotesContainer {
  List<Note> _pinned = [];
  List<Note> _unpinned = [];
  List<Note> _archived = [];

  List<Note> get pinned => List.unmodifiable(_pinned);

  List<Note> get unpinned => List.unmodifiable(_unpinned);

  List<Note> get archived => List.unmodifiable(_archived);

  LabelFilteredNotesContainer(List<Note> notes) {
    for (var n in notes) {
      if (n.pinned) {
        _pinned.add(n);
      } else if (n.archived) {
        _archived.add(n);
      } else {
        _unpinned.add(n);
      }
    }
  }
}
