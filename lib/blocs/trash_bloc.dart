import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/viewmodels/trash_view_model.dart';
import 'package:rxdart/subjects.dart';

class TrashBloc implements NoteChangerBloc {
  final GlobalRepository repo;

  final _notesBS = BehaviorSubject<List<Note>>();

  TrashBloc(this.repo) {
    repo.notes.listen((notes) {
      _notesBS.add(notes);
    });
  }

  Stream<TrashViewModel> get trashViewModelStream =>
      _notesBS.stream.map((notes) => TrashViewModel(notes));

  void manyNotesChanged(List<Note> changedNotes) {
    repo.updateManyNotes(changedNotes);
  }

  void emptyTrash(List<Note> trashNotes) {
    repo.deleteManyNotes(trashNotes);
  }
}
