import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/models/note.dart';

class NoteCreateEditSharedState with ChangeNotifier {
  // int _selectedColorIndex = 0;

  // final titleController = TextEditingController();
  // final textController = TextEditingController();
  int _selectedColorIndex;
  final TextEditingController titleController;
  final TextEditingController textController;

  // final titleFocusNode = FocusNode();
  // final textFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

  // bool _isPinned = false;
  bool _isPinned;

  NoteCreateEditSharedState()
      : _selectedColorIndex = 0,
        titleController = TextEditingController(),
        textController = TextEditingController(),
        _isPinned = false;

  NoteCreateEditSharedState.fromNote(Note note)
      : _selectedColorIndex = note.colorIndex,
        titleController = TextEditingController(text: note.title),
        textController = TextEditingController(text: note.text),
        _isPinned = note.pinned;

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
      if (rightBottomSheetController != null)
        rightBottomSheetController.close();
    }
  }
}
