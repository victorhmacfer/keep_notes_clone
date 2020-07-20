import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const appWhite = Color.fromARGB(255, 255, 255, 255);

const appTranslucentWhite = Color.fromARGB(244, 255, 255, 255);

const appIconGrey = Color.fromARGB(255, 102, 102, 102);

const appVeryDarkGrey = Color.fromARGB(255, 48, 48, 48);

const appCardTextGrey = Color.fromARGB(255, 88, 88, 88);

const appStatusBarIconsGrey = Color.fromARGB(255, 102, 102, 102);

const appCardBorderGrey = Color.fromARGB(255, 220, 220, 220);

const appDrawerItemSelected = Color.fromARGB(255, 253, 239, 194);

const appBlack = Color.fromARGB(255, 0, 0, 0);

const appGreyForColoredBg = Color.fromRGBO(0, 0, 0, 0.3);

const appVeryDarkGreyForColoredBg =
    Color.fromRGBO(0, 0, 0, 0.81); // (48-255)/(0-255)

const appIconGreyForColoredBg =
    Color.fromRGBO(0, 0, 0, 0.6); // (102-255)/(0-255)

const appCardTextGreyForColoredBg =
    Color.fromRGBO(0, 0, 0, 0.655); // (88-255)/(0-255)

const appSettingsBlue = Color.fromARGB(255, 26, 113, 228);

final appDividerGrey = Colors.grey[300];

abstract class NoteColor extends Equatable {
  const NoteColor();

  Color getColor();

  int get index;

  @override
  List<Object> get props => [index];

  static const NoteColor white = _WhiteNoteColor();
  static const NoteColor darkBlue = _DarkBlueNoteColor();
  static const NoteColor blue = _BlueNoteColor();
  static const NoteColor cyan = _CyanNoteColor();
  static const NoteColor purple = _PurpleNoteColor();
  static const NoteColor orange = _OrangeNoteColor();
  static const NoteColor green = _GreenNoteColor();
  static const NoteColor brown = _BrownNoteColor();
  static const NoteColor yellow = _YellowNoteColor();
  static const NoteColor grey = _GreyNoteColor();
  static const NoteColor red = _RedNoteColor();
  static const NoteColor pink = _PinkNoteColor();

  static NoteColor getNoteColorFromIndex(int index) {
    assert(((index >= 0) && (index <= 11)),
        'NoteColor index should be:  0 <= index <= 11');

    var noteColors = [
      NoteColor.white,
      NoteColor.red,
      NoteColor.orange,
      NoteColor.yellow,
      NoteColor.green,
      NoteColor.cyan,
      NoteColor.blue,
      NoteColor.darkBlue,
      NoteColor.purple,
      NoteColor.pink,
      NoteColor.brown,
      NoteColor.grey,
    ];
    return noteColors[index];
  }
}

class _WhiteNoteColor extends NoteColor {
  const _WhiteNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 255, 255);

  int get index => 0;
}

class _RedNoteColor extends NoteColor {
  const _RedNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 242, 139, 130);

  int get index => 1;
}

class _OrangeNoteColor extends NoteColor {
  const _OrangeNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 250, 189, 3);

  int get index => 2;
}

class _YellowNoteColor extends NoteColor {
  const _YellowNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 244, 118);

  int get index => 3;
}

class _GreenNoteColor extends NoteColor {
  const _GreenNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 205, 255, 144);

  int get index => 4;
}

class _CyanNoteColor extends NoteColor {
  const _CyanNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 167, 254, 235);

  int get index => 5;
}

class _BlueNoteColor extends NoteColor {
  const _BlueNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 203, 240, 248);

  int get index => 6;
}

class _DarkBlueNoteColor extends NoteColor {
  const _DarkBlueNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 175, 203, 250);

  int get index => 7;
}

class _PurpleNoteColor extends NoteColor {
  const _PurpleNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 216, 173, 252);

  int get index => 8;
}

class _PinkNoteColor extends NoteColor {
  const _PinkNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 253, 207, 233);

  int get index => 9;
}

class _BrownNoteColor extends NoteColor {
  const _BrownNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 230, 201, 169);

  int get index => 10;
}

class _GreyNoteColor extends NoteColor {
  const _GreyNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 233, 234, 238);

  int get index => 11;
}
