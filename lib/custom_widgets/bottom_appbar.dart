import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';

import 'package:keep_notes_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MyNotchedBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var authBloc = Provider.of<AuthBloc>(context);

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
                backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    fileName: 'outline_check_box_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    fileName: 'outline_brush_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    fileName: 'outline_mic_none_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                backgroundColor: appTranslucentWhite,
                  pngIcon: PngIcon(
                    fileName: 'outline_photo_black_48.png',
                    iconColor: Colors.red,
                  ),
                  onTap: () {
                    authBloc.logout();
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
