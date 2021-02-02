import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/utils/styles.dart';

class BottomSheetTile extends StatelessWidget {
  final Key key;
  final PngIcon pngIcon;

  final String text;

  final NoteSetupScreenController noteSetupController;

  final void Function() onTap;

  BottomSheetTile(
      {this.key,
      @required this.pngIcon,
      @required this.text,
      @required this.onTap,
      @required this.noteSetupController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        height: mqScreenSize.width * 0.117,
        color: noteSetupController.selectedColor.getColor(),
        width: double.infinity,
        padding: EdgeInsets.only(left: mqScreenSize.width * 0.039),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            pngIcon,
            SizedBox(
              width: mqScreenSize.width * 0.058,
            ),
            Text(text, style: bottomSheetStyle(mqScreenSize.width))
          ],
        ),
      ),
    );
  }
}
