import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class SearchLandingPageViewModel {
  List<Label> _sortedLabelsInUse;

  List<NoteColor> _noteColorsInUse;

  List<Label> get sortedLabelsInUse => List.unmodifiable(_sortedLabelsInUse);

  List<NoteColor> get noteColorsInUse => List.unmodifiable(_noteColorsInUse);

  SearchLandingPageViewModel(List<Note> notes) {
    Set<NoteColor> noteColors = {};
    Set<Label> labels = {};

    for (var note in notes) {
      noteColors.add(NoteColor.getNoteColorFromIndex(note.colorIndex));
      for (var lab in note.labels) {
        labels.add(lab);
      }
    }

    _noteColorsInUse = noteColors.toList()
      ..sort((nc1, nc2) => nc1.index.compareTo(nc2.index));

    _sortedLabelsInUse = labels.toList()
      ..sort((lab1, lab2) => lab1.name.compareTo(lab2.name));
  }
}
