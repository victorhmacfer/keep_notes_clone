import 'package:keep_notes_clone/models/label.dart';

class LabelNameSearchResult {
  final List<Label> labels;

  final bool foundExactMatch;

  LabelNameSearchResult(this.foundExactMatch, this.labels);
}
