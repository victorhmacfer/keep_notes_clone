import 'package:flutter/material.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/screens/note_setup_screen.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'dart:math' as math;

class MyCustomFab extends StatelessWidget {
  final Label label;

  MyCustomFab({this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: 58,
      child: FloatingActionButton(
        backgroundColor: appWhite,
        child: Image.asset(
          'assets/icons/google-plus-icon.png',
          width: 24,
          height: 24,
        ),
        onPressed: () {
          if (label != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteSetupScreen(label: label)));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteSetupScreen()));
          }
        },
      ),
    );
  }
}

class MyCustomFabLocation extends FloatingActionButtonLocation {
  double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return kFloatingActionButtonMargin +
        scaffoldGeometry.minInsets.left -
        offset;
  }

  double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return scaffoldGeometry.scaffoldSize.width -
        kFloatingActionButtonMargin -
        scaffoldGeometry.minInsets.right -
        scaffoldGeometry.floatingActionButtonSize.width +
        offset;
  }

  double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    assert(scaffoldGeometry.textDirection != null);
    switch (scaffoldGeometry.textDirection) {
      case TextDirection.rtl:
        return _leftOffset(scaffoldGeometry, offset: offset);
      case TextDirection.ltr:
        return _rightOffset(scaffoldGeometry, offset: offset);
    }
    return null;
  }

  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 1.4;

    if (snackBarHeight > 0.0)
      fabY = math.min(fabY, contentBottom - snackBarHeight - fabHeight / 1.4);

    if (bottomSheetHeight > 0.0)
      // FIXME: THIS IS WRONG... IM ASSUMING I WONT SHOW ANY BOTTOM SHEETS IN THIS APP.
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 1.5);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = _endOffset(scaffoldGeometry, offset: -16);
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }
}
