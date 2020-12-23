import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/repository/repository.dart';
import 'package:keep_notes_clone/viewmodels/note_labeling_view_model.dart';
import 'package:rxdart/subjects.dart';

class NoteLabelingBloc {
  final GlobalRepository repo;

  final _sortedLabelsBS = BehaviorSubject<List<Label>>();

  final _noteLabelingViewModelBS = BehaviorSubject<NoteLabelingViewModel>();

  NoteLabelingBloc(this.repo) {
    repo.allLabels.listen((labelList) {
      _sortedLabelsBS.add(_sortLabelsAlphabetically(labelList));
    });

    _sortedLabelsBS.listen((sortedLabels) {
      _noteLabelingViewModelBS.add(NoteLabelingViewModel(false, sortedLabels));
    });
  }

  Stream<NoteLabelingViewModel> get noteLabelingViewModelStream =>
      _noteLabelingViewModelBS.stream;

  Future<Label> onCreateLabelInsideNote(String text) async {
    // no need to check for existence because this is only called
    // by create label button, which only exists if label text does not exist.
    // FIXME: but this is a dependency on implementation..

    var createdLabel = Label(name: text);
    var labelId = await repo.addLabel(createdLabel);
    createdLabel.id = labelId;
    return createdLabel;
  }

  void resetLabelNameSearch() {
    var lastLabelsEmitted = _sortedLabelsBS.value ?? [];
    _noteLabelingViewModelBS
        .add(NoteLabelingViewModel(false, lastLabelsEmitted));
  }

  void onSearchLabelName(String substring) {
    var lastLabelsEmitted = _sortedLabelsBS.value ?? [];

    if (substring.isEmpty) {
      _noteLabelingViewModelBS
          .add(NoteLabelingViewModel(false, lastLabelsEmitted));
    }

    List<Label> results = [];
    var foundExact = false;
    for (var label in lastLabelsEmitted) {
      if (label.name.contains(substring)) {
        results.add(label);
        if (label.name == substring) {
          foundExact = true;
        }
      }
    }
    _noteLabelingViewModelBS.add(NoteLabelingViewModel(foundExact, results));
  }

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  void dispose() {
    _sortedLabelsBS.close();
    _noteLabelingViewModelBS.close();
  }
}
