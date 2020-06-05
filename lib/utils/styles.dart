import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';

var cardTitleStyle = TextStyle(
    color: appBlack,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5);

var cardSmallTextStyle = TextStyle(
    color: appCardTextGrey,
    fontSize: 13,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5);

var cardBigTextStyle = TextStyle(
    color: appCardTextGrey,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5);

var searchAppBarStyle = TextStyle(
    color: appIconGrey,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);

var drawerItemStyle = TextStyle(
    color: appBlack,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2);

var drawerLabelsEditStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: appIconGrey);

var bottomSheetStyle = TextStyle(fontSize: 16, color: appVeryDarkGrey);

final appLightThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: appIconGrey),
    hintColor: Colors.grey[400],
    canvasColor: appWhite);
