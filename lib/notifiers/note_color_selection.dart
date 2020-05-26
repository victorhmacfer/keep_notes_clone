import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';

class NoteColorSelection with ChangeNotifier {
  int _selectedColorIndex = 0;

  final List<NoteColor> _noteColors = [
    NoteColor.white,
    NoteColor.red,
    NoteColor.orange,
    NoteColor.yellow,
    NoteColor.green,
    NoteColor.lightBlue,
    NoteColor.mediumBlue,
    NoteColor.darkBlue,
    NoteColor.purple,
    NoteColor.pink,
    NoteColor.brown,
    NoteColor.grey,
  ];

  int get selectedColorIndex => _selectedColorIndex;

  NoteColor get selectedColor => _noteColors[_selectedColorIndex];

  set selectedColorIndex(int newValue) {
    _selectedColorIndex = newValue;
    notifyListeners();
  }
}
