import 'package:flutter/material.dart';

class NoteSearchStateNotifier with ChangeNotifier {
  bool _searching;

  NoteSearchStateNotifier() : _searching = false;

  bool get searching => _searching;

  set searching(bool value) {
    _searching = value;
    notifyListeners();
  }
}
