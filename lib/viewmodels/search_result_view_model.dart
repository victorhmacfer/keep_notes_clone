import 'package:keep_notes_clone/models/note.dart';

class SearchResultViewModel {
  final List<Note> _regular;

  final List<Note> _archived;

  final List<Note> _deleted;

  List<Note> get regular => List.unmodifiable(_regular);

  List<Note> get archived => List.unmodifiable(_archived);

  List<Note> get deleted => List.unmodifiable(_deleted);

  bool get isEmpty => _regular.isEmpty && _archived.isEmpty && _deleted.isEmpty;

  bool get isNotEmpty => !isEmpty;

  SearchResultViewModel(List<Note> notes)
      : _regular = [],
        _archived = [],
        _deleted = [] {
    for (var note in notes) {
      if (note.archived) {
        _archived.add(note);
      } else if (note.deleted) {
        _deleted.add(note);
      } else {
        _regular.add(note);
      }
    }
  }
}
