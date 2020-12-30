import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/repository.dart';

class NoteSetupBloc {
  final GlobalRepository repo;

  NoteSetupBloc(this.repo);

  void onCreateNote(Note newNote, {bool createArchived = false}) {
    newNote.archived = createArchived;
    repo.addNote(newNote);
  }

  void onNoteChanged(Note changedNote) {
    repo.updateNote(changedNote);
  }

  void onDeleteNoteForever(Note noteForPermanentDeletion) {
    repo.deleteNote(noteForPermanentDeletion);
  }

  // Will reference a stand-alone table that stores only ids.
  // This is just for storing the AUTO INCREMENTED (therefore unused) id
  // and create an alarm with it.
  // Cannot be linked to notes because at the time I call this, the note
  // may not exist.. so I cant pass the note here as an argument.
  Future<int> addReminderAlarm() async {
    return repo.addReminderAlarm();
  }
}
