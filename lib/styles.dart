import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';

var cardTitleStyle = TextStyle(
    color: appBlack,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600);

var cardSmallTextStyle = TextStyle(
    color: appCardTextGrey,
    fontSize: 13,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);

var cardBigTextStyle = TextStyle(
    color: appCardTextGrey,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);

var searchAppBarStyle = TextStyle(
    color: appIconGrey,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);

var drawerItemStyle = TextStyle(
    color: appBlack,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);

var drawerLabelsEditStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: appIconGrey);

final appLightThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: appIconGrey),
    canvasColor: appWhite);
