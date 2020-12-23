import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/repository.dart';
import 'package:keep_notes_clone/viewmodels/home_view_model.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc implements NoteChangerBloc {
  final GlobalRepository repo;

  final _notesBS = BehaviorSubject<List<Note>>();

  HomeBloc(this.repo) {
    repo.notes.listen((notes) {
      _notesBS.add(notes);
    });
  }

  Future<bool> get initialized async => !(await _notesBS.isEmpty);

  Stream<List<Note>> get _allNotesStream => _notesBS.stream;

  Stream<HomeViewModel> get homeViewModelStream =>
      _allNotesStream.map((notes) => HomeViewModel(notes));


  // this method is expected to be called only after bloc has any notelist
  // already streamed
  Note getNoteWithAlarmId(int alarmId) {
    var notes = _notesBS.value ?? [];
    return notes.firstWhere((n) => n.reminder.id == alarmId);
  }

  void manyNotesChanged(List<Note> changedNotes) {
    repo.updateManyNotes(changedNotes);
  }

  void dispose() {
    _notesBS.close();
  }
}
