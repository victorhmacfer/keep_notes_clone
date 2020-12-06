import 'dart:async';

import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/repository/note_repository.dart';
import 'package:rxdart/subjects.dart';

class DrawerBloc {
  final GlobalRepository repo;

  final _sortedLabelsBS = BehaviorSubject<List<Label>>();

  DrawerBloc(this.repo) {
    repo.allLabels.listen((labelList) {
      _sortedLabelsBS.add(_sortLabelsAlphabetically(labelList));
    });
  }

  Stream<List<Label>> get sortedLabelsStream => _sortedLabelsBS.stream;

  List<Label> _sortLabelsAlphabetically(List<Label> input) {
    var sorted = List<Label>.from(input)
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  void dispose() {
    _sortedLabelsBS.close();
  }
}
