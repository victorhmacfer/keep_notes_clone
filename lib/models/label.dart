import 'package:keep_notes_clone/models/note.dart';

class Label {
  String text;

  List<Note> _notes = [];

  Label({this.text});

  List<Note> get notes => _notes;

  void addNote(Note n) {
    _notes.add(n);
  }
}
