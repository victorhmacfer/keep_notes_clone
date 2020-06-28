class Label {
  int id;
  String name;

  Label({this.id, this.name});

  factory Label.fromMap(Map<String, dynamic> labelMap) {
    return Label(
      id: labelMap['id'],
      name: labelMap['name'],
    );
  }
}
