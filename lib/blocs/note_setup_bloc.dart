import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/note_setup_model.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';

class NoteSetupBloc {
  final GlobalRepository repo;

  NoteSetupBloc(this.repo);

  void onCreateNote(NoteSetupModel noteSetupModel,
      {bool createArchived = false}) {
    var newNote = Note.fromSetupModel(noteSetupModel, archived: createArchived);
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
