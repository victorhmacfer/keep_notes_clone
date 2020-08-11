import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';

abstract class NoteChangerBloc {
  void manyNotesChanged(List<Note> changedNotes);
}

abstract class LabelDeleterBloc {
  void onDeleteLabel(Label label);
}
