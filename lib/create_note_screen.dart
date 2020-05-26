import 'package:flutter/material.dart';
import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/notifiers/note_color_selection.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteColorSelection>(
      create: (context) => NoteColorSelection(),
      child: Scaffold(
          appBar: CreateNoteAppBar(),
          body: CreateNoteBody(),
          bottomNavigationBar: MyStickyBottomAppBar()),
    );
  }
}

class CreateNoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);

    return AppBar(
      backgroundColor: noteColorSelection.selectedColor.getColor(),
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
    );
  }

  // This is some hacking of flutter's code for the appbar.. not recommended.
  // I did this just to have CreateNoteAppBar be accepted as an appBar in Scaffold
  // so I can put it into this separate widget and provide it with the state I want.
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CreateNoteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);

    return Container(
      color: noteColorSelection.selectedColor.getColor(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                
                padding:
                    EdgeInsets.only(top: 24, bottom: 40, left: 20, right: 20),
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
    );
  }
}
