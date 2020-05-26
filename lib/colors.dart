import 'package:flutter/material.dart';

const appWhite = Color.fromARGB(255, 255, 255, 255);

const appTranslucentWhite = Color.fromARGB(244, 255, 255, 255);

const appIconGrey = Color.fromARGB(255, 95, 98, 103);

const appVeryDarkGrey = Color.fromARGB(255, 64, 64, 64);

const appCardTextGrey = Color.fromARGB(255, 88, 88, 88);

const appStatusBarIconsGrey = Color.fromARGB(255, 102, 102, 102);

const appCardBorderGrey = Color.fromARGB(255, 220, 220, 220);

const appDrawerItemSelected = Color.fromARGB(255, 253, 239, 194);

const appBlack = Color.fromARGB(255, 0, 0, 0);

abstract class NoteColor {
  const NoteColor();

  Color getColor();

  static const NoteColor white = _WhiteNoteColor();
  static const NoteColor darkBlue = _DarkBlueNoteColor();
  static const NoteColor mediumBlue = _MediumBlueNoteColor();
  static const NoteColor lightBlue = _LightBlueNoteColor();
  static const NoteColor purple = _PurpleNoteColor();
  static const NoteColor orange = _OrangeNoteColor();
  static const NoteColor green = _GreenNoteColor();
  static const NoteColor brown = _BrownNoteColor();
  static const NoteColor yellow = _YellowNoteColor();
  static const NoteColor grey = _GreyNoteColor();
  static const NoteColor red = _RedNoteColor();
  static const NoteColor pink = _PinkNoteColor();
}

class _WhiteNoteColor extends NoteColor {
  const _WhiteNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 255, 255);
}

class _DarkBlueNoteColor extends NoteColor {
  const _DarkBlueNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 175, 203, 250);
}

class _MediumBlueNoteColor extends NoteColor {
  const _MediumBlueNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 203, 240, 248);
}

class _LightBlueNoteColor extends NoteColor {
  const _LightBlueNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 167, 254, 235);
}

class _PurpleNoteColor extends NoteColor {
  const _PurpleNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 216, 173, 252);
}

class _OrangeNoteColor extends NoteColor {
  const _OrangeNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 250, 189, 3);
}

class _GreenNoteColor extends NoteColor {
  const _GreenNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 205, 255, 144);
}

class _BrownNoteColor extends NoteColor {
  const _BrownNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 230, 201, 169);
}

class _YellowNoteColor extends NoteColor {
  const _YellowNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 244, 118);
}

class _GreyNoteColor extends NoteColor {
  const _GreyNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 233, 234, 238);
}

class _RedNoteColor extends NoteColor {
  const _RedNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 242, 139, 130);
}

class _PinkNoteColor extends NoteColor {
  const _PinkNoteColor();

  @override
  Color getColor() => Color.fromARGB(255, 253, 207, 233);
}
