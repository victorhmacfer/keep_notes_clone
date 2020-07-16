import 'package:keep_notes_clone/models/label.dart';

class NoteLabelingViewModel {
  final List<Label> labels;

  final bool foundExactMatch;

  NoteLabelingViewModel(this.foundExactMatch, this.labels);
}
