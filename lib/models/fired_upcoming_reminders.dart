import 'package:keep_notes_clone/models/note.dart';

class FiredUpcomingReminders {
  final List<Note> notes;

  final List<Note> _fired;

  final List<Note> _upcoming;

  List<Note> get fired => List.unmodifiable(_fired);

  List<Note> get upcoming => List.unmodifiable(_upcoming);

  FiredUpcomingReminders(this.notes)
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
