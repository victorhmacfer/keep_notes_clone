import 'package:flutter/material.dart';

class DrawerScreenSelection with ChangeNotifier {
  int _selectedScreenIndex = 0;

  int get selectedScreenIndex => _selectedScreenIndex;

  void changeSelectedScreenToIndex(int screenIndex) {
    assert(screenIndex >= 0, 'Index for selected screen should be >= 0');
    _selectedScreenIndex = screenIndex;
    notifyListeners();
  }
}
