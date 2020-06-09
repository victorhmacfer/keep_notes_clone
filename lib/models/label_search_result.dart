import 'package:keep_notes_clone/models/label.dart';

class LabelSearchResult {
  final List<Label> labels;

  final bool foundExactMatch;

  LabelSearchResult(this.foundExactMatch, this.labels);
}
