import 'package:keep_notes_clone/models/note.dart';

class RemindersViewModel {
  final List<Note> _fired;

  final List<Note> _upcoming;

  List<Note> get fired => List.unmodifiable(_fired);

  List<Note> get upcoming => List.unmodifiable(_upcoming);

  RemindersViewModel(List<Note> notes)
      : _fired = [],
        _upcoming = [] {
    var now = DateTime.now();

    for (var note in notes) {
      if (note.reminderTime != null) {
        if (note.reminderTime.isBefore(now)) {
          _fired.add(note);
        } else {
          _upcoming.add(note);
        }
      }
    }
  }
}