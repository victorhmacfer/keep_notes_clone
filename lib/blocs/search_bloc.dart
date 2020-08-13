import 'dart:async';

import 'package:keep_notes_clone/blocs/bloc_base.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/viewmodels/search_landing_page_view_model.dart';
import 'package:keep_notes_clone/viewmodels/search_result_view_model.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc implements NoteChangerBloc {
  final NoteRepository noteRepo;

  final _notesBS = BehaviorSubject<List<Note>>();

  final _landingPageViewModelBS = BehaviorSubject<SearchLandingPageViewModel>();

  final _searchResultViewModelBS = BehaviorSubject<SearchResultViewModel>();

  final _labelSearchRequestBS = BehaviorSubject<Label>();

  final _noteColorSearchRequestBS = BehaviorSubject<NoteColor>();

  SearchBloc(this.noteRepo) {
    noteRepo.notes.listen((notes) {
      _notesBS.add(notes);
    });

    _notesBS.listen((notes) {
      _refreshNoteColorSearchRequest(); // FIXME: this call creates a bug
      _landingPageViewModelBS.add(SearchLandingPageViewModel(notes));
    });

    _noteColorSearchRequestBS.stream
        .listen(_filterNotesWithNoteColorAndStreamSearchResult);

    _labelSearchRequestBS.stream
        .listen(_filterNotesWithLabelAndStreamSearchResult);
  }

  Stream<SearchLandingPageViewModel> get searchLandingPageViewModelStream =>
      _landingPageViewModelBS.stream;

  Stream<SearchResultViewModel> get searchResultViewModelStream =>
      _searchResultViewModelBS.stream;

  StreamSink<Label> get searchByLabelSink => _labelSearchRequestBS.sink;

  StreamSink<NoteColor> get searchByNoteColorSink =>
      _noteColorSearchRequestBS.sink;

  void searchNotesWithSubstring(
      String substring, SearchResultViewModel categoryResult) {
    if (substring.isEmpty) {
      _landingPageViewModelBS
          .add(SearchLandingPageViewModel(_notesBS.value ?? []));
    } else {
      var notesToSearchIn = (categoryResult != null)
          ? categoryResult.all
          : (_notesBS.value ?? []);

      var filteredNotes =
          notesToSearchIn.where((n) => n.contains(substring)).toList();

      _searchResultViewModelBS.add(SearchResultViewModel(filteredNotes));
    }
  }

  void manyNotesChanged(List<Note> changedNotes) {
    noteRepo.updateManyNotes(changedNotes);
  }

  void _refreshNoteColorSearchRequest() {
    if (_noteColorSearchRequestBS.hasValue) {
      _noteColorSearchRequestBS.add(_noteColorSearchRequestBS.value);
    }
  }

  void _filterNotesWithNoteColorAndStreamSearchResult(NoteColor noteColor) {
    var currentNotes = _notesBS.value ?? [];
    var filteredNotes = currentNotes
        .where((note) => note.colorIndex == noteColor.index)
        .toList();

    var noteColorSearchResult = SearchResultViewModel(filteredNotes);

    _searchResultViewModelBS.add(noteColorSearchResult);
  }

  void _filterNotesWithLabelAndStreamSearchResult(Label label) {
    var currentNotes = _notesBS.value ?? [];
    var filteredNotes = currentNotes
        .where((n) => n.labels.any((lab) => lab.id == label.id))
        .toList();

    var labelSearchResult = SearchResultViewModel(filteredNotes);

    _searchResultViewModelBS.add(labelSearchResult);
  }

  void dispose() {
    _notesBS.close();
    _landingPageViewModelBS.close();
    _searchResultViewModelBS.close();
    _labelSearchRequestBS.close();
    _noteColorSearchRequestBS.close();
  }
}
