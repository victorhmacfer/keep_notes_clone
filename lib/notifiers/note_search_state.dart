import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/viewmodels/search_result_view_model.dart';

class NoteSearchStateNotifier with ChangeNotifier {
  bool _showingResult;
  String _resultCategory;

  // this is coupled to showing result..
  // should be non-null the first time showingResult has reached true.
  // should go back to null once showingResult is false again.
  SearchResultViewModel lastResultViewModel;

  TextEditingController searchController = TextEditingController();

  String _lastNameSearched;

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

  bool tryFullClear(String newNameSearched) {
    var lastNameLength = _lastNameSearched?.length ?? 0;

    // pressed backspace
    if (newNameSearched.length == (lastNameLength - 1)) {
      lastResultViewModel = null;
      showingResult = false;
      _lastNameSearched = null;
      searchController.clear();
      return true;
    }
    _lastNameSearched = newNameSearched;
    return false;
  }
}
