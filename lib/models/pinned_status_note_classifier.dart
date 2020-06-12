import 'package:keep_notes_clone/models/note.dart';

class PinnedStatusNoteClassifier {
  final List<Note> notes;

  final List<Note> _pinned;

  final List<Note> _unpinned;

  List<Note> get pinned => List.unmodifiable(_pinned);

  List<Note> get unpinned => List.unmodifiable(_unpinned);

  PinnedStatusNoteClassifier(this.notes)
      : _pinned = [],
        _unpinned = [] {
    for (var note in notes) {
      if (note.pinned) {
        _pinned.add(note);
      } else {
        _unpinned.add(note);
      }
    }
  }
}
