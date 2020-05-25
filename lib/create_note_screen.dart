import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';

class CreateNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appWhite,
          iconTheme: IconThemeData(color: appIconGrey),
          // elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: PngIconButton(
                  pngIcon: PngIcon(fileName: 'outline_archive_black_48.png'),
                  onTap: () {}),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: PngIconButton(
                  pngIcon: PngIcon(fileName: 'outline_add_alert_black_48.png'),
                  onTap: () {}),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: PngIconButton(
                  pngIcon: PngIcon(fileName: 'outline_archive_black_48.png'),
                  onTap: () {}),
            ),
          ],
        ),
        body: Container(
          color: Colors.red[200],
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                    color: appWhite,
                    child: TextField(
                      maxLines: 80,
                    )),
              )
            ],
          ),
        ),
        bottomNavigationBar: MyStickyBottomAppBar());
  }
}
