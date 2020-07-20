import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class NoteSearchStateNotifier with ChangeNotifier {
  bool _showingResult;
  String _resultCategory;

  NoteSearchStateNotifier() : _showingResult = false;

  bool get showingResult => _showingResult;

  String get resultCategory => _resultCategory;

  void setResultCategoryFromNoteColor(NoteColor noteColor) {
    _resultCategory = noteColor.colorDescription;
    notifyListeners();
  }

  void setResultCategoryFromLabel(Label label) {
    _resultCategory = label.name;
    notifyListeners();
  }

  set showingResult(bool value) {
    _showingResult = value;
    notifyListeners();
  }
}
