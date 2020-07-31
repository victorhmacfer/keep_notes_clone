import 'package:flutter/material.dart';

enum NoteCardMode { extended, small }

class NoteCardModeSelection with ChangeNotifier {
  //TODO: should be initialized to what the user used last time...
  // for now it will always start in small mode.
  NoteCardMode _mode = NoteCardMode.small;

  NoteCardMode get mode => _mode;

  void switchTo(NoteCardMode newMode) {
    _mode = newMode;
    notifyListeners();
  }
}
