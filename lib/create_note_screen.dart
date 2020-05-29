import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/notifiers/note_creation_shared_state.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteCreationSharedState>(
      create: (context) => NoteCreationSharedState(),
      child: Scaffold(
          appBar: CreateNoteAppBar(),
          body: CreateNoteBody(),
          bottomNavigationBar: MyStickyBottomAppBar()),
    );
  }
}

class CreateNoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final noteCreationSharedState =
        Provider.of<NoteCreationSharedState>(context);
    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return AppBar(
      backgroundColor: noteCreationSharedState.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGrey),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var title = noteCreationSharedState.titleController.text;
            var text = noteCreationSharedState.textController.text;
            var colorIndex = noteCreationSharedState.selectedColorIndex;
            noteBloc.onCreateNewNote(title, text, colorIndex);
            noteCreationSharedState.closeLeftBottomSheet();
            noteCreationSharedState.closeRightBottomSheet();
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
    final noteCreationSharedState =
        Provider.of<NoteCreationSharedState>(context);

    return Container(
      color: noteCreationSharedState.selectedColor.getColor(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                padding:
                    EdgeInsets.only(top: 24, bottom: 40, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: noteCreationSharedState.titleController,
                      focusNode: noteCreationSharedState.titleFocusNode,
                      onTap: () {
                        noteCreationSharedState.closeLeftBottomSheet();
                        noteCreationSharedState.closeRightBottomSheet();
                      },
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
                      controller: noteCreationSharedState.textController,
                      focusNode: noteCreationSharedState.textFocusNode,
                      autofocus: true,
                      onTap: () {
                        noteCreationSharedState.closeLeftBottomSheet();
                        noteCreationSharedState.closeRightBottomSheet();
                      },
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
    final noteCreationSharedState =
        Provider.of<NoteCreationSharedState>(context);

    return Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: noteCreationSharedState.selectedColor.getColor(),
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
                      print(
                          'first line of left tap.. open is ${noteCreationSharedState.leftBottomSheetOpen}');
                      if (noteCreationSharedState.leftBottomSheetOpen ==
                          false) {
                        noteCreationSharedState.titleFocusNode.unfocus();
                        noteCreationSharedState.textFocusNode.unfocus();
                        noteCreationSharedState.openLeftBottomSheet();
                        noteCreationSharedState.leftBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_leftBottomSheetBuilder);
                      } else {
                        noteCreationSharedState.closeLeftBottomSheet();
                      }
                      print(
                          'last line of left tap.. open is ${noteCreationSharedState.leftBottomSheetOpen}');
                    }),
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                    ),
                    onTap: () {
                      print(
                          'first line of right tap.. open is ${noteCreationSharedState.rightBottomSheetOpen}');
                      if (noteCreationSharedState.rightBottomSheetOpen ==
                          false) {
                        noteCreationSharedState.titleFocusNode.unfocus();
                        noteCreationSharedState.textFocusNode.unfocus();
                        noteCreationSharedState.openRightBottomSheet();
                        noteCreationSharedState.rightBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_rightBottomSheetBuilder);
                      } else {
                        noteCreationSharedState.closeRightBottomSheet();
                      }
                      print(
                          'last line of right tap.. open is ${noteCreationSharedState.rightBottomSheetOpen}');
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
      NoteCreationSharedState noteCreationSharedState}) {
    return GestureDetector(
      onTap: () {
        noteCreationSharedState.selectedColorIndex = index;
      },
      child: Container(
        decoration: BoxDecoration(
            color: noteColor.getColor(),
            border: Border.all(width: 0.5, color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(20)),
        width: 32,
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Visibility(
            visible: noteCreationSharedState.selectedColorIndex == index,
            child: Icon(Icons.check)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteCreationSharedState =
        Provider.of<NoteCreationSharedState>(context);

    return Container(
      color: noteCreationSharedState.selectedColor.getColor(),
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
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 1,
              noteColor: NoteColor.red,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 2,
              noteColor: NoteColor.orange,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 3,
              noteColor: NoteColor.yellow,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 4,
              noteColor: NoteColor.green,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 5,
              noteColor: NoteColor.lightBlue,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 6,
              noteColor: NoteColor.mediumBlue,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 7,
              noteColor: NoteColor.darkBlue,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 8,
              noteColor: NoteColor.purple,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 9,
              noteColor: NoteColor.pink,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 10,
              noteColor: NoteColor.brown,
              noteCreationSharedState: noteCreationSharedState),
          _colorSelectionCircle(
              index: 11,
              noteColor: NoteColor.grey,
              noteCreationSharedState: noteCreationSharedState),
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
    final noteCreationSharedState =
        Provider.of<NoteCreationSharedState>(context);

    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      color: noteCreationSharedState.selectedColor.getColor(),
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
