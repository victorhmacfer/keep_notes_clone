import 'package:flutter/foundation.dart';

class Reminder {
  final int _id;
  DateTime time;

  Reminder({@required int id, @required this.time}) : _id = id;

  int get id => _id;

  bool get expired => time.isBefore(DateTime.now());
}
