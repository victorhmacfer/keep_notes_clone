import 'package:keep_notes_clone/models/note.dart';

class SearchResultViewModel {
  final List<Note> _regular;

  final List<Note> _archived;

  final List<Note> _deleted;

  final List<Note> _all;

  List<Note> get regular => List.unmodifiable(_regular);

  List<Note> get archived => List.unmodifiable(_archived);

  List<Note> get deleted => List.unmodifiable(_deleted);

  List<Note> get all => List.unmodifiable(_all);

  bool get isEmpty => _all.isEmpty;

  bool get isNotEmpty => !isEmpty;

  SearchResultViewModel(List<Note> notes)
      : _regular = [],
        _archived = [],
        _deleted = [],
        _all = [] {
    for (var note in notes) {
      _all.add(note);
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
