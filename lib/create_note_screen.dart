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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                    color: appWhite,
                    padding: EdgeInsets.only(
                        top: 24, bottom: 40, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 10,
                          cursorWidth: 1,
                          cursorColor: appIconGrey,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.5),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Title',
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2000,
                          cursorWidth: 1,
                          cursorColor: appIconGrey,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.5),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Note',
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
        bottomNavigationBar: MyStickyBottomAppBar());
  }
}
