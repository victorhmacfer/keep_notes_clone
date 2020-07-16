import 'package:flutter/material.dart';

class NoteSearchStateNotifier with ChangeNotifier {
  bool _showingResult;

  NoteSearchStateNotifier() : _showingResult = false;

  bool get showingResult => _showingResult;

  set showingResult(bool value) {
    _showingResult = value;
    notifyListeners();
  }
}
