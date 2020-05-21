import 'package:flutter/material.dart';

const appWhite = Color.fromARGB(255, 255, 255, 255);

// const appIconGrey = Color.fromARGB(255, 116, 116, 116);

const appTranslucentWhite = Color.fromARGB(244, 255, 255, 255);

const appIconGrey = Color.fromARGB(255, 95, 98, 103);

const appCardTextGrey = Color.fromARGB(255, 88, 88, 88);

const appStatusBarIconsGrey = Color.fromARGB(255, 102, 102, 102);

const appCardBorderGrey = Color.fromARGB(255, 220, 220, 220);

const appBlack = Color.fromARGB(255, 0, 0, 0);

abstract class CardColor {
  const CardColor();

  Color getColor();

  static const CardColor white = _WhiteCardColor();
  static const CardColor darkBlue = _DarkBlueCardColor();
  static const CardColor mediumBlue = _MediumBlueCardColor();
  static const CardColor lightBlue = _LightBlueCardColor();
  static const CardColor purple = _PurpleCardColor();
  static const CardColor gold = _GoldCardColor();
  static const CardColor green = _GreenCardColor();
  static const CardColor brown = _BrownCardColor();
  static const CardColor yellow = _YellowCardColor();
  static const CardColor grey = _GreyCardColor();
  static const CardColor red = _RedCardColor();
  static const CardColor pink = _PinkCardColor();
}

class _WhiteCardColor extends CardColor {
  const _WhiteCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 255, 255);
}

class _DarkBlueCardColor extends CardColor {
  const _DarkBlueCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 175, 203, 250);
}

class _MediumBlueCardColor extends CardColor {
  const _MediumBlueCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 203, 240, 248);
}

class _LightBlueCardColor extends CardColor {
  const _LightBlueCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 167, 254, 235);
}

class _PurpleCardColor extends CardColor {
  const _PurpleCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 216, 173, 252);
}

class _GoldCardColor extends CardColor {
  const _GoldCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 250, 189, 3);
}

class _GreenCardColor extends CardColor {
  const _GreenCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 205, 255, 144);
}

class _BrownCardColor extends CardColor {
  const _BrownCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 230, 201, 169);
}

class _YellowCardColor extends CardColor {
  const _YellowCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 255, 244, 118);
}

class _GreyCardColor extends CardColor {
  const _GreyCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 233, 234, 238);
}

class _RedCardColor extends CardColor {
  const _RedCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 242, 139, 130);
}

class _PinkCardColor extends CardColor {
  const _PinkCardColor();

  @override
  Color getColor() => Color.fromARGB(255, 253, 207, 233);
}
