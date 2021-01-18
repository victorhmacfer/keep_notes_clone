import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NoteCardMode { extended, small }

class NoteCardModeSelection with ChangeNotifier {
  
  // mode is stored in SharedPreferences with key 'notecard_mode'
  // value ==> true for small mode, false for extended mode.
  NoteCardMode _mode; 

  NoteCardModeSelection() {
    _loadModeFromPrefs();
  }

  NoteCardMode get mode => _mode;

  void switchTo(NoteCardMode newMode) {
    _mode = newMode;
    _setModeInPrefs();
    notifyListeners();
  }

  _loadModeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // if value has never been set, mode is set and loaded as 'small'
    _mode = (prefs.getBool('notecard_mode') ?? true)
        ? NoteCardMode.small
        : NoteCardMode.extended;
  }

  _setModeInPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(
        'notecard_mode', (_mode == NoteCardMode.small) ? true : false);
  }
}
