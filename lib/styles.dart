import 'package:flutter/material.dart';

const appWhite = Color.fromARGB(255, 255, 255, 255);

const appTranslucentWhite = Color.fromARGB(244, 255, 255, 255);

const appIconGrey = Color.fromARGB(255, 116, 116, 116);

final appLightThemeData = ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: appIconGrey),
);