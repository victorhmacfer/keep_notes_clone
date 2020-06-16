import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class NoteSetupScreenController with ChangeNotifier {
  final TextEditingController titleController;
  final TextEditingController textController;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  int _selectedColorIndex;

  bool _isPinned;

  List<Label> _futureLabels;

  Note _noteToBeDeleted;

  final bool _editing;

  NoteSetupScreenController()
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        _selectedColorIndex = 0,
        _isPinned = false,
        _editing = false,
        _futureLabels = [];

  NoteSetupScreenController.withLabel(Label label)
      : titleController = TextEditingController(),
        textController = TextEditingController(),
        _selectedColorIndex = 0,
        _isPinned = false,
        _editing = false,
        _futureLabels = [label];

  NoteSetupScreenController.fromNote(Note note)
      : titleController = TextEditingController(text: note.title),
        textController = TextEditingController(text: note.text),
        _selectedColorIndex = note.colorIndex,
        _isPinned = note.pinned,
        _editing = true,
        _futureLabels = List.from(note.labels),
        _noteToBeDeleted = note;

  int get selectedColorIndex => _selectedColorIndex;

  Note get noteToBeDeleted => _noteToBeDeleted;

  bool get editing => _editing;
  bool get notEditing => !editing;

  NoteColor get selectedColor =>
      NoteColor.getNoteColorFromIndex(_selectedColorIndex);

  set selectedColorIndex(int newValue) {
    _selectedColorIndex = newValue;
    notifyListeners();
  }

  bool get isPinned => _isPinned;

  List<Label> get futureLabels => List.unmodifiable(_futureLabels);

  void pinNote() {
    _isPinned = true;
    notifyListeners();
  }

  void unpinNote() {
    _isPinned = false;
    notifyListeners();
  }

  void checkLabel(Label label) {
    _futureLabels.add(label);
    notifyListeners();
  }

  void uncheckLabel(Label label) {
    _futureLabels.remove(label);
    notifyListeners();
  }

  // ===========================================================================
  // THIS IS TRASH DESIGN BUT IT HAS TO BE THIS WAY.. FRAMEWORK WONT LET ME
  // SEPARATE BOTTOMSHEET STUFF INTO ANOTHER NOTIFIER.. CANT GET ACCESS TO SOME
  // THINGS.. ITS ALL DUE TO THE WAY THE BOTTOM SHEET IS SHOWN...
  //  Scaffold.of(context).showBottomSheet(blabla)..  I need context to call
  // showBottomSheet()  and I cant create the notifier giving it the result of
  // Scaffold.of  because the notifier is created before the Scaffold exists.
  // So I cant encapsulate this bottomsheet mess into the notifier.. awful.
  // ===========================================================================

  PersistentBottomSheetController leftBottomSheetController;
  PersistentBottomSheetController rightBottomSheetController;

  bool _leftBottomSheetOpen = false;
  bool _rightBottomSheetOpen = false;

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
