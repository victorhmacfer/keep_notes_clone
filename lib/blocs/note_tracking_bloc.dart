import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/note_setup_model.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/viewmodels/archive_view_model.dart';
import 'package:keep_notes_clone/viewmodels/home_view_model.dart';
import 'package:keep_notes_clone/viewmodels/label_view_model.dart';
import 'package:keep_notes_clone/viewmodels/note_labeling_view_model.dart';
import 'package:keep_notes_clone/viewmodels/reminders_view_model.dart';
import 'package:keep_notes_clone/viewmodels/search_result_view_model.dart';
import 'package:keep_notes_clone/viewmodels/trash_view_model.dart';
import 'package:rxdart/subjects.dart';

import 'package:keep_notes_clone/main.dart';

class NoteTrackingBloc {
  List<Label> _lastLabelsEmitted = [];
  List<Note> _lastNotesEmitted = [];

  NoteRepository noteRepo;

  final _notesBS = BehaviorSubject<List<Note>>();

  final _noteLabelingViewModelBS = BehaviorSubject<NoteLabelingViewModel>();

  final _labelFilteredNotesBS = BehaviorSubject<List<Note>>();

  final _labelScreenRequestBS = BehaviorSubject<Label>();

  final _searchScreenNoteColorRequestBS = BehaviorSubject<NoteColor>();

  final _searchResultViewModelBS = BehaviorSubject<SearchResultViewModel>();

  static SendPort uiSendPort;

  static void androidAlarmManagerCallback() {
    FlutterRingtonePlayer.playNotification();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  StreamSubscription _portSubscription;

  NoteTrackingBloc() {
    noteRepo = NoteRepository();

    noteRepo.allLabels.listen((labelList) {
      _lastLabelsEmitted = _sortLabelsAlphabetically(labelList);
      _noteLabelingViewModelBS.add(NoteLabelingViewModel(false, labelList));
    });

    noteRepo.notes.listen((noteList) {
      _lastNotesEmitted = noteList;
      _notesBS.add(noteList);
    });

    _labelScreenRequestBS.stream.listen(_applyDrawerLabelFilterWithNewLabel);

    _searchScreenNoteColorRequestBS.stream
        .listen(_filterNotesWithNoteColorAndDropIntoStream);

    _portSubscription = port.listen((_) {
      _notesBS.add(_lastNotesEmitted);
    });

    _notesBS.listen((allNotes) {
      _updateDrawerLabelFilterStream(allNotes);
      _tryToRefreshNoteColorSearchRequest();
    });
  }

  StreamSink<Label> get labelScreenRequestSink => _labelScreenRequestBS.sink;

  StreamSink<NoteColor> get searchByNoteColorSink =>
      _searchScreenNoteColorRequestBS.sink;

  Stream<SearchResultViewModel> get searchResultViewModelStream =>
      _searchResultViewModelBS.stream;

  Stream<List<int>> get noteColorsAlreadyUsedStream =>
      _allNotesStream.map(_filterNoteColorsAlreadyUsed);

  Stream<List<Label>> get sortedLabelsStream =>
      noteRepo.allLabels.map(_sortLabelsAlphabetically);

  Stream<NoteLabelingViewModel> get noteLabelingViewModelStream =>
      _noteLabelingViewModelBS.stream;

  Stream<HomeViewModel> get homeViewModelStream =>
      _allNotesStream.map((notes) => HomeViewModel(notes));

  Stream<RemindersViewModel> get remindersViewModelStream =>
      _allNotesStream.map((notes) => RemindersViewModel(notes));

  Stream<ArchiveViewModel> get archiveViewModelStream =>
      _allNotesStream.map((notes) => ArchiveViewModel(notes));

  Stream<TrashViewModel> get trashViewModelStream =>
      _allNotesStream.map((notes) => TrashViewModel(notes));

  Stream<LabelViewModel> get labelViewModelStream =>
      _labelFilteredNotesBS.stream.map((notes) => LabelViewModel(notes));

  void onCreateNote(NoteSetupModel noteSetupModel,
      {bool createArchived = false}) {
    var newNote = Note.fromSetupModel(noteSetupModel, archived: createArchived);
    noteRepo.addNote(newNote);
  }

  // Will reference a stand-alone table that stores only ids.
  // This is just for storing the AUTO INCREMENTED (therefore unused) id
  // and create an alarm with it.
  // Cannot be linked to notes because at the time I call this, the note
  // may not exist.. so I cant pass the note here as an argument.
  Future<int> addReminderAlarm() async {
    return noteRepo.addReminderAlarm();
  }

  void onNoteChanged(Note changedNote) {
    noteRepo.updateNote(changedNote);
  }

  void onCreateNewLabel(String text) async {
    var labelExists = await _labelAlreadyExists(text);
    if (labelExists == false) {
      noteRepo.addLabel(Label(name: text));
    }
  }

  void onLabelEdited(Label changedLabel) {
    noteRepo.updateLabel(changedLabel);
  }

  void onDeleteLabel(Label label) {
    noteRepo.deleteLabel(label);
  }

  void onDeleteNoteForever(Note noteForPermanentDeletion) {
    noteRepo.deleteNote(noteForPermanentDeletion);
  }

  Future<bool> _labelAlreadyExists(String text) async {
    if (_lastLabelsEmitted.isEmpty) return false;

    return _lastLabelsEmitted.map((lab) => lab.name).contains(text);
  }

  Future<Label> onCreateLabelInsideNote(String text) async {
    // no need to check for existence because this is only called
    // by create label button, which only exists if label text does not exist.
    // FIXME: but this is a dependency on implementation..

    var createdLabel = Label(name: text);
    var labelId = await noteRepo.addLabel(createdLabel);
    createdLabel.id = labelId;
    return createdLabel;
  }

  void onSearchLabel(String substring) {
    if (substring.isEmpty) {
      _noteLabelingViewModelBS
          .add(NoteLabelingViewModel(false, _lastLabelsEmitted));
    }

    List<Label> results = [];
    var foundExact = false;
    for (var label in _lastLabelsEmitted) {
      if (label.name.contains(substring)) {
        results.add(label);
        if (label.name == substring) {
          foundExact = true;
        }
      }
    }
    _noteLabelingViewModelBS.add(NoteLabelingViewModel(foundExact, results));
  }

  void resetLabelSearch() {
    _noteLabelingViewModelBS
        .add(NoteLabelingViewModel(false, _lastLabelsEmitted));
  }

  Stream<List<Note>> get _allNotesStream => _notesBS.stream;

  void _applyDrawerLabelFilterWithNewLabel(Label theLabel) {
    var filteredNotes = _filterNotesWithLabel(theLabel, _lastNotesEmitted);

    _labelFilteredNotesBS.add(filteredNotes);
  }

  void _updateDrawerLabelFilterStream(List<Note> allNotes) {
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

  void _filterNotesWithNoteColorAndDropIntoStream(NoteColor noteColor) {
    var currentNotes = _notesBS.value ?? [];
    var filteredNotes = currentNotes
        .where((note) => note.colorIndex == noteColor.index)
        .toList();

    var noteColorSearchResult = SearchResultViewModel(filteredNotes);

    _searchResultViewModelBS.add(noteColorSearchResult);
  }

  void _tryToRefreshNoteColorSearchRequest() {
    if (_searchScreenNoteColorRequestBS.hasValue) {
      _searchScreenNoteColorRequestBS
          .add(_searchScreenNoteColorRequestBS.value);
    }
  }

  List<int> _filterNoteColorsAlreadyUsed(List<Note> notes) {
    Set<int> noteColors = {};

    notes.forEach((n) {
      noteColors.add(n.colorIndex);
    });

    return List<int>.from(noteColors)..sort();
  }

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  void dispose() {
    _notesBS.close();
    _noteLabelingViewModelBS.close();
    _labelFilteredNotesBS.close();
    _labelScreenRequestBS.close();
    _searchScreenNoteColorRequestBS.close();
    _searchResultViewModelBS.close();
    _portSubscription.cancel();
  }
}
