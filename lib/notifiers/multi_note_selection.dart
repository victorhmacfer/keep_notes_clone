import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class MultiNoteSelection with ChangeNotifier {
  bool active = false;

  List<Note> _selectedNotes = [];

  int get selectedCount => _selectedNotes.length;

  List<Note> get selectedNotes => List.unmodifiable(_selectedNotes);

  bool get inactive => !active;

  bool isSelected(Note note) => _selectedNotes.contains(note);

  void Function() get pinOrUnpin => (willPin) ? _pin : _unpin;

  bool get willPin {
    for (var note in _selectedNotes) {
      if (note.pinned == false) {
        return true;
      }
    }
    return false;
  }

  void _pin() {
    _selectedNotes.forEach((n) {
      n.pinned = true;
    });
  }

  void _unpin() {
    _selectedNotes.forEach((n) {
      n.pinned = false;
    });
  }

  void cancel() {
    active = false;
    _selectedNotes.clear();
    notifyListeners();
  }

  void archive() {
    _selectedNotes.forEach((n) {
      n.archived = true;
    });
  }

  void delete() {
    _selectedNotes.forEach((n) {
      n.delete();
    });
  }

  void addNote(Note note) {
    if (inactive) {
      assert(selectedCount == 0);
      active = true;
    }
    _selectedNotes.add(note);
    notifyListeners();
  }

  void removeNote(Note note) {
    assert(selectedCount > 0);
    _selectedNotes.remove(note);
    if (selectedCount == 0) {
      active = false;
    }
    notifyListeners();
  }

  void toggleNote(Note note) {
    if (isSelected(note)) {
      removeNote(note);
    } else {
      addNote(note);
    }
  }

  void changeColorTo(NoteColor newColor) {
    _selectedNotes.forEach((note) {
      note.colorIndex = newColor.index;
    });
  }
}
