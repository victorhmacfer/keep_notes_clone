import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';

enum SearchRequestType { label, noteColor }

abstract class SearchRequestViewModel {
  SearchRequestType get type;
  Label get label;
  NoteColor get noteColor;
}

class LabelSearchRequestViewModel implements SearchRequestViewModel {
  final Label label;

  LabelSearchRequestViewModel(this.label);

  SearchRequestType get type => SearchRequestType.label;

  NoteColor get noteColor => null;
}

class NoteColorSearchRequestViewModel implements SearchRequestViewModel {
  final NoteColor noteColor;

  NoteColorSearchRequestViewModel(this.noteColor);

  SearchRequestType get type => SearchRequestType.noteColor;

  Label get label => null;
}
