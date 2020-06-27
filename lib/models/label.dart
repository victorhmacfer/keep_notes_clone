import 'package:keep_notes_clone/models/note.dart';

class Label {
  int id;
  String name;

  List<Note> _notes = [];

  Label({this.id, this.name});


  factory Label.fromMap(Map<String, dynamic> labelMap) {

    return Label(
      id: labelMap['id'],
      name: labelMap['name'],
    );
  }







  List<Note> get notes => _notes;

  void addNote(Note n) {
    _notes.add(n);
  }
}
