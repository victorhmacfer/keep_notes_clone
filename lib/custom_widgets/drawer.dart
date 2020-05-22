import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';

import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/styles.dart';

final _selectedBorderRadius = BorderRadius.only(
    topRight: Radius.circular(48), bottomRight: Radius.circular(48));

final _selectedMargin = EdgeInsets.only(right: 8);

const double _drawerItemHeight = 48;

const double _iconToTextSpacing = 16;

class SelectableDrawerItem extends StatelessWidget {
  final String text;

  final bool selected;

  final String iconFileName;

  SelectableDrawerItem(this.text,
      {this.iconFileName = 'outline_label_black_48.png', this.selected});

  @override
  Widget build(BuildContext context) {
    // THIS IS TRASH DESIGN but will do for now.
    var pngIcon = (iconFileName == 'keep-quadrado.png')
        ? PngIcon(
            fileName: iconFileName,
            size: 22,
          )
        : PngIcon(fileName: iconFileName);

    return Container(
      height: _drawerItemHeight,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24),
      margin: (selected) ? _selectedMargin : EdgeInsets.zero,
      decoration: BoxDecoration(
          color: (selected) ? appDrawerItemSelected : appWhite,
          borderRadius: (selected) ? _selectedBorderRadius : BorderRadius.zero),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          pngIcon,
          SizedBox(
            width: _iconToTextSpacing,
          ),
          Text(
            text,
            style: drawerItemStyle,
          ),
        ],
      ),
    );
  }
}

class SimpleDrawerItem extends StatelessWidget {
  final String text;

  final String iconFileName;

  SimpleDrawerItem({@required this.text, @required this.iconFileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _drawerItemHeight,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PngIcon(fileName: iconFileName),
          SizedBox(
            width: _iconToTextSpacing,
          ),
          Text(
            text,
            style: drawerItemStyle,
          ),
        ],
      ),
    );
  }
}

class MyCustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      color: appWhite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/icons/google-logo.png',
            width: 64,
          ),
          Text(
            ' Keep',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: appIconGrey),
          )
        ],
      ),
    );
  }
}

class MyCustomDrawerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey[300],
      margin: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
