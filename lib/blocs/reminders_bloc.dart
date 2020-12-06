import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/viewmodels/reminders_view_model.dart';
import 'package:rxdart/subjects.dart';

class RemindersBloc implements NoteChangerBloc {
  final GlobalRepository repo;

  final _notesBS = BehaviorSubject<List<Note>>();

  RemindersBloc(this.repo) {
    repo.notes.listen((notes) {
      _notesBS.add(notes);
    });
  }

  Stream<RemindersViewModel> get remindersViewModelStream =>
      _notesBS.stream.map((notes) => RemindersViewModel(notes));

  void manyNotesChanged(List<Note> changedNotes) {
    repo.updateManyNotes(changedNotes);
  }
}