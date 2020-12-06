import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:rxdart/subjects.dart';

class EditLabelsBloc {
  final GlobalRepository repo;

  final _sortedLabelsBS = BehaviorSubject<List<Label>>();

  EditLabelsBloc(this.repo) {
    repo.allLabels.listen((labelList) {
      _sortedLabelsBS.add(_sortLabelsAlphabetically(labelList));
    });
  }

  Stream<List<Label>> get sortedLabelsStream => _sortedLabelsBS.stream;

  void onCreateNewLabel(String text) {
    var labelExists = _labelAlreadyExists(text);
    if (labelExists == false) {
      repo.addLabel(Label(name: text));
    }
  }

  void onDeleteLabel(Label label) {
    repo.deleteLabel(label);
  }

  bool renameLabel(Label label, String newName) {
    var currentLabels = _sortedLabelsBS.value ?? [];

    if (newName?.isEmpty ?? true) {
      return false;
    }

    for (var lab in currentLabels) {
      if (lab.name == newName) {
        return false;
      }
    }
    var renamedLabel = Label(id: label.id, name: newName);

    repo.updateLabel(renamedLabel);
    return true;
  }

  bool _labelAlreadyExists(String text) {
    var lastLabelsEmitted = _sortedLabelsBS.value ?? [];
    if (lastLabelsEmitted.isEmpty) return false;

    return lastLabelsEmitted.map((lab) => lab.name).contains(text);
  }

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  void dispose() {
    _sortedLabelsBS.close();
  }
}
