import 'package:equatable/equatable.dart';

//TODO: maybe I should make the id required.. so I cant ever have
// a Label object without an id.. since the id is used in equality comparison
class Label extends Equatable {
  int id;
  final String name;

  Label({this.id, this.name});

  factory Label.fromMap(Map<String, dynamic> labelMap) {
    return Label(
      id: labelMap['id'],
      name: labelMap['name'],
    );
  }

  @override
  List<Object> get props => [id];
}
