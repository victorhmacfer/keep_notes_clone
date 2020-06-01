import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';

import 'package:keep_notes_clone/colors.dart';

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return BottomAppBar(
      color: appTranslucentWhite,
      notchMargin: 6,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 48,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
        child: SizedBox(
          width: screenWidth * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_check_box_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_brush_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_mic_none_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_photo_black_48.png',
                  ),
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}