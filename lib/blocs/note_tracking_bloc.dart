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

  Stream<List<Note>> get noteListStream => _notesBS.stream;

  Stream<List<Note>> get archivedNoteListStream =>
      noteListStream.map(_filterArchivedNotes);

  Stream<List<Note>> get _unarchivedNoteListStream =>
      noteListStream.map(_filterUnarchivedNotes);

  Stream<List<List<Note>>> get pinnedUnpinnedNoteListsStream =>
      _unarchivedNoteListStream.map(_splitIntoPinnedAndUnpinned);

  Stream<List<Label>> get labelListStream => _labelsBS.stream;

  void onCreateNewNote(
      String title, String text, int colorIndex, bool pinned, bool archived) {
    if (pinned) {
      assert(archived == false,
          'Note cannot be created as both pinned and archived');
    }

    var newNote = Note(
        title: title,
        text: text,
        colorIndex: colorIndex,
        pinned: pinned,
        archived: archived);

    _notes.add(newNote);
    _notesBS.add(_notes);
  }

  void onNoteEdited() {
    _notesBS.add(_notes);
  }

  void onNoteArchived() {
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

  void onCreateNewLabel(String text) {
    // TODO: check for label existence

    //FIXME: this is temporary..
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
