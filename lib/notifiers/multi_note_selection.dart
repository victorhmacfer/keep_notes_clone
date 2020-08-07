import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/note.dart';

class MultiNoteSelection with ChangeNotifier {
  bool active = false;

  List<Note> _selectedNotes = [];

  int get selectedCount => _selectedNotes.length;

  bool get inactive => !active;

  bool isSelected(Note note) => _selectedNotes.contains(note);

  void cancel() {
    active = false;
    _selectedNotes.clear();
    notifyListeners();
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
}
