import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';

class NoteCreationSharedState with ChangeNotifier {
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

  final titleFocusNode = FocusNode();
  final textFocusNode = FocusNode();

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

  bool get leftBottomSheetOpen => _leftBottomSheetOpen;
  bool get rightBottomSheetOpen => _rightBottomSheetOpen;

  openLeftBottomSheet() {
    closeRightBottomSheet();
    _leftBottomSheetOpen = true;
  }

  closeLeftBottomSheet() {
    if (leftBottomSheetOpen) {
      _leftBottomSheetOpen = false;
      if (leftBottomSheetController != null) leftBottomSheetController.close();
    }
  }

  openRightBottomSheet() {
    closeLeftBottomSheet();
    _rightBottomSheetOpen = true;
  }

  closeRightBottomSheet() {
    if (rightBottomSheetOpen) {
      _rightBottomSheetOpen = false;
      if (rightBottomSheetController != null) rightBottomSheetController.close();
    }
  }

}
