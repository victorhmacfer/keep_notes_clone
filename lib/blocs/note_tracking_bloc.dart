import 'dart:async';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:rxdart/subjects.dart';

class NoteTrackingBloc {
  // FIXME: later it will be initialized from the DB.
  List<Note> _notes = [];

  List<Label> _labels = [];

  final _notesBS = BehaviorSubject<List<Note>>();
  final _labelsBS = BehaviorSubject<List<Label>>();

  Stream<List<Label>> get labelListStream => _labelsBS.stream;

  Stream<List<Note>> get noteListStream => _notesBS.stream;

  Stream<List<List<Note>>> get pinnedUnpinnedNoteListsStream =>
      _notArchivedNotDeletedNoteListStream.map(_splitIntoPinnedAndUnpinned);

  Stream<List<Note>> get archivedNoteListStream =>
      noteListStream.map(_filterArchivedNotes);

  Stream<List<Note>> get deletedNoteListStream =>
      noteListStream.map(_filterDeletedNotes);

  Stream<List<Note>> get _unarchivedNoteListStream =>
      noteListStream.map(_filterUnarchivedNotes);

  Stream<List<Note>> get _notArchivedNotDeletedNoteListStream =>
      _unarchivedNoteListStream.map(_filterNotDeletedNotes);

  

  void onCreateNewNote(
      String title, String text, int colorIndex, bool pinned, bool archived, {List<Label> labels}) {
    if (pinned) {
      assert(archived == false,
          'Note cannot be created as both pinned and archived');
    }

    var newNote = Note(
        title: title,
        text: text,
        colorIndex: colorIndex,
        pinned: pinned,
        archived: archived,
        labels: labels);

    _notes.add(newNote);
    _notesBS.add(_notes);
  }

  void onNoteEdited() {
    _notesBS.add(_notes);
  }

  void onNoteArchived() {
    _notesBS.add(_notes);
  }

  void onNoteDeleted() {
    _notesBS.add(_notes);
  }

  List<List<Note>> _splitIntoPinnedAndUnpinned(List<Note> input) {
    List<List<Note>> output = [];
    List<Note> pinned = [];
    List<Note> unpinned = [];

    for (var note in input) {
      if (note.pinned) {
        pinned.add(note);
      } else {
        unpinned.add(note);
      }
    }
    output.add(pinned);
    output.add(unpinned);
    return output;
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

  void onCreateNewLabel(String text) {
    
    //FIXME: checking for label existence...this is temporary.
    if (_labels.map((lab) => lab.text).contains(text)) return;

    _labels.add(Label(text: text));
    _labels.sort((a, b) => a.text.compareTo(b.text));
    _labelsBS.add(_labels);
  }

  void dispose() {
    _notesBS.close();
    _labelsBS.close();
  }
}
