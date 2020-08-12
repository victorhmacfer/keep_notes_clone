import 'dart:async';

import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/viewmodels/label_view_model.dart';
import 'package:rxdart/subjects.dart';

class LabelScreenBloc implements NoteChangerBloc, LabelDeleterBloc {
  final NoteRepository noteRepo;

  final _notesBS = BehaviorSubject<List<Note>>();
  List<Label> _currentLabelsSorted = [];
  final _labelScreenRequestBS = BehaviorSubject<Label>();
  final _labelFilteredNotesBS = BehaviorSubject<List<Note>>();

  LabelScreenBloc(this.noteRepo) {
    noteRepo.notes.listen((noteList) {
      _notesBS.add(noteList);
    });

    noteRepo.allLabels.listen((labelList) {
      _currentLabelsSorted = _sortLabelsAlphabetically(labelList);
    });

    _notesBS.listen((notes) {
      _updateLabelFilteredNotesAfterChange(notes);
    });

    _labelScreenRequestBS.stream.listen(_filterWithNewLabelAndStream);
  }

  StreamSink<Label> get labelScreenRequestSink => _labelScreenRequestBS.sink;

  Stream<LabelViewModel> get labelViewModelStream =>
      _labelFilteredNotesBS.stream.map((notes) => LabelViewModel(notes));

  void manyNotesChanged(List<Note> changedNotes) {
    noteRepo.updateManyNotes(changedNotes);
  }

  void onDeleteLabel(Label label) {
    noteRepo.deleteLabel(label);
  }

  bool renameLabel(Label label, String newName) {
    if (newName?.isEmpty ?? true) {
      return false;
    }

    for (var lab in _currentLabelsSorted) {
      if (lab.name == newName) {
        return false;
      }
    }
    var renamedLabel = Label(id: label.id, name: newName);

    noteRepo.updateLabel(renamedLabel);
    return true;
  }

  void _filterWithNewLabelAndStream(Label theLabel) {
    var lastNotesEmitted = _notesBS.value ?? [];
    var filteredNotes = _filterNotesWithLabel(theLabel, lastNotesEmitted);

    _labelFilteredNotesBS.add(filteredNotes);
  }

  void _updateLabelFilteredNotesAfterChange(List<Note> allNotes) {
    var hasEverFilteredByThisLabelInDrawer = _labelScreenRequestBS.hasValue;

    if (hasEverFilteredByThisLabelInDrawer) {
      var filteredNotes =
          _filterNotesWithLabel(_labelScreenRequestBS.value, allNotes);
      _labelFilteredNotesBS.add(filteredNotes);
    }
  }

  List<Note> _filterNotesWithLabel(Label theLabel, List<Note> input) {
    return input
        .where((n) => n.labels.any((lab) => lab.id == theLabel.id))
        .toList();
  }

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  void dispose() {
    _labelScreenRequestBS.close();
    _labelFilteredNotesBS.close();
    _notesBS.close();
  }
}
