import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/main.dart';

import 'package:keep_notes_clone/utils/colors.dart';

class MyNotchedBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = mqScreenSize.width;

    return BottomAppBar(
      color: appTranslucentWhite,
      notchMargin: screenWidth * 0.015,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: screenWidth * 0.117,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: screenWidth * 0.039),
        child: SizedBox(
          width: screenWidth * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PngIconButton(
                  backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    size: screenWidth * 0.058,
                    fileName: 'outline_check_box_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    size: screenWidth * 0.058,
                    fileName: 'outline_brush_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    size: screenWidth * 0.058,
                    fileName: 'outline_mic_none_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    size: screenWidth * 0.058,
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
