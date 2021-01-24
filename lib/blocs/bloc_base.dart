import 'package:keep_notes_clone/models/note.dart';

abstract class NoteChangerBloc {
  void manyNotesChanged(List<Note> changedNotes);
}

abstract class LabelDeleterBloc {
  void deleteLabel();
}

abstract class NoteArchiverBloc {
  void archiveNote(Note note);
}
