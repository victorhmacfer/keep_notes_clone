import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';

class NoteColorSelection with ChangeNotifier {
  int _selectedColorIndex = 0;

  int get selectedColorIndex => _selectedColorIndex;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_selectedColorIndex);

  set selectedColorIndex(int newValue) {
    _selectedColorIndex = newValue;
    notifyListeners();
  }

  final titleController = TextEditingController();

  final textController = TextEditingController();
}
