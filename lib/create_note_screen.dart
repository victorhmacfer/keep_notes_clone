import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/notifiers/note_color_selection.dart';
import 'package:keep_notes_clone/styles.dart';
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
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final noteColorSelection = Provider.of<NoteColorSelection>(context);
    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return AppBar(
      backgroundColor: noteColorSelection.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGrey),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var title = noteColorSelection.titleController.text;
            var text = noteColorSelection.textController.text;
            var colorIndex = noteColorSelection.selectedColorIndex;
            noteBloc.onCreateNewNote(title, text, colorIndex);
            Navigator.pop(context);
          }),
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
                      controller: noteColorSelection.titleController,
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
                      controller: noteColorSelection.textController,
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

class MyStickyBottomAppBar extends StatelessWidget {
  Widget _leftBottomSheetBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_camera_black_48.png'),
            text: 'Take photo',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_photo_black_48.png'),
            text: 'Add image',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_brush_black_48.png'),
            text: 'Drawing',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_mic_none_black_48.png'),
            text: 'Recording',
          ),
          _CreateNoteBottomSheetTile(
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
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_delete_black_48.png'),
            text: 'Delete',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_file_copy_black_48.png'),
            text: 'Make a copy',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_share_black_48.png'),
            text: 'Send',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_person_add_black_48.png'),
            text: 'Collaborator',
          ),
          _CreateNoteBottomSheetTile(
            pngIcon: PngIcon(fileName: 'outline_label_black_48.png'),
            text: 'Labels',
          ),
          _ColorSelectionList(),
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

class _ColorSelectionList extends StatelessWidget {
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

class _CreateNoteBottomSheetTile extends StatelessWidget {
  final PngIcon pngIcon;

  final String text;

  final NoteColor color;

  _CreateNoteBottomSheetTile({this.pngIcon, this.text, this.color});

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
