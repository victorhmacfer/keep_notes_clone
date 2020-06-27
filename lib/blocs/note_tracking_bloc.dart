import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/label_filtered_notes_container.dart';
import 'package:keep_notes_clone/models/label_search_result.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/pinned_unpinned_notes.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:rxdart/subjects.dart';

class NoteTrackingBloc {
  List<Label> _lastAllLabelsEmitted = [];
  List<Note> _lastAllNotesEmitted = [];

  NoteRepository noteRepo;

  final _notesBS = BehaviorSubject<List<Note>>();
  final _labelsBS = BehaviorSubject<List<Label>>();

  final _labelSearchBS = BehaviorSubject<LabelSearchResult>();

  final _labelFilteredNotesBS = BehaviorSubject<List<Note>>();

  final _labelForFilteringNotesBS = BehaviorSubject<Label>();

  NoteTrackingBloc() {
    noteRepo = NoteRepository();

    noteRepo.allLabels.listen((labelList) {
      _lastAllLabelsEmitted = labelList;
    });

    noteRepo.notes.listen((noteList) {
      _lastAllNotesEmitted = noteList;
    });

    _labelForFilteringNotesBS.stream
        .listen(_filterNotesForLabelAndDropIntoStream);
  }

  StreamSink<Label> get labelFilteringSink => _labelForFilteringNotesBS.sink;

  Stream<List<Label>> get allLabelsStream =>
      noteRepo.allLabels.map(_sortLabelsAlphabetically);

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  Stream<LabelSearchResult> get labelSearchResultStream =>
      _labelSearchBS.stream;

  Stream<List<Note>> get noteListStream => noteRepo.notes;

  Stream<PinnedUnpinnedNotes> get pinnedUnpinnedNoteListsStream =>
      _notArchivedNotDeletedNoteListStream
          .map((notes) => PinnedUnpinnedNotes(notes));

  Stream<List<Note>> get archivedNoteListStream =>
      noteListStream.map(_filterArchivedNotes);

  Stream<List<Note>> get deletedNoteListStream =>
      noteListStream.map(_filterDeletedNotes);

  Stream<LabelFilteredNotesContainer> get labelFilteredNotesContainerStream =>
      _labelFilteredNotDeletedNotesStream
          .map((notes) => LabelFilteredNotesContainer(notes));

  void onCreateNewNote(
      {String title,
      String text,
      int colorIndex,
      bool pinned,
      DateTime reminderTime,
      @required DateTime lastEdited,
      bool archived,
      List<Label> labels}) {
    if (pinned) {
      assert(archived == false,
          'Note cannot be created as both pinned and archived');
    }

    var newNote = Note(
        title: title,
        text: text,
        colorIndex: colorIndex,
        pinned: pinned,
        reminderTime: reminderTime,
        lastEdited: lastEdited,
        archived: archived,
        labels: labels);

    noteRepo.addNote(newNote);
  }

  void onNoteChanged(Note changedNote) {
    noteRepo.updateNote(changedNote);

    //TODO: complete this part
    if (_labelForFilteringNotesBS.hasValue) {
      var lastLabelFiltered = _labelForFilteringNotesBS.value;
      _filterNotesForLabelAndDropIntoStream(lastLabelFiltered);
    }
  }

  void onCreateNewLabel(String text) async {
    var labelExists = await _labelAlreadyExists(text);
    if (labelExists) {
      return;
    }
    noteRepo.addLabel(Label(name: text));
  }

  Future<bool> _labelAlreadyExists(String text) async {
    if (_lastAllLabelsEmitted == null) return false;

    return _lastAllLabelsEmitted.map((lab) => lab.name).contains(text);
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
      _labelSearchBS.add(LabelSearchResult(false, _lastAllLabelsEmitted));
    }

    List<Label> results = [];
    var foundExact = false;
    for (Label label in _lastAllLabelsEmitted) {
      if (label.name.contains(substring)) {
        results.add(label);
        if (label.name == substring) {
          foundExact = true;
        }
      }
    }
    _labelSearchBS.add(LabelSearchResult(foundExact, results));
  }

  void onResetLabelSearch() {
    _labelSearchBS.add(LabelSearchResult(false, _lastAllLabelsEmitted));
  }

  void _filterNotesForLabelAndDropIntoStream(Label theLabel) {
    var filteredNotes =
        _lastAllNotesEmitted.where((n) => n.labels.contains(theLabel)).toList();

    _labelFilteredNotesBS.add(filteredNotes);
  }

  List<Note> _filterArchivedNotes(List<Note> input) {
    return input.where((note) => note.archived).toList();
  }

  List<Note> _filterUnarchivedNotes(List<Note> input) {
    return input.where((note) => note.archived == false).toList();
  }

  List<Note> _filterDeletedNotes(List<Note> input) {
    return input.where((note) => note.deleted).toList();
  }

  List<Note> _filterNotDeletedNotes(List<Note> input) {
    return input.where((note) => note.deleted == false).toList();
  }

  Stream<List<Note>> get _unarchivedNoteListStream =>
      noteListStream.map(_filterUnarchivedNotes);

  Stream<List<Note>> get _notArchivedNotDeletedNoteListStream =>
      _unarchivedNoteListStream.map(_filterNotDeletedNotes);

  Stream<List<Note>> get _labelFilteredNotDeletedNotesStream =>
      _labelFilteredNotesBS.stream.map(_filterNotDeletedNotes);

  void dispose() {
    _notesBS.close();
    _labelsBS.close();
    _labelSearchBS.close();
    _labelFilteredNotesBS.close();
    _labelForFilteringNotesBS.close();
  }
}
