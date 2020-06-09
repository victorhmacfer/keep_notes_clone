import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/models/note.dart';

class NoteEditingChangeNotifier with ChangeNotifier {
  int _selectedColorIndex;
  final TextEditingController titleController;
  final TextEditingController textController;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

  bool _isPinned;

  Note noteBeingEdited;

  List<Label> futureLabels;

  NoteEditingChangeNotifier(Note note)
      : _selectedColorIndex = note.colorIndex,
        titleController = TextEditingController(text: note.title),
        textController = TextEditingController(text: note.text),
        _isPinned = note.pinned,
        futureLabels = List.from(note.labels),
        noteBeingEdited = note;

  bool get isPinned => _isPinned;

  void pinNote() {
    _isPinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _isPinned = false;
    notifyListeners();
  }

  void checkLabel(Label label) {
    futureLabels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    futureLabels.remove(label);
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
