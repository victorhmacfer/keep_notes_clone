import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';

var cardTitleStyle = TextStyle(
    color: appBlack,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5);

var cardSmallTextStyle = TextStyle(
    color: appCardTextGreyForColoredBg,
    fontSize: 13,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5);

var cardBigTextStyle = TextStyle(
    color: appCardTextGreyForColoredBg,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5);

TextStyle searchAppBarStyle(double mediaQueryScreenWidth) {
  return TextStyle(
      color: appIconGrey,
      fontSize: mediaQueryScreenWidth * 0.039,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500);
}

TextStyle drawerItemStyle(double mediaQueryScreenWidth) => TextStyle(
    color: appBlack,
    fontSize: mediaQueryScreenWidth * 0.036,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2);

TextStyle drawerLabelsEditStyle(double mediaQueryScreenWidth) =>
    TextStyle(fontSize: mediaQueryScreenWidth * 0.025, fontWeight: FontWeight.w500, color: appIconGrey);

TextStyle bottomSheetStyle(double mediaQueryScreenWidth) => TextStyle(
    fontSize: mediaQueryScreenWidth * 0.039,
    color: appVeryDarkGreyForColoredBg);

var dialogFlatButtonTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: appSettingsBlue,
);

TextStyle noNotesMessageTextStyle(double mediaQueryScreenWidth) {
  return TextStyle(
      color: appBlack,
      fontSize: mediaQueryScreenWidth * 0.037, // fontSize aprox 15
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5);
}

final appLightThemeData = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
  ),
  iconTheme: IconThemeData(color: appIconGrey),
  hintColor: Colors.grey[400],
  textSelectionHandleColor: appVeryDarkGrey,
  canvasColor: appWhite,
);
