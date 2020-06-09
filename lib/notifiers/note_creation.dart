import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class NoteCreationChangeNotifier with ChangeNotifier {
  int _selectedColorIndex = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

  bool _isPinned = false;

  List<Label> _futureLabels = [];

  List<Label> get futureLabels => List.unmodifiable(_futureLabels);

  void checkLabel(Label label) {
    _futureLabels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    _futureLabels.remove(label);
    notifyListeners();
  }


  bool get isPinned => _isPinned;

  void pinNote() {
    _isPinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _isPinned = false;
    notifyListeners();
  }

  int get selectedColorIndex => _selectedColorIndex;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_selectedColorIndex);

  set selectedColorIndex(int newValue) {
    _selectedColorIndex = newValue;
    notifyListeners();
  }

  bool get leftBottomSheetOpen => _leftBottomSheetOpen;
  bool get rightBottomSheetOpen => _rightBottomSheetOpen;

  bool shouldManuallyCloseLeftSheet;
  bool shouldManuallyCloseRightSheet;

  void openLeftBottomSheet() {
    closeRightBottomSheet();
    _leftBottomSheetOpen = true;
  }

  void closeLeftBottomSheet() {
    if (leftBottomSheetOpen) {
      _leftBottomSheetOpen = false;
      if (leftBottomSheetController != null && shouldManuallyCloseLeftSheet) {
        leftBottomSheetController.close();
      }
    }
  }

  void openRightBottomSheet() {
    closeLeftBottomSheet();
    _rightBottomSheetOpen = true;
  }

  void closeRightBottomSheet() {
    if (rightBottomSheetOpen) {
      _rightBottomSheetOpen = false;
      if (rightBottomSheetController != null && shouldManuallyCloseRightSheet) {
        rightBottomSheetController.close();
      }
    }
  }
}
