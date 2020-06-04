import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/notifiers/note_create_edit_shared_state.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/models/note.dart';

class CreateEditNoteScreen extends StatelessWidget {
  final Note note;

  CreateEditNoteScreen({this.note});

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      return ChangeNotifierProvider<NoteCreateEditSharedState>(
        create: (context) => NoteCreateEditSharedState(),
        child: Scaffold(
            appBar: CreateEditNoteAppBar(),
            body: CreateEditNoteBody(),
            bottomNavigationBar: MyStickyBottomAppBar()),
      );
    }

    return ChangeNotifierProvider<NoteCreateEditSharedState>(
      create: (context) => NoteCreateEditSharedState.fromNote(note),
      child: Scaffold(
          appBar: CreateEditNoteAppBar(
            note: note,
          ),
          body: CreateEditNoteBody(
            editing: true,
          ),
          bottomNavigationBar: MyStickyBottomAppBar()),
    );
  }
}

class CreateEditNoteAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Note note;

  CreateEditNoteAppBar({this.note});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final noteCreateEditSharedState =
        Provider.of<NoteCreateEditSharedState>(context);
    final noteBloc = Provider.of<NoteTrackingBloc>(context);

    return AppBar(
      backgroundColor: noteCreateEditSharedState.selectedColor.getColor(),
      iconTheme: IconThemeData(color: appIconGrey),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var title = noteCreateEditSharedState.titleController.text;
            var text = noteCreateEditSharedState.textController.text;
            var colorIndex = noteCreateEditSharedState.selectedColorIndex;
            var pinned = noteCreateEditSharedState.isPinned;
            if (title.isNotEmpty || text.isNotEmpty) {
              if (note == null) {
                noteBloc.onCreateNewNote(
                    title, text, colorIndex, pinned, false);
              } else {
                note.title = title;
                note.text = text;
                note.colorIndex = colorIndex;
                note.pinned = pinned;
                noteBloc.onNoteEdited();
              }
            }
            noteCreateEditSharedState.closeLeftBottomSheet();
            noteCreateEditSharedState.closeRightBottomSheet();
            Navigator.pop(context);
          }),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PngIconButton(
              pngIcon: (noteCreateEditSharedState.isPinned)
                  ? PngIcon(fileName: 'baseline_push_pin_black_48.png')
                  : PngIcon(fileName: 'outline_push_pin_black_48.png'),
              onTap: () {
                var pinOrUnpin = (noteCreateEditSharedState.isPinned)
                    ? noteCreateEditSharedState.unpinNote
                    : noteCreateEditSharedState.pinNote;
                pinOrUnpin();
              }),
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
              onTap: () {
                var title = noteCreateEditSharedState.titleController.text;
                var text = noteCreateEditSharedState.textController.text;
                var colorIndex = noteCreateEditSharedState.selectedColorIndex;
                if (title.isNotEmpty || text.isNotEmpty) {
                  if (note == null) {
                    noteBloc.onCreateNewNote(
                        title, text, colorIndex, false, true);
                  } else {
                    note.title = title;
                    note.text = text;
                    note.colorIndex = colorIndex;
                    note.archived = true;
                    noteBloc.onNoteEdited();
                  }
                }
                noteCreateEditSharedState.closeLeftBottomSheet();
                noteCreateEditSharedState.closeRightBottomSheet();
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}

class CreateEditNoteBody extends StatelessWidget {
  final bool editing;

  CreateEditNoteBody({this.editing = false});

  @override
  Widget build(BuildContext context) {
    final noteCreateEditSharedState =
        Provider.of<NoteCreateEditSharedState>(context);

    return Container(
      color: noteCreateEditSharedState.selectedColor.getColor(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                padding:
                    EdgeInsets.only(top: 24, bottom: 40, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: noteCreateEditSharedState.titleController,
                      focusNode: noteCreateEditSharedState.titleFocusNode,
                      onTap: () {
                        noteCreateEditSharedState.closeLeftBottomSheet();
                        noteCreateEditSharedState.closeRightBottomSheet();
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
                      controller: noteCreateEditSharedState.textController,
                      focusNode: noteCreateEditSharedState.textFocusNode,
                      autofocus: (editing) ? false : true,
                      onTap: () {
                        noteCreateEditSharedState.closeLeftBottomSheet();
                        noteCreateEditSharedState.closeRightBottomSheet();
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
    final noteCreateEditSharedState =
        Provider.of<NoteCreateEditSharedState>(context);

    return Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: noteCreateEditSharedState.selectedColor.getColor(),
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
                          'first line of left tap.. open is ${noteCreateEditSharedState.leftBottomSheetOpen}');
                      if (noteCreateEditSharedState.leftBottomSheetOpen ==
                          false) {
                        noteCreateEditSharedState.titleFocusNode.unfocus();
                        noteCreateEditSharedState.textFocusNode.unfocus();
                        noteCreateEditSharedState.openLeftBottomSheet();
                        noteCreateEditSharedState.leftBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_leftBottomSheetBuilder);
                      } else {
                        noteCreateEditSharedState.closeLeftBottomSheet();
                      }
                      print(
                          'last line of left tap.. open is ${noteCreateEditSharedState.leftBottomSheetOpen}');
                    }),
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                    ),
                    onTap: () {
                      print(
                          'first line of right tap.. open is ${noteCreateEditSharedState.rightBottomSheetOpen}');
                      if (noteCreateEditSharedState.rightBottomSheetOpen ==
                          false) {
                        noteCreateEditSharedState.titleFocusNode.unfocus();
                        noteCreateEditSharedState.textFocusNode.unfocus();
                        noteCreateEditSharedState.openRightBottomSheet();
                        noteCreateEditSharedState.rightBottomSheetController =
                            Scaffold.of(context)
                                .showBottomSheet(_rightBottomSheetBuilder);
                      } else {
                        noteCreateEditSharedState.closeRightBottomSheet();
                      }
                      print(
                          'last line of right tap.. open is ${noteCreateEditSharedState.rightBottomSheetOpen}');
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
      NoteCreateEditSharedState noteCreateEditSharedState}) {
    return GestureDetector(
      onTap: () {
        noteCreateEditSharedState.selectedColorIndex = index;
      },
      child: Container(
        decoration: BoxDecoration(
            color: noteColor.getColor(),
            border: Border.all(width: 0.5, color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(20)),
        width: 32,
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Visibility(
            visible: noteCreateEditSharedState.selectedColorIndex == index,
            child: Icon(Icons.check)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteCreateEditSharedState =
        Provider.of<NoteCreateEditSharedState>(context);

    return Container(
      color: noteCreateEditSharedState.selectedColor.getColor(),
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
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 1,
              noteColor: NoteColor.red,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 2,
              noteColor: NoteColor.orange,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 3,
              noteColor: NoteColor.yellow,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 4,
              noteColor: NoteColor.green,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 5,
              noteColor: NoteColor.lightBlue,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 6,
              noteColor: NoteColor.mediumBlue,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 7,
              noteColor: NoteColor.darkBlue,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 8,
              noteColor: NoteColor.purple,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 9,
              noteColor: NoteColor.pink,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 10,
              noteColor: NoteColor.brown,
              noteCreateEditSharedState: noteCreateEditSharedState),
          _colorSelectionCircle(
              index: 11,
              noteColor: NoteColor.grey,
              noteCreateEditSharedState: noteCreateEditSharedState),
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
    final noteCreateEditSharedState =
        Provider.of<NoteCreateEditSharedState>(context);

    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      color: noteCreateEditSharedState.selectedColor.getColor(),
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
