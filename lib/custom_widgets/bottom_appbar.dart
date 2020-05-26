import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';

import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/notifiers/note_color_selection.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

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

class MyStickyBottomAppBar extends StatelessWidget {
  Widget _bottomSheetTile(PngIcon pngIcon, String text) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          pngIcon,
          SizedBox(
            width: 24,
          ),
          Text(text, style: bottomSheetStyle)
        ],
      ),
    );
  }

  Widget _leftBottomSheetBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_camera_black_48.png'),
            text: 'Take photo',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_black_48.png'),
            text: 'Add image',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_brush_black_48.png'),
            text: 'Drawing',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_mic_none_black_48.png'),
            text: 'Recording',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_check_box_black_48.png'),
            text: 'Checkboxes',
          ),
        ],
      ),
    );
  }

  Widget _rightBottomSheetBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_delete_black_48.png'),
            text: 'Delete',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_file_copy_black_48.png'),
            text: 'Make a copy',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_share_black_48.png'),
            text: 'Send',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_person_add_black_48.png'),
            text: 'Collaborator',
          ),
          CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_label_black_48.png'),
            text: 'Labels',
          ),
          ColorSelectionList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);

    return Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: noteColorSelection.selectedColor.getColor(),
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_add_box_black_48.png',
                    ),
                    onTap: () {
                      Scaffold.of(context)
                          .showBottomSheet(_leftBottomSheetBuilder);
                    }),
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                    ),
                    onTap: () {
                      Scaffold.of(context)
                          .showBottomSheet(_rightBottomSheetBuilder);
                    })
              ],
            ),
          ),
        ));
  }
}

class ColorSelectionList extends StatelessWidget {
  Widget _colorSelectionCircle(
      {NoteColor noteColor,
      int index,
      NoteColorSelection colorSelectionState}) {
    return GestureDetector(
      onTap: () {
        colorSelectionState.selectedColorIndex = index;
      },
      child: Container(
        decoration: BoxDecoration(
            color: noteColor.getColor(),
            border: Border.all(width: 0.5, color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(20)),
        width: 32,
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Visibility(
            visible: colorSelectionState.selectedColorIndex == index,
            child: Icon(Icons.check)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);

    return Container(
      color: noteColorSelection.selectedColor.getColor(),
      height: 52,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          _colorSelectionCircle(
              index: 0,
              noteColor: NoteColor.white,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 1,
              noteColor: NoteColor.red,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 2,
              noteColor: NoteColor.orange,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 3,
              noteColor: NoteColor.yellow,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 4,
              noteColor: NoteColor.green,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 5,
              noteColor: NoteColor.lightBlue,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 6,
              noteColor: NoteColor.mediumBlue,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 7,
              noteColor: NoteColor.darkBlue,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 8,
              noteColor: NoteColor.purple,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 9,
              noteColor: NoteColor.pink,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 10,
              noteColor: NoteColor.brown,
              colorSelectionState: noteColorSelection),
          _colorSelectionCircle(
              index: 11,
              noteColor: NoteColor.grey,
              colorSelectionState: noteColorSelection),
          SizedBox(
            width: 6,
          )
        ],
      ),
    );
  }
}

class CreateNoteBottomSheetTile extends StatelessWidget {
  final PngIcon pngIcon;

  final String text;

  CreateNoteBottomSheetTile({this.pngIcon, this.text});

  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);

    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      color: noteColorSelection.selectedColor.getColor(),
      width: double.infinity,
      padding: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          pngIcon,
          SizedBox(
            width: 24,
          ),
          Text(text, style: bottomSheetStyle)
        ],
      ),
    );
  }
}
