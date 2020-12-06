import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/viewmodels/archive_view_model.dart';
import 'package:rxdart/subjects.dart';

class ArchiveBloc implements NoteChangerBloc {
  final GlobalRepository repo;

  final _notesBS = BehaviorSubject<List<Note>>();

  ArchiveBloc(this.repo) {
    repo.notes.listen((notes) {
      _notesBS.add(notes);
    });
  }

  Stream<ArchiveViewModel> get archiveViewModelStream =>
      _notesBS.stream.map((notes) => ArchiveViewModel(notes));

  void manyNotesChanged(List<Note> changedNotes) {
    repo.updateManyNotes(changedNotes);
  }
}
